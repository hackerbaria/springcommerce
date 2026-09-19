# api-gateway guidance

Scope: api-gateway/. Also follow the repository-root AGENTS.md.

Uses Spring Cloud Gateway MVC, OAuth2 resource-server security, and Resilience4j. Preserve MVC routing, forwarded paths, security matchers, fallback behavior, and observability. Do not replace it with a reactive gateway as incidental cleanup.

Read pom.xml and nearby implementation/tests before making changes. Current POM: Java 23, Spring Boot 3.4.3; preserve these versions unless the task requires an upgrade.

Run .\mvnw.cmd test or .\mvnw.cmd verify from this service directory on Windows. Use ./mvnw on POSIX systems. Commands have not been executed as part of this configuration-only setup. Inspect test configuration for Docker and service prerequisites.

Keep changes focused, add relevant regression coverage, and report actual validation outcomes.
