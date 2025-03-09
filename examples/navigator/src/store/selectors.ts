import { createSelector } from '@reduxjs/toolkit'
import { RootState } from './index'
import { starSystemsApi } from '../services/starSystemsApi'
import { StarSystem } from '@starchart/types'

/**
 * Selector that returns all star systems that have been fetched and cached by starSystemsApi,
 * combining results from all cached queries
 * @returns Array of all star systems in the cache
 */
export const selectAllCachedStarSystems = createSelector(
  // Get the entire RTK Query state for the starSystemsApi
  (state: RootState) => state[starSystemsApi.reducerPath].queries,
  // Extract and deduplicate all star systems from all cached queries
  (queries) => {
    // Create a map to deduplicate star systems by ID
    const starSystemsMap = new Map<number, StarSystem>()

    // Iterate through all cached queries
    Object.values(queries).forEach((query: any) => {
      // Check if this is a getStarSystems query with data
      if (query?.endpointName === 'getStarSystems' && query?.data) {
        // Add all star systems from this query to the map
        query.data.data.forEach((system: StarSystem) => {
          starSystemsMap.set(system.id, system)
        })
      }
    })

    // Convert the map values back to an array
    return Array.from(starSystemsMap.values())
  },
)

/**
 * Selector that returns the total number of star systems from the API
 * @returns Total number of star systems, or 0 if not available
 */
export const selectTotalStarSystemsCount = createSelector(
  (state: RootState) => state[starSystemsApi.reducerPath].queries,
  (queries) => {
    // Find the first getStarSystems query with data
    const starSystemsQuery = Object.values(queries).find(
      (query: any) => query?.endpointName === 'getStarSystems' && query?.data,
    ) as any

    return starSystemsQuery?.data?.meta?.total_entries ?? 0
  },
)
