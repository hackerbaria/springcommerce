# Spring Boot component generation and review

Adapted from [Ken Kousen's Spring Boot skill](https://github.com/kousen/claude-code-training/blob/main/skills-and-plugins/spring-boot-skill/SKILL.md).

- Inject required dependencies through constructors into final fields. Use Lombok-generated constructors only if Lombok is already configured.
- Preserve existing package organization; layered packaging is an option, not a migration requirement.
- Match HTTP methods, response types, validation, status codes, and existing API-versioning conventions.
- Keep business operations in services, model absent results consistently, and use appropriate transactions and domain errors.
- For JPA, align identifiers, constraints, relationships, and constructors with the schema. Review equality, string output, and cascade behavior explicitly rather than adding blanket Lombok annotations.
- Select tests by component: MVC slices for web behavior, isolated service tests, persistence slices for mappings/queries, and integration tests for cross-component behavior. Use mock-bean APIs supported by the installed Spring version. Full-context tests alone do not establish end-to-end coverage.
- Document meaningful public contracts and business assumptions; use OpenAPI annotations when already supported.
- Extend existing exception handlers and error schemas. Preserve configuration format, externalize credentials, and reuse environment profiles.

Choose coverage appropriate to the change; generating one component does not require every test category.
