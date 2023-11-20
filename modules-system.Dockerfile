FROM docker.io/openjdk:8-jre
WORKDIR /app
COPY ./RuoYi-Cloud/ruoyi-modules/ruoyi-system/target/ruoyi-modules-system.jar /app/ruoyi-modules-system.jar
ENTRYPOINT [ "java", "-jar", "-Dspring.config.location=/app/config.yml", "ruoyi-modules-system.jar"]