## API Endpoints

### Star Systems

| Method | Endpoint                                 | Description                                         |
| ------ | ---------------------------------------- | --------------------------------------------------- |
| GET    | `/api/v1/star_systems`                   | List all star systems (paginated)                   |
| GET    | `/api/v1/star_systems/:id`               | Get a specific star system by ID                    |
| GET    | `/api/v1/star_systems/:origin_id/nearby` | Get star systems near a specific origin star system |

#### Pagination and Filtering

The star systems endpoint supports pagination and filtering through the following query parameters:

- `page`: The page number to retrieve (default: 1, min: 1)
- `page_size`: Number of items per page (default: 100, min: 1, max: 200)
- `spectral_class`: Filter star systems by spectral class (e.g., "G" for Sun-like stars)
  - Valid values: O, B, A, F, G, K, M, L, T, Y, U (where U represents unknown)

Example: `/api/v1/star_systems?page=2&page_size=50&spectral_class=G`

#### Response Format

```json
{
  "data": [
    {
      "id": 1,
      "name": "Sol",
      "star_count": 1
    },
    {
      "id": 2,
      "name": "Alpha Centauri",
      "star_count": 3
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

The response includes:

- `data`: Array of star systems for the current page
  - `id`: The unique identifier for the star system
  - `name`: The name of the star system
  - `star_count`: The total number of stars in this system
- `meta`: Pagination metadata
  - `page`: Current page number
  - `page_size`: Number of items per page
  - `total_entries`: Total number of star systems in the database
  - `total_pages`: Total number of pages available

#### Star System Details Response

When fetching a specific star system by ID, the response includes:

```json
{
  "data": {
    "id": 1,
    "name": "Alpha Centauri",
    "star_count": 3,
    "primary_star": {
      "id": 1,
      "name": "Alpha Centauri A",
      "proper_name": "Rigil Kentaurus",
      "is_primary": true,
      "distance_parsecs": 4.37,
      "apparent_magnitude": -0.27,
      "absolute_magnitude": 4.38,
      "spectral_type": "G2V",
      "spectral_class": "G",
      ...
    },
    "secondary_stars": [
      {
        "id": 2,
        "name": "Alpha Centauri B",
        "is_primary": false,
        "distance_parsecs": 4.37,
        "apparent_magnitude": 1.33,
        "spectral_type": "K1V",
        "spectral_class": "K",
        ...
      },
      {
        "id": 3,
        "name": "Proxima Centauri",
        "is_primary": false,
        "distance_parsecs": 4.24,
        "apparent_magnitude": 11.05,
        "spectral_type": "M5.5Ve",
        ...
      }
    ]
  }
}

The response includes:

- `data`: The star system details
  - `id`: The unique identifier for the star system
  - `name`: The name of the star system
  - `star_count`: The total number of stars in this system
  - `primary_star`: Details about the primary star in the system
  - `secondary_stars`: Array of all non-primary stars in the system

### Nearby Star Systems

The nearby star systems endpoint allows you to find all star systems within a specified distance from an origin star system.

#### Request Parameters

- `origin_id`: The ID of the origin star system (path parameter)
- `distance`: Maximum distance in light years (default: 25.0, min: 0.1, max: 100)
- `page`: The page number to retrieve (default: 1, min: 1)
- `page_size`: Number of items per page (default: 100, min: 1, max: 200)
- `spectral_class`: Filter by spectral class (optional)
  - Valid values: O, B, A, F, G, K, M, L, T, Y, U (where U represents unknown)
- `min_stars`: Filter for star systems with at least this many stars (optional, min: 1)
- `max_stars`: Filter for star systems with at most this many stars (optional, min: 1)

Example: `/api/v1/star_systems/1/nearby?distance=10.5&page=2&page_size=20&spectral_class=G&min_stars=2`

#### Response Format

```json
{
  "data": [
    {
      "system": {
        "id": 2,
        "name": "Alpha Centauri",
        "star_count": 3,
        "primary_star": {
          "id": 4,
          "name": "Alpha Centauri A",
          "spectral_type": "G2V",
          ...
        }
      },
      "distance": {
        "parsecs": 1.3,
        "light_years": 4.24
      }
    },
    {
      "system": {
        "id": 3,
        "name": "Barnard's Star",
        "star_count": 1,
        "primary_star": {
          "id": 7,
          "name": "Barnard's Star",
          "spectral_type": "M4V",
          ...
        }
      },
      "distance": {
        "parsecs": 1.8,
        "light_years": 5.96
      }
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

The response includes an array of objects, each containing:

- `system`: The star system details
  - Same format as the star system response above
- `distance`: The distance from the origin star system
  - `parsecs`: Distance in parsecs
  - `light_years`: Distance in light years

The results are sorted by distance, with the closest systems first.
