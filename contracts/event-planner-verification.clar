;; Event Planner Verification Contract
;; Manages verification and registration of event planners

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_VERIFIED (err u101))
(define-constant ERR_NOT_FOUND (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Data structures
(define-map event-planners
  principal
  {
    verified: bool,
    registration-date: uint,
    reputation-score: uint,
    events-completed: uint
  }
)

(define-map verification-requests
  principal
  {
    requested-at: uint,
    status: (string-ascii 20),
    documents-hash: (string-ascii 64)
  }
)

;; Public functions
(define-public (register-planner (documents-hash (string-ascii 64)))
  (let ((planner tx-sender))
    (asserts! (is-none (map-get? event-planners planner)) ERR_ALREADY_VERIFIED)
    (map-set verification-requests planner {
      requested-at: block-height,
      status: "pending",
      documents-hash: documents-hash
    })
    (ok true)
  )
)

(define-public (verify-planner (planner principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (is-some (map-get? verification-requests planner)) ERR_NOT_FOUND)
    (map-set event-planners planner {
      verified: true,
      registration-date: block-height,
      reputation-score: u100,
      events-completed: u0
    })
    (map-delete verification-requests planner)
    (ok true)
  )
)

(define-public (update-reputation (planner principal) (new-score uint))
  (let ((planner-data (unwrap! (map-get? event-planners planner) ERR_NOT_FOUND)))
    (asserts! (get verified planner-data) ERR_UNAUTHORIZED)
    (map-set event-planners planner (merge planner-data {reputation-score: new-score}))
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-planner-info (planner principal))
  (map-get? event-planners planner)
)

(define-read-only (is-verified-planner (planner principal))
  (match (map-get? event-planners planner)
    planner-data (get verified planner-data)
    false
  )
)

(define-read-only (get-verification-request (planner principal))
  (map-get? verification-requests planner)
)
