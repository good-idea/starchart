# Star Chart API Client

A TypeScript client for the Star Chart API.

## Installation

```bash
npm install @starchart/client
# or
yarn add @starchart/client
```

## Usage

```typescript
import { createClient } from '@starchart/client'

// Create a client instance
const client = createClient({
  baseURL: 'http://localhost:4000/api', // default
  version: 'v1' // default
})

// Get a list of star systems
const starSystems = await client.starSystems({
  page: 1,
  page_size: 10,
  spectral_class: 'G',
})
```

## API Reference

### `createClient(options?: ClientOptions)`

Creates a client for interacting with the Star Chart API.

**Options:**

- `baseURL`: Base URL for the API (default: 'http://localhost:4000/api')
- `version`: API version (default: 'v1')
- `fetchOptions`: Additional fetch configuration options

**Returns:** A client object with methods for accessing the API

### Star Systems API

#### `client.starSystems(params?: StarSystemsListParams)`

Get a paginated list of star systems.

**Parameters:**

- `page`: The page number to retrieve (default: 1, min: 1)
- `page_size`: Number of items per page (default: 100, min: 1, max: 200)
- `spectral_class`: Filter star systems by spectral class (e.g., "G" for Sun-like stars)
- `min_stars`: Filter for star systems with at least this many stars
- `max_stars`: Filter for star systems with at most this many stars

**Returns:** Promise resolving to `StarSystemsListResponse`
