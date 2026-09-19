---
name: java-springboot
description: Generate, review, or fix Spring Boot controllers, services, repositories, entities, DTOs, and configuration. Match the project's versions and conventions.
license: MIT
---

# Spring Boot development

Read applicable AGENTS.md files and inspect the build, nearby implementation, and tests. If this is still a metadata-only scaffold, establish application requirements and versions before implementation.

When generating or reviewing components, read [component guidance](references/component-guidance.md), adapted from Ken Kousen's Spring Boot skill. Apply only the sections relevant to the current component. This supplements the workflow below; existing project decisions take precedence over example defaults.

- Trace a comparable request through controller, service, and persistence code before changing the flow.
- Use constructor injection for required collaborators. Retain existing package organization and configuration format.
- Preserve API DTOs, validation, error mapping, and authorization. Use annotations and imports compatible with the installed Spring version.
- Place transactions at the appropriate operation boundary; consider proxy interception, rollback behavior, and lazy loading.
- Reuse the existing persistence technology. Check query count and database migrations when changing data access.
- Keep secrets external and log useful context without sensitive payloads.
- Select focused unit, slice, or full integration tests based on the behavior changed. Use established dependencies and build commands.

Report the behavior changed, verification results, and remaining limitations.

Adapted from [awesome-copilot/java-springboot](https://github.com/github/awesome-copilot/tree/main/skills/java-springboot). See the repository's THIRD_PARTY_NOTICES.md for attribution.

Additional source: [Ken Kousen's Spring Boot skill](https://github.com/kousen/claude-code-training/blob/main/skills-and-plugins/spring-boot-skill/SKILL.md). The linked reference is a Codex adaptation, not an unchanged upstream copy.
