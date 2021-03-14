FROM        openjdk:11.0.2 AS build
WORKDIR     /workspace/app
COPY        . .
RUN         ./gradlew clean build

FROM        openjdk:11.0.2 AS target
COPY        --from=build /workspace/app/build/libs/*jar app.jar
COPY        --from=build /workspace/app/seed seed
ENTRYPOINT  ["java", "-jar", "/app.jar"]
