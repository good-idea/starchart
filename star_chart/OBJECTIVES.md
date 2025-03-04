# TODO

## Nearby Star Systems Endpoint

This document outlines the steps to implement a new endpoint that fetches all star systems within a specified distance from an origin system.

### Implementation Steps

- [x] Create a new function in the Astronomy context to calculate distances between star systems
- [x] Add a function to find nearby star systems with distance calculation
- [x] Create a new controller action for the nearby endpoint
- [x] Add the route for `/api/v1/star_systems/:origin_id/nearby`
- [ ] Add filtering capabilities. (all parameters should be validated):
  - [ ] Distance filter (required parameter)
  - [ ] Unit conversion (parsecs/light years)
  - [ ] Spectral class filter
  - [ ] Star count filters (min_stars/max_stars)
- [ ] Update the JSON view to include distance from origin
- [ ] Add pagination support
- [ ] Write tests for the new endpoint
- [ ] Update API documentation in README.md
