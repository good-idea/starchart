const rootConfig = require('../../jest.config');

module.exports = {
  ...rootConfig,
  displayName: 'navigator',
  testMatch: ['<rootDir>/src/**/__tests__/**/*.test.ts?(x)'],
  setupFilesAfterEnv: ['<rootDir>/src/setupTests.ts'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  }
};
