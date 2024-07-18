# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM openjdk:17-slim
WORKDIR /app

# Copy the built jar file to the runtime image
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
