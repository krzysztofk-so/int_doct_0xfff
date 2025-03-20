# Use the official Maven image to build the application
   FROM maven:3.8.5-openjdk-11 AS build

   # Set the working directory
   WORKDIR /app

   # Copy the project files
   COPY . .

   # Build the application
   RUN mvn clean package

   # Use the official OpenJDK image to run the application
   FROM openjdk:11-jre-slim

   # Set the working directory
   WORKDIR /app

   # Copy the JAR file from the build stage
   COPY --from=build /app/target/sample-java-app-1.0-SNAPSHOT.jar app.jar

   # Run the application
   CMD ["java", "-jar", "app.jar"]
