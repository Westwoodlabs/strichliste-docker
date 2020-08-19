#download StrichlisteTelegramBridge with git clone
FROM alpine:3.8 as release

RUN apk --no-cache add ca-certificates \
    && apk --no-cache add \
    git

RUN mkdir /source

WORKDIR /source

RUN git clone --depth=1 https://github.com/Westwoodlabs/strichliste-telegram.git . 

# build StrichlisteTelegramBridge container
FROM python:3

COPY --from=release /source /usr/src/app

WORKDIR /usr/src/app

RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

CMD [ "python", "./bot.py" ]