# Star Chart API

A Phoenix REST API application that provides information on star systems.

## API Documentation

See API endpoint documentation in [API.md](./API.md).

You can view the interactive OpenAPI schema for the Star Chart API by visiting `/api/openapi` on your running server.

## Getting Started

### Prerequisites

- Elixir 1.14 or later
- Erlang 25 or later
- PostgreSQL

### Installation

1. Clone the repository
2. Install dependencies: `mix deps.get`
3. Download source data: `mix data.setup`
4. Run migrations: `mix ecto.migrate`

### Running locally

- Run `mix phx.server`

#### User Authentication

User authentication is handled by magic link tokens sent via email. In development, a simulated local mail server is used. You can view outgoing messages at [http://localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox).
