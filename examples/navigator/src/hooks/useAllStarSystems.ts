import { useState, useEffect } from 'react'
import { StarSystem } from '@starchart/types'
import { useGetStarSystemsQuery } from '../services/starSystemsApi'

interface UseAllStarSystemsResult {
  loading: boolean
  totalSystems: number
  starSystems: StarSystem[]
}

/**
 * Hook that loads all star systems, one page at a time
 * @returns Object containing loading state, total systems count, and array of all star systems
 */
export function useAllStarSystems(): UseAllStarSystemsResult {
  const [currentPage, setCurrentPage] = useState(1)

  const { data, isFetching } = useGetStarSystemsQuery({
    page: currentPage,
    page_size: 100,
  })

  // const { page, total_pages } = data.data.meta

  useEffect(() => {
    if (data) {
      const { page, total_pages } = data.meta
      if (page < 3) {
        setCurrentPage(page + 1)
      }
    }
  }, [data])
}
