FROM docker.io/openjdk:8-jre
WORKDIR /app
COPY ./RuoYi-Cloud/ruoyi-auth/target/ruoyi-auth.jar /app/ruoyi-auth.jar
ENTRYPOINT [ "java", "-jar", "-Dspring.config.location=/app/config.yml", "ruoyi-auth.jar"]