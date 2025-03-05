# Star Chart API Client

A TypeScript client for the Star Chart API.

## Installation

```bash
npm install @stars/client
# or
yarn add @stars/client
```

## Usage

```typescript
import { createStarChartClient } from '@stars/client'

// Create a client instance
const client = createStarChartClient({
  baseURL: 'http://localhost:4000/api/v1', // default
})

// Get a list of star systems
const starSystems = await client.starSystems.list({
  page: 1,
  page_size: 10,
  spectral_class: 'G',
})

// Get a specific star system
const solarSystem = await client.starSystems.get({ id: 1 })

// Get nearby star systems
const nearbySystems = await client.starSystems.nearby(1, {
  distance: 10,
  spectral_class: 'G',
  page: 1,
  page_size: 20,
})
```

## API Reference

### `createStarChartClient(options?: ClientOptions)`

Creates a client for interacting with the Star Chart API.

**Options:**

- `baseURL`: Base URL for the API (default: 'http://localhost:4000/api/v1')
- `axiosConfig`: Additional Axios configuration options

**Returns:** A client object with methods for accessing the API

### Star Systems API

#### `client.starSystems.list(params?: StarSystemListParams)`

Get a paginated list of star systems.

**Parameters:**

- `page`: The page number to retrieve (default: 1, min: 1)
- `page_size`: Number of items per page (default: 100, min: 1, max: 200)
- `spectral_class`: Filter star systems by spectral class (e.g., "G" for Sun-like stars)
- `min_stars`: Filter for star systems with at least this many stars
- `max_stars`: Filter for star systems with at most this many stars

**Returns:** Promise resolving to `StarSystemListResponse`

#### `client.starSystems.get(params: StarSystemParams)`

Get a specific star system by ID.

**Parameters:**

- `id`: The ID of the star system to retrieve

**Returns:** Promise resolving to `StarSystemResponse`

#### `client.starSystems.nearby(originId: number, params?: NearbyStarSystemsParams)`

Get star systems near a specific origin star system.

**Parameters:**

- `originId`: The ID of the origin star system
- `distance`: Maximum distance in light years (default: 25.0, min: 0.1, max: 100)
- `page`: The page number to retrieve (default: 1, min: 1)
- `page_size`: Number of items per page (default: 100, min: 1, max: 200)
- `spectral_class`: Filter by spectral class (optional)
- `min_stars`: Filter for star systems with at least this many stars (optional)
- `max_stars`: Filter for star systems with at most this many stars (optional)

**Returns:** Promise resolving to `NearbyStarSystemsResponse`
