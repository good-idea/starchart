import React from 'react';
import { render, screen } from '@testing-library/react';
import App from '../App';

test('renders the Star Chart Navigator heading', () => {
  render(<App />);
  const headingElement = screen.getByText(/Star Chart Navigator/i);
  expect(headingElement).toBeInTheDocument();
});
