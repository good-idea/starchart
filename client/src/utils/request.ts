import { URLSearchParams } from 'url'

/**
 * Formats query parameters for fetch requests
 *
 * @param params - Object containing query parameters
 * @returns Formatted query string or empty string if no params
 */
export const formatQueryParams = (params?: Record<string, any>): string => {
  if (!params || Object.keys(params).length === 0) {
    return ''
  }

  const searchParams = new URLSearchParams()

  Object.entries(params).forEach(([key, value]) => {
    if (value !== undefined && value !== null) {
      searchParams.append(key, String(value))
    }
  })

  const queryString = searchParams.toString()
  return queryString ? `?${queryString}` : ''
}

/**
 * Handles API responses and errors
 *
 * @param response - Fetch Response object
 * @returns Promise resolving to the parsed JSON response
 * @throws Error with status code and message if the request fails
 */
export const handleResponse = async <T>(response: Response): Promise<T> => {
  if (!response.ok) {
    const errorText = await response.text()
    let errorMessage: string

    try {
      const errorJson = JSON.parse(errorText)
      errorMessage = errorJson.errors?.detail || `API error: ${response.status}`
    } catch (e) {
      errorMessage = errorText || `API error: ${response.status}`
    }

    const error = new Error(errorMessage) as Error & { status?: number }
    error.status = response.status
    throw error
  }

  return response.json() as Promise<T>
}
