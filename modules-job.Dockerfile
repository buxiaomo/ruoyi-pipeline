FROM docker.io/openjdk:8-jre
WORKDIR /app
COPY ./RuoYi-Cloud/ruoyi-modules/ruoyi-job/target/ruoyi-modules-job.jar /app/ruoyi-modules-job.jar
ENTRYPOINT [ "java", "-jar", "-Dspring.config.location=/app/config.yml", "ruoyi-modules-job.jar"]