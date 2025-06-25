;; Payment Processing Contract
;; Handles payments between event planners and vendors

(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_INSUFFICIENT_FUNDS (err u401))
(define-constant ERR_NOT_FOUND (err u402))
(define-constant ERR_INVALID_STATUS (err u403))
(define-constant ERR_PAYMENT_ALREADY_EXISTS (err u404))

;; Data structures
(define-map payments
  uint
  {
    payer: principal,
    payee: principal,
    amount: uint,
    service-request-id: uint,
    status: (string-ascii 20),
    created-at: uint,
    completed-at: (optional uint)
  }
)

(define-map escrow-balances
  principal
  uint
)

(define-data-var next-payment-id uint u1)

;; Public functions
(define-public (create-payment (payee principal) (amount uint) (service-request-id uint))
  (let (
    (payer tx-sender)
    (payment-id (var-get next-payment-id))
  )
    (asserts! (>= (stx-get-balance payer) amount) ERR_INSUFFICIENT_FUNDS)
    (try! (stx-transfer? amount payer (as-contract tx-sender)))
    (map-set payments payment-id {
      payer: payer,
      payee: payee,
      amount: amount,
      service-request-id: service-request-id,
      status: "escrowed",
      created-at: block-height,
      completed-at: none
    })
    (map-set escrow-balances payee
      (+ (default-to u0 (map-get? escrow-balances payee)) amount))
    (var-set next-payment-id (+ payment-id u1))
    (ok payment-id)
  )
)

(define-public (release-payment (payment-id uint))
  (let (
    (payment (unwrap! (map-get? payments payment-id) ERR_NOT_FOUND))
    (payer (get payer payment))
    (payee (get payee payment))
    (amount (get amount payment))
  )
    (asserts! (is-eq tx-sender payer) ERR_UNAUTHORIZED)
    (asserts! (is-eq (get status payment) "escrowed") ERR_INVALID_STATUS)
    (try! (as-contract (stx-transfer? amount tx-sender payee)))
    (map-set payments payment-id
      (merge payment {
        status: "completed",
        completed-at: (some block-height)
      }))
    (map-set escrow-balances payee
      (- (default-to u0 (map-get? escrow-balances payee)) amount))
    (ok true)
  )
)

(define-public (refund-payment (payment-id uint))
  (let (
    (payment (unwrap! (map-get? payments payment-id) ERR_NOT_FOUND))
    (payer (get payer payment))
    (payee (get payee payment))
    (amount (get amount payment))
  )
    (asserts! (or (is-eq tx-sender payer) (is-eq tx-sender payee)) ERR_UNAUTHORIZED)
    (asserts! (is-eq (get status payment) "escrowed") ERR_INVALID_STATUS)
    (try! (as-contract (stx-transfer? amount tx-sender payer)))
    (map-set payments payment-id
      (merge payment {
        status: "refunded",
        completed-at: (some block-height)
      }))
    (map-set escrow-balances payee
      (- (default-to u0 (map-get? escrow-balances payee)) amount))
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-payment (payment-id uint))
  (map-get? payments payment-id)
)

(define-read-only (get-escrow-balance (vendor principal))
  (default-to u0 (map-get? escrow-balances vendor))
)
