<!-- Used as an initial prompt for Aider -->

Dear Aider,

Please follow these principles as we work together. Ignore any instructions that are commented out.

**Workflow**

When in Architect mode, follow this workflow:

1. Start by defining the objective of the current task.
2. Check out to a new git branch in the format `<task-type>/task-name` where the `task-type` is one of:

   - feat/<branch-name> for new features
   - fix/<branch-name> for bug fixes
   - chore/<branch-name> for maintenance or refactoring
   - docs/<branch-name> for documentation updates
   - test/<branch-name> for test-related changes

3. List out the tasks needed to achieve the objective
4. Check out to a new git branch for this task, named `<current-branch>/task-name`
5. Work on each task one at a time.

   1. Suggest files from the repo map that should be added to the chat
   2. Propose code changes to achieve the task
   3. After making changes to files, make a git commit in the format: `aider: <brief commit message>`. Use the `--no-verify` flag for these commits.
   4. Ask me if these changes are satisfactory.
      - If they are not, return to step 5.1 for the current task.
      - If they are, remind me what the next task is and return to step 5 for the next task.

**Repository Architecture**

- All elixir code is within the root star_chart directory.

**Clarity & Style**

- Code should be easy to read and understand.
- Keep the code as simple and verbose. Avoid unnecessary complexity.
- Use meaningful names for variables, functions, etc. Names should reveal intent.
- Functions should be small and do one thing well. They should not exceed a few lines.
- Function names should describe the action being performed.
- Prefer fewer arguments in functions. Ideally, aim for no more than two or three.
- Only use comments when necessary, as they can become outdated. Instead, strive to make the code self-explanatory.
- When comments are used, they should add useful information that is not readily apparent from the code itself.
- When making changes, update any related comments or documentation.

**Documentation**

- Auto-Generate and Update Documentation:

  - Ensure that code comments and API docs (e.g., JSDoc, Javadoc, or docstrings) stay updated with each code change.

- Write Clear and Concise Comments:

  - Explain why complex logic exists, not just what the code does.
  - Use consistent formatting for inline and block comments.

- Maintain a Well-Structured README:

  - Include setup instructions, usage examples, and contribution guidelines.
  - Keep it concise and up to date.

- Ensure API Documentation is Complete:
  - Describe all functions, parameters, return types, and error handling.
  - Use tools like Swagger (OpenAPI) or GraphQL Docs when applicable.

**Code Safety & Security**

- Properly handle errors and exceptions to ensure the software's robustness.
- Use exceptions rather than error codes for handling errors.
- Consider security implications of the code. Implement security best practices to protect against vulnerabilities and attacks.

**Test-driven development**

- Follow the Red-Green-Refactor Cycle:

  - First, write a failing test before implementing any functionality (Red).
  - Then, implement only enough code to make the test pass (Green).
  - Finally, refactor the code while keeping the tests passing (Refactor).

- Write Clear and Specific Unit Tests:

  - Ensure that tests are isolated and focus on one specific behavior.
  - Use descriptive test names that explain what the test verifies.
  - Prefer parameterized tests when testing multiple input variations.

- Use an Appropriate Testing Framework:

  - Choose a framework suitable for the language (e.g., JUnit for Java, Jest for JavaScript, PyTest for Python).
  - Ensure all test cases follow best practices for setup, execution, and teardown.

- Ensure High Test Coverage Without Overtesting:

  - Cover all critical paths, edge cases, and failure scenarios.
  - Avoid redundant tests that do not provide additional value.

- Keep Tests Fast and Deterministic:

  - Minimize dependencies to ensure tests run quickly.
  - Avoid relying on external services; use mocks or stubs instead.

- Continuously Run Tests and Maintain CI Integration:

  - Automatically run tests before pushing code.
  - Ensure the assistant provides scripts or configurations for CI/CD pipelines.

- Refactor With Confidence:

  - Encourage clean, maintainable code by refactoring after passing tests.
  - Ensure code remains readable and follows SOLID principles.

- Document the Testing Approach:

  - Generate test documentation where applicable.
  - If necessary, provide an overview of test cases and expected outcomes.

- Encourage Behavior-Driven Development (BDD) When Relevant:

  - Use BDD-style tests (e.g., Given-When-Then) for features requiring human-readable specifications.
  - Utilize tools like Cucumber or Jest with descriptive assertions.

- Enforce Best Practices in Test Assertions:
  - Use meaningful assertion messages to clarify test failures.
  - Prefer expressive matchers (e.g., assertEquals(expected, actual), expect(value).toBe(expected)).

**Functional Programming**

- Adhere to these 4 principles of Functional Programming:
  - Pure Functions
  - Immutability
  - Function Composition
  - Declarative Code
- Do not use object oriented programming.
