# SpringCommerce coding guidance

## Repository context
- Five independent Maven services: api-gateway, inventory-service, notification-service, order-service, and product-service. No root aggregator POM or frontend is present.
- Current service POMs specify Java 23 and Spring Boot 3.4.3. Read the relevant POM before selecting APIs; POMs take precedence over older README version descriptions.
- Read the target service's AGENTS.md before editing it, including when working from the repository root.
- Preserve existing user changes and keep edits within the requested scope. Follow existing packages, configuration formats, and public contracts.

## Skills
- .agents/skills/java-springboot: implementation, component generation, and review; includes adapted Awesome Copilot and Ken Kousen guidance.
- .agents/skills/java-junit: Java regression tests and test diagnosis.
- .agents/skills/refactor: behavior-preserving restructuring.
- Load only relevant skills. Use java-springboot's references/component-guidance.md when generating or reviewing components.

## Backend conventions
- Reuse constructor injection and configured Lombok conventions; do not introduce dependencies incidentally.
- Preserve DTO validation, status codes, exception mapping, authentication, and authorization.
- Keep database technology service-specific: product uses MongoDB; order and inventory use JPA/MySQL and Flyway.
- Preserve HTTP and event contracts across services. Review both producers and consumers for event-schema changes.
- Inspect transaction boundaries, query behavior, and Spring proxy interception when moving business operations.
- Keep sensitive values out of new source code and logs; preserve existing application.properties conventions.
- Edit Avro schemas and regenerate through the configured plugin rather than manually editing generated event classes. Inspect resulting diffs because generation can write into src/main/java.

## Verification
- Run Maven from the relevant service directory using its wrapper. There is no root Maven build.
- Windows commands: .\mvnw.cmd test for tests; .\mvnw.cmd verify for the configured verification lifecycle. These commands are derived from the repository layout, not verified as passing during guidance setup.
- Integration tests may require Docker/Testcontainers and external-service configuration. Inspect the selected tests before execution; report missing prerequisites rather than suppressing failures.
- Use nearby JUnit, Mockito, RestAssured, and WireMock patterns where configured. Add regression coverage for meaningful behavior changes.
- Report commands, outcomes, and unverified behavior. Do not claim tests ran when only configuration was inspected.
