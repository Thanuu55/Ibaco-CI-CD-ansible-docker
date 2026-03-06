#########################################
# Ibaco Project — Dockerfile
# Built & Automated by: thanushrii
#########################################

# ---------- Stage 1: Build with Maven ----------
FROM maven:3.9.4-eclipse-temurin-17 AS build
LABEL maintainer="thanushrii"

WORKDIR /app

# Copy pom.xml and download dependencies first (layer caching optimization)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build WAR file
RUN mvn clean package -DskipTests


# ---------- Stage 2: Deploy to Tomcat ----------
FROM tomcat:9.0-jdk17-temurin
LABEL author="thanushrii"

WORKDIR /usr/local/tomcat

# Remove default Tomcat applications
RUN rm -rf webapps/*

# Copy built WAR from build stage
COPY --from=build /app/target/*.war webapps/ROOT.war

# Expose application port
EXPOSE 8084

# Start Tomcat
CMD ["catalina.sh", "run"]

