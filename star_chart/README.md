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

| Method | Endpoint                   | Description                       |
| ------ | -------------------------- | --------------------------------- |
| GET    | `/api/v1/star_systems`     | List all star systems (paginated) |
| GET    | `/api/v1/star_systems/:id` | Get a specific star system by ID  |

#### Pagination

The star systems endpoint supports pagination through the following query parameters:

- `page`: The page number to retrieve (default: 1, min: 1)
- `page_size`: Number of items per page (default: 100, min: 1, max: 200)

Example: `/api/v1/star_systems?page=2&page_size=50`

#### Response Format

```json
{
  "data": [
    {
      "id": 1,
      "name": "Sol"
    },
    {
      "id": 2,
      "name": "Alpha Centauri"
    },
    ...
  ],
  "meta": {
    "page": 1,
    "page_size": 100,
    "total_entries": 42,
    "total_pages": 3
  }
}
```

The response includes:

- `data`: Array of star systems for the current page
- `meta`: Pagination metadata
  - `page`: Current page number
  - `page_size`: Number of items per page
  - `total_entries`: Total number of star systems in the database
  - `total_pages`: Total number of pages available

## Learn More

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
