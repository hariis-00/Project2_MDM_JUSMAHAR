# Stage: Build & Package mit Maven Wrapper
FROM eclipse-temurin:21-jdk-alpine as build
WORKDIR /app
COPY . .
RUN chmod +x mvnw
RUN ./mvnw -Dmaven.test.skip=true package

# Stage: Runtime
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Modell und Jar-Datei kopieren
COPY --from=build /app/target/*.jar app.jar
COPY models/ models/

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]