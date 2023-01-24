FROM node:lts-alpine
RUN apk add git
RUN apk add apk-cron
RUN npm install -g typescript
RUN git clone --no-hardlinks https://github.com/terchris/shadow-brreg  


# make scripts executable
RUN chmod +x /shadow-brreg/app/shadow/shadow-appinstall.sh
RUN chmod +x /shadow-brreg/app/shadow/shadow-cronjob.sh
RUN chmod +x /shadow-brreg/app/shadow/shadow-cronstart.sh

# yarn build the node app
RUN /shadow-brreg/app/shadow/shadow-appinstall.sh

# add the cronjob to cron
RUN /usr/bin/crontab /shadow-brreg/app/shadow/cronjobs.txt

# start cron
CMD ["/shadow-brreg/app/shadow/shadow-cronstart.sh"]




#RUN cd /shadow-brreg/app/shadow
#RUN ls -la 
#RUN pwd