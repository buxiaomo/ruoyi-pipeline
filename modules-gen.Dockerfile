FROM docker.io/openjdk:8-jre
WORKDIR /app
COPY ./RuoYi-Cloud/ruoyi-modules/ruoyi-gen/target/ruoyi-modules-gen.jar /app/ruoyi-modules-gen.jar
ENTRYPOINT [ "java", "-jar", "-Dspring.config.location=/app/config.yml", "ruoyi-modules-gen.jar"]