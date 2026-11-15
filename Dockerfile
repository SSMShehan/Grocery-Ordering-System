# Stage 1: Build the Maven application
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Setup Tomcat to run the application
FROM tomcat:9.0-jdk21
WORKDIR /usr/local/tomcat

# Disable Tomcat shutdown port (8005) to stop Render health-check log spam
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/g' conf/server.xml

# Remove default tomcat applications
RUN rm -rf webapps/*

# Copy the built WAR file
COPY --from=build /app/target/grocery.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]