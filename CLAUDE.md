# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Development Server
- `bin/dev` - **Primary development command** (Rails + CSS watcher)
- `bin/jobs start` - Start Solid Queue background job worker
- `rails server` - Start Rails only (without CSS watching)

### Testing
- `rails test` - Run the full test suite using minitest with factory_bot
- `rails test test/models/` - Run model tests only
- `rails test test/controllers/` - Run controller tests only  
- `rails test test/system/` - Run system tests
- `rails test test/jobs/` - Run background job tests
- `rails test test/path/to/specific_test.rb` - Run a specific test file

### Database Operations
- `rails db:migrate` - Run pending database migrations
- `rails db:seed` - Seed the database with sample data (includes development user: a@d)
- `rails db:reset` - Drop, create, migrate and seed database

### Asset Building
- `npm run build:css` - Build CSS assets using Sass (Bootstrap-based)
- `npm run build:css --watch` - Watch CSS files for changes (included in bin/dev)
- `rails assets:precompile` - Precompile assets for production

### Code Quality
- `rubocop` - Run Ruby style checker (Omakase styling)
- `rubocop -a` - Auto-fix correctable style issues
- `brakeman` - Run security vulnerability scanner

### Development Tools
- `rails transaction:simulate` - Simulate random card transaction
- `rails transaction:simulate[CARD_ID]` - Simulate transaction for specific card
- Email preview: `http://localhost:3000/letter_opener`

## Application Architecture

### Core Domain
This is a credit card application prototype (`CreditCardXardPrototype`) built with Rails 8.0 that handles:

- **Individual and Corporate Card Applications**: Supports both personal and business credit card applications
- **eKYC/KYB Processing**: Electronic Know Your Customer for individuals and businesses  
- **Credit Scoring Integration**: External credit assessment via APIs and webhooks
- **Card Management**: Issuance, limits, and increase applications
- **Transaction & Point Systems**: Transaction tracking and community point rewards
- **Statement & Payment Processing**: Monthly statements with payment handling

### Key Models
- `User` - Individual applicants with Devise authentication
- `Corporation` - Business entities for corporate cards
- `CardApplication` - Applications for both individual and corporate cards
- `Card` - Issued cards with credit limits and temporary limits
- `Transaction` - Card transaction records
- `Statement` - Monthly billing statements
- `Payment` - Payment records against statements
- `LimitIncreaseApplication` - Credit limit increase requests
- `PointTransaction` - Community point transactions

### API Structure
- **REST APIs** (`/api/v1/`): External service integrations for eKYC, credit scoring, card issuance
- **Webhooks** (`/webhooks/`): Status updates from external services
- **Authentication**: Uses Devise for user sessions

### Background Jobs
Uses Solid Queue (Rails 8) for:
- `EkycProcessingJob` / `KybProcessingJob` - Identity verification
- `CreditScoringJob` / `CorporateCreditScoringJob` - Credit assessment  
- `CardIssuanceJob` - Card creation and provisioning
- `LimitIncreaseScoringJob` - Limit increase processing
- `GrantCommunityPointsJob` - Point rewards

### Localization
- Default locale: Japanese (`:ja`)
- Timezone: Tokyo
- Uses Rails i18n with Japanese translations

### Database
- Uses MySQL2 adapter
- Includes comprehensive migrations in `db/migrate/`
- Seeds file for development data

### Frontend
- Rails 8 with Importmap, Turbo, and Stimulus
- Bootstrap 5.3+ for styling with Sass
- CSS bundling via `cssbundling-rails`

### Testing Strategy
- **Framework**: Minitest with parallel test execution
- **Test Data**: factory_bot_rails for dynamic test data generation
- **Factories Available**: users, corporations, cards, card_applications, transactions
- **Factory Usage**: `create(:user)`, `create(:card, :corporate)`, `build(:transaction, :large_amount)`
- **External APIs**: WebMock for HTTP request mocking
- **System Tests**: Capybara + Selenium for end-to-end testing
- **Legacy**: Some fixtures still exist but prefer factory_bot for new tests

### Email
- Uses `letter_opener_web` in development for email preview at `/letter_opener`
- Mailers for application status notifications and delinquency reminders
- All emails sent via `deliver_later` (async via Solid Queue)

## Development Workflow

### Typical Development Setup
1. `bin/dev` - Start Rails + CSS watcher
2. `bin/jobs start` - Start background job worker (separate terminal)
3. Visit `http://localhost:3000`
4. Login with development user: `a@d` / `password`

### Testing Transaction Flow
1. Create card application via UI or use existing cards
2. `rails transaction:simulate[CARD_ID]` - Simulate card usage
3. Check transaction history in browser
4. Verify point rewards in point transaction history
5. Check email notifications at `/letter_opener`

### Architecture Patterns

#### Webhook Integration
- External services send webhooks to `/webhooks/*` endpoints
- Controllers process incoming data and trigger background jobs
- Example: Card transactions → GrantCommunityPointsJob → Point rewards

#### Background Jobs (Solid Queue)
- All time-intensive operations run in background
- Jobs are queued via `perform_later`
- Monitor with `bin/jobs start` output

#### API Design
- **External APIs** (`/api/v1/`): Mock external service integrations
- **Webhooks** (`/webhooks/`): Receive data from external systems
- All APIs return JSON and handle errors gracefully

#### Security Considerations
- CSRF protection disabled for webhook endpoints only
- Devise authentication for user-facing features
- brakeman for security vulnerability scanning
- Input validation on all models

## Development Notes

### Database Schema Evolution
- Use migrations for all schema changes
- Seed file contains development user (`a@d`) and sample data
- Foreign key constraints enforce data integrity

### CSS/Asset Pipeline
- Uses cssbundling-rails (not sprockets)
- Bootstrap 5.3+ with custom SCSS variables
- CSS changes require `bin/dev` or manual `npm run build:css --watch`

### Testing Philosophy
- Test business logic thoroughly in models
- Test API integrations with WebMock
- Use factory_bot for realistic test scenarios
- System tests for critical user flows only

### Common Debugging
- Check Rails logs for application errors
- Check `bin/jobs start` output for background job issues
- Use `/letter_opener` for email debugging
- `rails console` for database queries and model testing