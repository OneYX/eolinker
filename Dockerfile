FROM alpine:latest
LABEL maintainer="pingdongyi@gmail.com"

RUN echo 'http://mirrors.aliyun.com/alpine/latest-stable/main/' > /etc/apk/repositories \
    && echo 'http://mirrors.aliyun.com/alpine/latest-stable/community/' >> /etc/apk/repositories \
    && apk update

RUN apk add curl \
			nginx \
			php7 \
			php7-curl \
			php7-json \
			php7-session \
			php7-mbstring \
			php7-pdo \
			php7-pdo_mysql \
			php7-fpm \
	&& sed -i "s/display_errors = Off/display_errors = On/" /etc/php7/php.ini \
	&& sed -i "s/;error_log = php_errors.log/error_log = \/apps\/php\/php_errors.log/" /etc/php7/php.ini \
	&& mkdir -p /run/nginx \
	&& mkdir -p /apps/eolinker_os \
	&& resp=`curl https://api.eolinker.com/openSource/Update/checkout | grep -o 'eolinker_.*zip'` \
	&& url="http://data.eolinker.com/os/"${resp} \
	&& wget `echo $url` -O $resp \
	&& unzip $resp -nd /apps/eolinker_os > /dev/null 2>&1 \
	&& chmod -R 777 /apps/eolinker_os \
	&& rm -rf $resp
	

COPY default.conf /etc/nginx/conf.d/
COPY start.sh /root/
RUN chmod +x /root/start.sh

WORKDIR /apps
VOLUME ["/apps"]

EXPOSE 80

CMD ["/bin/sh","/root/start.sh"]