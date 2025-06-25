# Tokenized Event Vendor Coordination System

A comprehensive blockchain-based system for coordinating event planning services between event planners and vendors using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a decentralized platform for event planning that includes vendor verification, service coordination, secure payments, and performance evaluation. All interactions are recorded on the blockchain for transparency and trust.

## System Architecture

### Core Contracts

1. **Event Planner Verification Contract** (`event-planner-verification.clar`)
    - Manages event planner registration and verification
    - Tracks reputation scores and completed events
    - Handles verification requests and approvals

2. **Vendor Management Contract** (`vendor-management.clar`)
    - Handles vendor registration across multiple categories
    - Manages vendor services and pricing
    - Tracks vendor availability and status

3. **Service Coordination Contract** (`service-coordination.clar`)
    - Coordinates service requests between planners and vendors
    - Manages event coordination and vendor confirmations
    - Tracks service request statuses

4. **Payment Processing Contract** (`payment-processing.clar`)
    - Handles secure escrow payments
    - Manages payment releases and refunds
    - Tracks payment history and balances

5. **Performance Evaluation Contract** (`performance-evaluation.clar`)
    - Records vendor performance ratings
    - Tracks service completion records
    - Calculates vendor reliability scores

## Features

### For Event Planners
- ✅ Verification system with document submission
- ✅ Service request creation and management
- ✅ Secure escrow payment system
- ✅ Vendor performance evaluation
- ✅ Event coordination dashboard

### For Vendors
- ✅ Multi-category registration system
- ✅ Service listing and pricing management
- ✅ Request acceptance/rejection workflow
- ✅ Performance tracking and ratings
- ✅ Payment management

### System Benefits
- 🔒 **Security**: All transactions secured by blockchain
- 🌐 **Transparency**: Public record of all interactions
- 💰 **Escrow Protection**: Secure payment holding until service completion
- ⭐ **Reputation System**: Performance-based vendor ratings
- 📊 **Analytics**: Comprehensive performance tracking

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js for testing

### Installation

1. Clone the repository
   \`\`\`bash
   git clone <repository-url>
   cd tokenized-event-vendor-system
   \`\`\`

2. Install dependencies
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests
   \`\`\`bash
   npm test
   \`\`\`

### Contract Deployment

Deploy contracts in the following order:
1. `event-planner-verification.clar`
2. `vendor-management.clar`
3. `service-coordination.clar`
4. `payment-processing.clar`
5. `performance-evaluation.clar`

## Usage Examples

### Event Planner Registration
\`\`\`clarity
(contract-call? .event-planner-verification register-planner "document-hash-123")
\`\`\`

### Vendor Registration
\`\`\`clarity
(contract-call? .vendor-management register-vendor "Acme Catering" "catering")
\`\`\`

### Service Request Creation
\`\`\`clarity
(contract-call? .service-coordination create-service-request vendor-principal u1 u1000 u50 u5000)
\`\`\`

### Payment Processing
\`\`\`clarity
(contract-call? .payment-processing create-payment vendor-principal u5000 u1)
\`\`\`

## Vendor Categories

The system supports the following vendor categories:
- **Catering**: Food and beverage services
- **Photography**: Event photography and videography
- **Music**: DJ services and live entertainment
- **Decoration**: Event decoration and styling
- **Venue**: Event venue management
- **Security**: Event security services
- **Transportation**: Guest transportation services
- **Equipment**: Audio/visual and other equipment rental

## Testing

The system includes comprehensive tests using Vitest:

\`\`\`bash
npm run test
\`\`\`

Tests cover:
- Contract deployment and initialization
- Event planner verification workflow
- Vendor registration and management
- Service coordination processes
- Payment processing and escrow
- Performance evaluation system

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## Security Considerations

- All payments are held in escrow until service completion
- Only verified event planners can create service requests
- Vendor ratings are immutable once submitted
- Contract ownership is clearly defined and restricted

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository or contact the development team.

