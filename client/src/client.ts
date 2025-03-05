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

type UnexpectedErrorResponse = { status: number; errorMessage: string }

type APIRequest<Result, Params extends AnyParams | undefined> = (
  params: Params,
) => Promise<ApiResult<Result>>

type ApiResult<T> = T | ErrorResponse | UnexpectedErrorResponse

/**
 * Creates a client for the Star Chart API
 *
 * @param options - Configuration options for the client
 * @returns A client object with methods for accessing the API
 */
export const createClient = (options: ClientOptions = {}) => {
  const cache = new Map<string, { data: any }>()
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
    if (cached) return cached.data

    const response = await fetch(url, defaultFetchOptions)
    if (!response.ok) {
      /* Handle unexpected errors */
      const errorMessage = await response.text()
      return {
        status: response.status,
        errorMessage: `API error (${response.status}): ${errorMessage}`,
      }
    }
    if (response.status !== 200) {
      /* Handle formatted API errors (i.e. invalid params) */
      const errorDetails = await response.json()
      return {
        status: response.status,
        ...errorDetails,
      }
    }

    const result = await response.json()

    const value = { data: result, status: response.status }
    cache.set(url, value)
    return result
  }

  const starSystems: APIRequest<
    StarSystemsListResponse,
    StarSystemsListParams
  > = (params) => makeRequest('/star_systems', params)

  return {
    starSystems,
  }
}
