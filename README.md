# strichliste-docker - A Strichliste Docker Container

This is a docker container for the [strichliste](https://www.strichliste.org/) using the [strichliste frontend and backend bundle](https://github.com/strichliste/strichliste), a MariaDB database and a the Telegram Bot [strichliste-telegram](https://github.com/Westwoodlabs/strichliste-telegram).

## Usage

- Clone this repository.
- Create settings.env from template and change values.
- Create docker-compose.yml from template and change for your needs (remove treafik for example).
- Setup initial database.

### Setup initial database
After configuring the environment variables you can start the container and create the inital database schema with the following command:
```
./../bin/console doctrine:schema:create
```
(you might need to wait a bit for the database to start up, the command will tell you if it succeeded or not)

## Templates
Example settings.env configuration:

```env
DB_HOST=db
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=strichliste
MYSQL_USER=strichliste
MYSQL_PASSWORD=
DATABASE_URL=mysql://strichliste:<changeme>@db/strichliste
```

Example docker-compose configuration:

```yml
version: "3.8"

services:

  web:
    build: ./data/web
    env_file:
      - settings.env
    networks:
      - reverse-proxy
      - internal
    volumes:
      - ./data/web/services.yaml:/var/www/html/config/services.yaml
      - ./data/web/strichliste.yaml:/var/www/html/config/strichliste.yaml
      - ./data/web/doctrine.yaml:/var/www/html/config/packages/doctrine.yaml
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.strichliste.rule=Host(`myhostname.fqdn.local`)"
      - "traefik.http.routers.strichliste.entryPoints=https"
      - "traefik.http.routers.strichliste.tls=true"
      - "traefik.http.services.strichliste.loadbalancer.server.scheme=http"
      - "traefik.http.services.strichliste.loadbalancer.server.port=80"
    restart: unless-stopped
    depends_on: 
      - db
  db:
    image: mariadb
    restart: unless-stopped
    env_file:
      - settings.env
    volumes:
      - ./data/db:/var/lib/mysql
    networks:
      - internal

  telegram:
    build: ./data/telegram
    restart: unless-stopped
    volumes:
      - ./data/telegram/authorizedUsers.json:/usr/src/app/authorizedUsers.json
      - ./data/telegram/config.py:/usr/src/app/config.py
    networks:
      - internal

networks:
  reverse-proxy:
    external: true
  internal:
    external: false
```

