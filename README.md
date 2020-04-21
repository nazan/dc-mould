# Docker based Laravel development boilerplate

First of all install 'make'.

## Development image (Python interpreter)

    make build-dev

## Shell access to Python image
    
    make start

## Build a production image
    
    make build-prod

## For faster composer downloads, use this when running dc-mould image

    docker run -it --rm -v $HOME/.composer:/tmp -v /your/projects/root:/home/user/dist dc-mould

