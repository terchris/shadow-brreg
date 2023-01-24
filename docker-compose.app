
# start this with docker compose up -d
version: '3.8'
services:
  app:
    container_name: shadow-app
    image: node:lts-alpine
    command: ["sh","-c","wget -O shadow-app-setup.sh https://raw.githubusercontent.com/terchris/shadow-brreg/main/shadow-app-setup.sh && chmod +x shadow-app-setup.sh && ./shadow-app-setup.sh"]    
    
    


# to connect to the container: docker exec -ti shadow-app sh 
