import './App.css'
import { useAllStarSystems } from './hooks/useAllStarSystems'

function App() {
  useAllStarSystems()
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-800 mb-4">
          Star Chart Navigator
        </h1>
        <p className="text-lg text-gray-600">
          Explore the stars and navigate through space
        </p>
      </div>
    </div>
  )
}

export default App
