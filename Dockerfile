FROM ubuntu:18.04
EXPOSE 9000
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git php-fpm php-cli php-curl php-json php-mysql curl php-xdebug zip unzip locales
RUN ln -fs /usr/share/zoneinfo/Europe/Riga /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
COPY ./install_composer.sh /root/install_composer.sh
RUN chmod u+x /root/install_composer.sh
RUN /root/install_composer.sh
RUN mkdir /root/.local/
RUN mkdir /root/.local/bin
RUN ln -s /root/composer.phar /root/.local/bin/composer
ENV PATH "$PATH:/root/.local/bin"
RUN sed -i -e '/^listen = /s/.*/listen = 9000/' /etc/php/7.2/fpm/pool.d/www.conf
RUN echo 'include_path = ".:/php_include"' >> /etc/php/7.2/fpm/php.ini
RUN echo 'include_path = ".:/php_include"' >> /etc/php/7.2/cli/php.ini
RUN mkdir /php_include
RUN mkdir /run/php
RUN git clone https://github.com/kykc/pficl.git /php_include/pficl
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ADD ./start.sh /start.sh
ENV T_UID=1000
ENV T_GID=1000
RUN chmod 0777 /root/composer.phar
CMD ["/start.sh"]
