import { createApi, fetchBaseQuery } from '@reduxjs/toolkit/query/react'
import {
  StarSystemsListResponse,
  StarSystemsListParams,
  StarSystemResponse,
  NearbyStarSystemsResponse,
  NearbyStarSystemsParams,
  StarResponse,
} from '@starchart/types'
import { createQueryString } from '../utils/params'

// Define the API slice
export const starSystemsApi = createApi({
  reducerPath: 'starSystemsApi',
  baseQuery: fetchBaseQuery({ baseUrl: 'http://localhost:4000/api/v1/' }),
  endpoints: (builder) => ({
    getStarSystems: builder.query<
      StarSystemsListResponse,
      StarSystemsListParams | void
    >({
      query: (params = {}) => {
        const queryString = createQueryString(params)
        return {
          url: `star_systems${queryString}`,
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
        const queryString = createQueryString(params)
        return {
          url: `star_systems/${originId}/nearby${queryString}`,
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
  useGetNearbyStarSystemsQuery,
} = starSystemsApi
