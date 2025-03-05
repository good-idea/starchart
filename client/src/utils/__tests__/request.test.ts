import { formatQueryParams } from '../request'

describe('formatQueryParams', () => {
  it('should return an empty string for undefined params', () => {
    expect(formatQueryParams()).toBe('')
  })

  it('should return an empty string for empty params', () => {
    expect(formatQueryParams({})).toBe('')
  })

  it('should format simple params correctly', () => {
    const params = {
      page: 1,
      page_size: 10,
      spectral_class: 'G',
    }
    expect(formatQueryParams(params)).toBe(
      '?page=1&page_size=10&spectral_class=G',
    )
  })

  it('should skip null and undefined values', () => {
    const params = {
      page: 1,
      filter: undefined,
      sort: null,
      spectral_class: 'G',
    }
    expect(formatQueryParams(params)).toBe('?page=1&spectral_class=G')
  })

  it('should handle boolean values', () => {
    const params = {
      page: 1,
      include_details: true,
    }
    expect(formatQueryParams(params)).toBe('?page=1&include_details=true')
  })

  it('should handle numeric values', () => {
    const params = {
      distance: 10.5,
    }
    expect(formatQueryParams(params)).toBe('?distance=10.5')
  })
})
