# StarChart

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

# Star Chart API

A Phoenix REST API application that provides information on star systems.

## Getting Started

### Prerequisites

- Elixir 1.14 or later
- Erlang 25 or later
- PostgreSQL

### Installation

1. Clone the repository
2. Install dependencies with `mix deps.get`
3. Create and migrate your database with `mix ecto.setup`
4. Start Phoenix server with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## API Endpoints

### Star Systems

| Method | Endpoint                   | Description                      |
| ------ | -------------------------- | -------------------------------- |
| GET    | `/api/v1/star_systems`     | List all star systems            |
| GET    | `/api/v1/star_systems/:id` | Get a specific star system by ID |

#### Response Format

```json
{
  "data": [
    {
      "id": 1,
      "name": "Sol",
      "distance_light_years": 0.0000158,
      "spectral_type": "G2V",
      "description": "Our home star system, containing Earth and 7 other planets."
    },
    ...
  ]
}
```

## Learn More

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
