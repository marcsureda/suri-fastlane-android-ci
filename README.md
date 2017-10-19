**To build the image without docker-compose**
docker build -t msuri/suri-fastlane-android-ci .

**To run without docker-compose**
docker run -it --rm msuri/suri-fastlane-android-ci bash

**To execute docker compose**
docker-compose down --rmi all
docker-compose build
docker-compose up --build -d

**To stop them**
docker-compose stop