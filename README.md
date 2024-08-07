# strichliste-docker - Strichliste Docker Bundle

This is a docker container for the [strichliste](https://www.strichliste.org/) bundeling the [frontend](https://github.com/Westwoodlabs/strichliste-web-frontend) and [backend](https://github.com/Westwoodlabs/strichliste-backend), a MariaDB database and a the Telegram Bot [strichliste-telegram](https://github.com/Westwoodlabs/strichliste-telegram).

## Usage

- Clone this repository
- Create settings.env from template and change values for your needs
- Create docker-compose.yml from template and change for your needs
- Setup initial database

### Setup initial database
After configuring the environment variables you can start the container and create the inital database schema with the following command:
```
docker exec --user www-data strichliste-app php bin/console doctrine:schema:create
```
- you might need to wait a bit for the database to start up, the command will tell you if it succeeded or not
- don't forget to run the command on the correct container if you changed the container name
- you must run the command as `www-data`, otherwise file permissions from symphony framework will be wrong

## Templates
Example settings.env configuration:

```env
DB_HOST=strichliste-db
MYSQL_ROOT_PASSWORD=
MYSQL_DATABASE=strichliste
MYSQL_USER=strichliste
MYSQL_PASSWORD=
DATABASE_URL=mysql://strichliste:<changeme>@strichliste-db/strichliste
```

Example docker-compose configuration:

```yml
services:
  app:
    container_name: strichliste-app
    image: ghcr.io/westwoodlabs/strichliste:latest
    restart: unless-stopped
    env_file:
      - settings.env
    networks:
      - internal
    ports:
      - 80:80
    volumes:
      - ./data/strichliste/strichliste.yml:/var/www/html/config/strichliste.yaml
    depends_on:
      - db

  db:
    container_name: strichliste-db
    image: mariadb:11.4
    restart: unless-stopped
    env_file:
      - settings.env
    volumes:
      - ./data/db:/var/lib/mysql
    networks:
      - internal

  telegram:
    image: ghcr.io/westwoodlabs/strichliste-telegram:latest
    restart: unless-stopped
    volumes:
      - ./data/telegram/authorizedUsers.json:/usr/src/app/authorizedUsers.json
      - ./data/telegram/config.py:/usr/src/app/config.py
    networks:
      - internal

networks:
  internal:
    external: false
```

