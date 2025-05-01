# --- Build Stage ---
    FROM eclipse-temurin:21-jdk AS build

    # Set working directory
    WORKDIR /app
    
    # Copy source and Maven wrapper
    COPY . .
    RUN chmod +x mvnw
    
    # Build without tests
    RUN ./mvnw -Dmaven.test.skip=true clean package
    
    # --- Runtime Stage ---
    FROM eclipse-temurin:21-jdk
    
    # Arbeitsverzeichnis
    WORKDIR /app
    
    # Copy compiled JAR and model files from build stage
    COPY --from=build /app/target/playground-0.0.1-SNAPSHOT.jar app.jar
    COPY --from=build /app/models /app/models
    
    # Spring Boot runs on 8080
    EXPOSE 8080
    
    # Start command
    CMD ["java", "-jar", "app.jar"]