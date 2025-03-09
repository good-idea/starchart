import { render } from '@testing-library/react'
import App from '../App'

test('renders the Star Chart Navigator heading', () => {
  const { getByText } = render(<App />)
  const headingElement = getByText(/Star Chart Navigator/i)
  expect(headingElement).toBeInTheDocument()
})
