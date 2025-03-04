# TODO

## Nearby Star Systems Endpoint

This document outlines the steps to implement a new endpoint that fetches all star systems within a specified distance from an origin system.

### Implementation Steps

- [x] Create a new function in the Astronomy context to calculate distances between star systems
- [x] Add a function to find nearby star systems with distance calculation
- [x] Create a new controller action for the nearby endpoint
- [x] Add the route for `/api/v1/star_systems/:origin_id/nearby`
- [x] Add filtering capabilities. (all parameters should be validated):
  - [x] Distance filter (required parameter)
  - [x] Unit conversion (parsecs/light years)
  - [x] Spectral class filter
  - [x] Star count filters (min_stars/max_stars)
- [x] Update the JSON view to include distance from origin
- [x] Add pagination support
- [x] Write tests for the new endpoint
- [x] Update API documentation in README.md
