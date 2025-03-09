import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'
import { 
  StarSystemsListResponse, 
  StarSystemsListParams,
  StarSystemResponse,
  NearbyStarSystemsResponse,
  NearbyStarSystemsParams,
  StarResponse
} from '@starchart/types'

// Define the API slice
export const starSystemsApi = createApi({
  reducerPath: 'starSystemsApi',
  baseQuery: fetchBaseQuery({ baseUrl: 'http://localhost:4000/api/v1/' }),
  endpoints: (builder) => ({
    getStarSystems: builder.query<StarSystemsListResponse, StarSystemsListParams | void>({
      query: (params = {}) => {
        // Convert params object to URL query parameters
        const queryParams = new URLSearchParams()
        
        if (params.page) queryParams.append('page', params.page.toString())
        if (params.page_size) queryParams.append('page_size', params.page_size.toString())
        if (params.spectral_class) queryParams.append('spectral_class', params.spectral_class)
        if (params.min_stars) queryParams.append('min_stars', params.min_stars.toString())
        if (params.max_stars) queryParams.append('max_stars', params.max_stars.toString())
        
        const queryString = queryParams.toString()
        return {
          url: `star_systems${queryString ? `?${queryString}` : ''}`,
        }
      },
    }),
    getStarSystem: builder.query<StarSystemResponse, number | string>({
      query: (id) => `star_systems/${id}`,
    }),
    getStar: builder.query<StarResponse, number | string>({
      query: (id) => `stars/${id}`,
    }),
    getNearbyStarSystems: builder.query<
      NearbyStarSystemsResponse, 
      { originId: number | string; params?: NearbyStarSystemsParams }
    >({
      query: ({ originId, params = {} }) => {
        const queryParams = new URLSearchParams()
        
        if (params.distance) queryParams.append('distance', params.distance.toString())
        if (params.page) queryParams.append('page', params.page.toString())
        if (params.page_size) queryParams.append('page_size', params.page_size.toString())
        if (params.spectral_class) queryParams.append('spectral_class', params.spectral_class)
        if (params.min_stars) queryParams.append('min_stars', params.min_stars.toString())
        if (params.max_stars) queryParams.append('max_stars', params.max_stars.toString())
        
        const queryString = queryParams.toString()
        return {
          url: `star_systems/${originId}/nearby${queryString ? `?${queryString}` : ''}`,
        }
      },
    }),
  }),
})

// Export the auto-generated hooks
export const { 
  useGetStarSystemsQuery, 
  useGetStarSystemQuery,
  useGetStarQuery,
  useGetNearbyStarSystemsQuery
} = starSystemsApi
