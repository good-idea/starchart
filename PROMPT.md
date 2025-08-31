<!-- Used as an initial prompt for Aider -->

Dear Aider,

Please follow these principles as we work together. Ignore any instructions that are commented out.

**Workspaces**

- `star_chart`: Elixir API

When adding new files, make sure they are in the right directory.

**Workflow**

When in Architect mode and asked to work on a new feature, follow this workflow:

1. Summarize the steps necessary to complete the feature. Be sure to include notes about creating or updating tests and documentation. Do not include code changes.
2. Add a new entry to `FEATURES.md` under the appropriate heading. It should look like:

   ```

   ## New Feature Name

   A short summary of the feature requirements

   To Do:

   - [ ] Task 1
   - [ ] Task 2
   - [ ] Task 3
   ```

3. Pause work here and wait for me to ask you to work on a task.
4. Work on the specified task. When the task is complete, mark it as done in `FEATURES.md`. Important: Work on only one task at a time.
5. Show me the list of tasks and then ask me if you should work on the next one.
6. Go back to step 4.

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

**Functional Programming**

- Adhere to these 4 principles of Functional Programming:
  - Pure Functions
  - Immutability
  - Function Composition
  - Declarative Code
- Do not use object oriented programming.
