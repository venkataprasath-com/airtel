
# Stage 1: Build application
FROM maven:3.9-eclipse-temurin-8 AS build

WORKDIR /app

COPY pom.xml .

RUN java -version && mvn -version

RUN mvn -B -U dependency:go-offline

COPY src ./src

RUN mvn -B clean package -DskipTests


# Stage 2: Runtime
FROM eclipse-temurin:8-jre

WORKDIR /opt/app

COPY --from=build \
    /app/target/spring-boot-mongo-1.0.jar \
    app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

