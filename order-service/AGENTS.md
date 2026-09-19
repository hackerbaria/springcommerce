# order-service guidance

Scope: order-service/. Also follow the repository-root AGENTS.md.

Uses JPA/MySQL, Flyway, an inventory HTTP client, Resilience4j, and Kafka/Avro. Preserve validation, stock checks, order persistence, event publication, and failure handling. Review inventory-service and notification-service contracts when changing integrations. Tests include WireMock, RestAssured, and Testcontainers. Inspect Avro generation diffs under src/main/java.

Read pom.xml and nearby implementation/tests before making changes. Current POM: Java 23, Spring Boot 3.4.3; preserve these versions unless the task requires an upgrade.

Run .\mvnw.cmd test or .\mvnw.cmd verify from this service directory on Windows. Use ./mvnw on POSIX systems. Commands have not been executed as part of this configuration-only setup. Inspect test configuration for Docker and service prerequisites.

Keep changes focused, add relevant regression coverage, and report actual validation outcomes.
