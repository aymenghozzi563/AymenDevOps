# Use an official OpenJDK 17 base image
FROM eclipse-temurin:17-jdk

ENV APP_JAR app.jar

# Copy the packaged JAR into the image
COPY target/*.jar $APP_JAR

# Expose your Spring Boot default port
EXPOSE 8080

# Start your app
ENTRYPOINT ["java", "-jar", "/app.jar"]