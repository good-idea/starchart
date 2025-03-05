import fetch from 'cross-fetch'
import {
  StarSystemsListParams,
  StarSystemsListResponse,
  StarSystem,
  Star,
  ErrorResponse,
  NearbyStarSystemsParams,
  NearbyStarSystemsResponse,
} from '@starchart/types'

import { formatQueryParams } from './utils/request'

export interface ClientOptions {
  baseURL?: string
  version?: string
  /** Optional fetch configuration */
  fetchOptions?: RequestInit
}

export type StarChartClient = ReturnType<typeof createClient>

type AnyParams = Record<string, string | number>

type APIRequest<Result, Params extends AnyParams | undefined> = (
  params: Params,
) => Promise<ApiResult<Result>>

type ApiResult<T> =
  | { success: true; result: T }
  | ({ success: false } & ErrorResponse)

/**
 * Creates a client for the Star Chart API
 *
 * @param options - Configuration options for the client
 * @returns A client object with methods for accessing the API
 */
export const createClient = (options: ClientOptions = {}) => {
  const cache = new Map<string, { success: true; result: any }>()
  const baseURL = options.baseURL || 'http://localhost:4000/api'
  const version = options.version || 'v1'
  const defaultFetchOptions: RequestInit = {
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    ...options.fetchOptions,
  }

  const makeRequest = async <T>(
    endpoint: `/${string}`,
    params?: AnyParams,
  ): Promise<ApiResult<T>> => {
    const queryString = params ? formatQueryParams(params) : ''
    const url = `${baseURL}/${version}${endpoint}${queryString}`
    const cached = cache.get(url)
    if (cached) return cached

    const response = await fetch(url, defaultFetchOptions)

    // Handle error responses
    if (!response.ok) {
      const contentType = response.headers.get('content-type')

      if (contentType && contentType.includes('application/json')) {
        const errorResponse = (await response.json()) as ErrorResponse
        return {
          success: false,
          ...errorResponse,
        }
      } else {
        throw new Error(`Error ${response.status}: ${response.statusText}`)
      }
    }

    const result: T = await response.json()

    const value = { success: true as const, result }
    cache.set(url, value)
    return value
  }

  /**
   * Get a specific star system by ID
   *
   * @param id - The ID of the star system to retrieve
   * @returns Promise resolving to either a successful response with the star system or an error
   */
  const getStarSystem = (
    id: number | string,
  ): Promise<ApiResult<StarSystem>> => {
    return makeRequest(`/star_systems/${id}`)
  }

  /**
   * Get a paginated list of star systems with optional filtering
   *
   * @param params - Query parameters for filtering and pagination
   * @param params.page - The page number to retrieve (default: 1, min: 1)
   * @param params.page_size - Number of items per page (default: 100, min: 1, max: 200)
   * @param params.spectral_class - Filter star systems by spectral class (e.g., "G" for Sun-like stars)
   * @param params.min_stars - Filter for star systems with at least this many stars
   * @param params.max_stars - Filter for star systems with at most this many stars
   * @returns Promise resolving to either a successful response with paginated star systems or an error
   */
  const getStarSystems: APIRequest<
    StarSystemsListResponse,
    StarSystemsListParams
  > = (params) => makeRequest('/star_systems', params)

  /**
   * Get star systems near a specific origin star system
   *
   * @param originId - The ID of the origin star system
   * @param params - Query parameters for filtering and pagination
   * @param params.distance - Maximum distance in light years (default: 25.0, min: 0.1, max: 100)
   * @param params.page - The page number to retrieve (default: 1, min: 1)
   * @param params.page_size - Number of items per page (default: 100, min: 1, max: 200)
   * @param params.spectral_class - Filter by spectral class (optional)
   * @param params.min_stars - Filter for star systems with at least this many stars (optional, min: 1)
   * @param params.max_stars - Filter for star systems with at most this many stars (optional, min: 1)
   * @returns Promise resolving to either a successful response with nearby star systems or an error
   */
  const getNearbyStarSystems = (
    originId: number | string,
    params?: NearbyStarSystemsParams,
  ): Promise<ApiResult<NearbyStarSystemsResponse>> => {
    return makeRequest(`/star_systems/${originId}/nearby`, params)
  }

  /**
   * Get a specific star by ID
   *
   * @param id - The ID of the star to retrieve
   * @returns Promise resolving to either a successful response with the star or an error
   */
  const getStar = (id: number | string): Promise<ApiResult<Star>> => {
    return makeRequest(`/stars/${id}`)
  }

  return {
    getStarSystems,
    getStarSystem,
    getStar,
    getNearbyStarSystems,
  }
}
