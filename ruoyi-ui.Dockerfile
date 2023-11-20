FROM docker.io/node:16-bullseye-slim as builder
RUN apt-get update \
    && apt-get install git -y \
    && git clone https://gitee.com/y_project/RuoYi-Cloud.git /tmp/RuoYi-Cloud \
    && cd /tmp/RuoYi-Cloud/ruoyi-ui \
    && npm install \
    && npm run build:prod

FROM docker.io/nginx:1.23.3-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /tmp/RuoYi-Cloud/ruoyi-ui/dist /var/www/html
