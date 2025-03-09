import { configureStore } from '@reduxjs/toolkit'
import { setupListeners } from '@reduxjs/toolkit/query'
import { starSystemsApi } from '../services/starSystemsApi'

export const store = configureStore({
  reducer: {
    // Add the generated reducer as a specific top-level slice
    [starSystemsApi.reducerPath]: starSystemsApi.reducer,
  },
  // Adding the api middleware enables caching, invalidation, polling, and other features
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(starSystemsApi.middleware),
})

// Optional, but required for refetchOnFocus/refetchOnReconnect behaviors
setupListeners(store.dispatch)

// Export types for the RootState and AppDispatch
export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
export type AppStore = typeof store
