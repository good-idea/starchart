import { createQueryString } from '../params'

describe('createQueryString', () => {
  it('should return an empty string for empty params', () => {
    expect(createQueryString({})).toBe('')
  })

  it('should create a query string with a single parameter', () => {
    expect(createQueryString({ page: 1 })).toBe('?page=1')
  })

  it('should create a query string with multiple parameters', () => {
    const result = createQueryString({ page: 1, page_size: 10 })
    // URLSearchParams doesn't guarantee order, so we need to check for both possibilities
    const possibleResults = ['?page=1&page_size=10', '?page_size=10&page=1']
    expect(possibleResults.includes(result)).toBe(true)
  })

  it('should handle string parameters', () => {
    expect(createQueryString({ spectral_class: 'G' })).toBe('?spectral_class=G')
  })

  it('should handle boolean parameters', () => {
    expect(createQueryString({ active: true })).toBe('?active=true')
  })

  it('should filter out undefined values', () => {
    expect(createQueryString({ page: 1, filter: undefined })).toBe('?page=1')
  })

  it('should filter out null values', () => {
    expect(createQueryString({ page: 1, filter: null })).toBe('?page=1')
  })

  it('should handle zero values correctly', () => {
    expect(createQueryString({ offset: 0 })).toBe('?offset=0')
  })

  it('should handle empty string values', () => {
    expect(createQueryString({ search: '' })).toBe('?search=')
  })
})
