---
name: java-junit
description: Add or diagnose Java unit and regression tests using the project's JUnit setup. Use for test work rather than unrelated Java edits.
license: MIT
---

# Java tests

Inspect build dependencies, test-plugin configuration, and nearby tests first. Match installed JUnit, assertion, and mocking libraries rather than adding parallel dependencies.

- Reproduce the reported behavior and assert observable outcomes, including relevant boundaries and failures.
- Keep setup, action, and assertions clear. Match local naming and test-source conventions.
- Parameterize cases that exercise the same contract with different inputs.
- Keep tests independent. Control time, randomness, and external interactions when they affect reproducibility.
- Mock collaborators at meaningful boundaries; avoid assertions coupled to private implementation details.
- Use plain unit tests for isolated logic. Use supported Spring slices or integration tests when framework behavior is part of the contract.
- Run focused tests, then relevant broader checks. Confirm regression tests fail for the original defect when feasible.

Report commands, outcomes, and untested behavior. A build with no configured tests is not test coverage.

Adapted from [awesome-copilot/java-junit](https://github.com/github/awesome-copilot/tree/main/skills/java-junit). See the repository's THIRD_PARTY_NOTICES.md for attribution.
