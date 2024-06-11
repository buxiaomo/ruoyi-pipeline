FROM docker.io/nginx:1.23.3-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./RuoYi-Cloud/ruoyi-ui/dist /var/www/html
