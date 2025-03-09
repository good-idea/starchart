import { useState, useEffect } from 'react'
import { StarSystem } from '@starchart/types'

import { useGetStarSystemsQuery } from '../services/starSystemsApi'
import { useAppSelector } from './redux'
import {
  selectAllCachedStarSystems,
  selectTotalStarSystemsCount,
} from '@/store/selectors'

interface UseAllStarSystemsResult {
  isLoading: boolean
  totalSystems: number
  starSystems: StarSystem[]
}

/**
 * Hook that loads all star systems, one page at a time
 * @returns Object containing loading state, total systems count, and array of all star systems
 */
export function useAllStarSystems(): UseAllStarSystemsResult {
  const [currentPage, setCurrentPage] = useState(1)
  const [isLoading, setIsLoading] = useState(true)

  const starSystems = useAppSelector(selectAllCachedStarSystems)
  const totalSystems = useAppSelector(selectTotalStarSystemsCount)

  const { data } = useGetStarSystemsQuery({
    page: currentPage,
    page_size: 100,
  })

  const totalPages = data?.meta?.total_pages
  const fetchedPage = data?.meta?.page

  useEffect(() => {
    if (data) {
      const { page, total_pages } = data.meta
      if (page < total_pages) {
        setCurrentPage(page + 1)
      } else {
        setIsLoading(false)
      }
    }
  }, [totalPages, fetchedPage])

  return {
    isLoading,
    totalSystems,
    starSystems,
  }
}
