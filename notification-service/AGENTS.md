# notification-service guidance

Scope: notification-service/. Also follow the repository-root AGENTS.md.

Consumes Kafka/Avro events and sends mail. Preserve producer/consumer schema compatibility, consumer behavior, and mail configuration. Inspect the Avro plugin and schemas before regenerating event classes; generated sources may be written into src/main/java. Tests must avoid sending real mail.

Read pom.xml and nearby implementation/tests before making changes. Current POM: Java 23, Spring Boot 3.4.3; preserve these versions unless the task requires an upgrade.

Run .\mvnw.cmd test or .\mvnw.cmd verify from this service directory on Windows. Use ./mvnw on POSIX systems. Commands have not been executed as part of this configuration-only setup. Inspect test configuration for Docker and service prerequisites.

Keep changes focused, add relevant regression coverage, and report actual validation outcomes.
