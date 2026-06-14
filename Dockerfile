# Stage 1: Build the Maven application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Package the application (builds target/grocery.war)
RUN mvn clean package -DskipTests

# Stage 2: Setup Tomcat to run the application
FROM tomcat:9.0-jdk17
WORKDIR /usr/local/tomcat

# Remove default tomcat applications to keep things clean
RUN rm -rf webapps/*

# Copy the built WAR file from the build stage. 
# We rename it to ROOT.war so the application is served at the root URL (/) instead of /grocery
COPY --from=build /app/target/grocery.war webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
