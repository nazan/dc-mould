# Run the following to setup.

docker build --build-arg USER_IDENT=$UID -t py37int .
docker run -it --rm --user $UID -v $(pwd):/home/user/app py37int bash

## Once you are on the container shell do

./packager.sh

