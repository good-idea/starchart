/**
 * Converts an object of parameters into a URL query string
 *
 * @param params - Object containing query parameters
 * @returns URL query string (including the '?' prefix if parameters exist)
 *
 * @example
 * // Returns "?page=1&page_size=10"
 * createQueryString({ page: 1, page_size: 10 })
 *
 * @example
 * // Returns "" (empty string)
 * createQueryString({})
 */
export function createQueryString(params: Record<string, any> | void): string {
  if (!params) return ''
  // Filter out undefined and null values
  const filteredParams = Object.entries(params).filter(
    ([_, value]) => value !== undefined && value !== null,
  )

  if (filteredParams.length === 0) {
    return ''
  }

  const queryParams = new URLSearchParams()

  filteredParams.forEach(([key, value]) => {
    queryParams.append(key, value.toString())
  })

  return `?${queryParams.toString()}`
}
