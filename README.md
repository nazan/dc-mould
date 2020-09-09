# Docker based Laravel development boilerplate

## How to use

1. Install 'make'. Use apt, yum, pacman etc, depending on your Linux distro.
2. Clone this repository to any directory of your choice and change directory into it.
3. Run the following command to create the dc-mould image in your local docker registry.
```
make build-prod
```
4. Execute dc-mould as follows.
```
docker run -it --rm -v $HOME/.composer:/tmp -v /your/projects/root:/home/user/dist dc-mould
```
5. Finally, follow the on-screen instructions.


## Development

### Development image (Python interpreter)
```
make build-dev
```

### Shell access to Python image
```
make start
```

### Build a production image
```
make build-prod
```

    

