FROM docker.m.moby.org.cn/library/openjdk:8-jre
WORKDIR /app
COPY ./RuoYi-Cloud/ruoyi-gateway/target/ruoyi-gateway.jar /app/ruoyi-gateway.jar
ENTRYPOINT [ "java", "-jar", "-Dspring.config.location=/app/config.yml", "ruoyi-gateway.jar"]