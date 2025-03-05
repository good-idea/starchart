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
  version: 'v1', // default
})

// Get a list of star systems
const response = await client.starSystems({
  page: 1,
  page_size: 10,
  spectral_class: 'G',
})

if (response.success) {
  // Handle successful response
  const starSystems = response.result
  console.log(`Found ${starSystems.data.length} star systems`)
} else {
  // Handle error response
  console.error('Error:', response.errors)
}
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

**Returns:** Promise resolving to either:

- `{ success: true, result: StarSystemsListResponse }` for successful requests
- `{ success: false, errors: { ... } }` for 400 Bad Request errors

#### `client.getStarSystem(id: number | string)`

Get a specific star system by ID.

**Parameters:**

- `id`: The ID of the star system to retrieve

**Returns:** Promise resolving to either:

- `{ success: true, result: {  StarSystem } }` for successful requests
- `{ success: false, errors: { ... } }` for 400 Bad Request errors

#### `client.getStar(id: number | string)`

Get a specific star by ID.

**Parameters:**

- `id`: The ID of the star to retrieve

**Returns:** Promise resolving to either:

- `{ success: true, result: {  Star } }` for successful requests
- `{ success: false, errors: { ... } }` for 400 Bad Request errors

## Error Handling

The client provides type-safe error handling:

- For 400 Bad Request errors (validation errors, invalid parameters, etc.), the promise will resolve with `{ success: false, error: { message: string, details: string[] } }`.
- All other request errors (network issues, 500 server errors, etc.) will throw an exception.

Example error handling:

```typescript
try {
  const response = await client.starSystems({ spectral_class: 'invalid' })

  if (!response.success) {
    // Handle 400 Bad Request errors
    console.error('Validation error:', response.errors)
    return
  }

  // Process successful response
  const starSystems = response.result
} catch (error) {
  // Handle network errors, 500 errors, etc.
  console.error('Request failed:', error)
}
```
