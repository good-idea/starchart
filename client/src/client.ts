import fetch from 'cross-fetch'
import {
  StarSystemsListParams,
  StarSystemsListResponse,
  ErrorResponse,
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

  const starSystems: APIRequest<
    StarSystemsListResponse,
    StarSystemsListParams
  > = (params) => makeRequest('/star_systems', params)

  return {
    starSystems,
  }
}
