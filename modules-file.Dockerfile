FROM docker.io/openjdk:8-jre
WORKDIR /app
COPY ./ruoyi-modules/ruoyi-file/target/ruoyi-modules-file.jar /app/ruoyi-modules-file.jar
ENTRYPOINT [ "java", "-jar", "-Dspring.config.location=/app/config.yml", "ruoyi-modules-file.jar"]