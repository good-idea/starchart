module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  testMatch: ['**/__tests__/**/*.test.ts'],
  collectCoverage: true,
  coverageDirectory: 'coverage',
  collectCoverageFrom: ['**/src/**/*.ts', '!**/src/**/*.d.ts', '!**/dist/**'],
  projects: [
    {
      displayName: 'client',
      testMatch: ['<rootDir>/client/src/**/__tests__/**/*.test.ts'],
      moduleNameMapper: {
        '^@/(.*)$': '<rootDir>/$1'
      }
    }
  ]
};
