
## DockerHub VsCode devcontainer PHP configurable image.

- Registry: [DockerHub](https://hub.docker.com/r/google85/vscode-devcontainer-php/)

- Source code: [GitHub](https://github.com/google85/vscode-devcontainer-php)

- Usage:
    - Pull the image
    ```bash
    docker pull google85/vscode-devcontainer-php:8.1
    ```
    
    - Create a `.devcontainer` folder in the root of your project
    ```bash
    mkdir -p .devcontainer
    ```

    - Create the `devcontainer.json` configuration file
    ```bash
    cat <<EOF | tee .devcontainer/devcontainer.json
    {
        "name": "PHP",
        "dockerComposeFile": "docker-compose.devcontainer.yml",
        "service": "php",
        "workspaceFolder": "/var/www/html",
        "mounts": [
            "source=${localEnv:HOME}${localEnv:USERPROFILE}/.ssh,target=/home/user/.ssh,type=bind,consistency=cached",
            "source=${localEnv:HOME}${localEnv:USERPROFILE}/.config/composer,target=/home/user/.config/composer,type=bind,consistency=cached"
        ],
        "customizations": {
            "vscode": {
                "settings": {
                },

                // Add the IDs of extensions you want installed when the container is created.
                "extensions": [
                    "bmewburn.vscode-intelephense-client",
                    "junstyle.php-cs-fixer",
                    "SanderRonde.phpstan-vscode",
                    "emallin.phpunit"
                ]
            }
        },
        "forwardPorts": [
            8000
        ]
    }
    EOF
    ```

    - Create the `docker-compose.devcontainer.yml` to be used
    ```bash
    cat <<EOF | tee .devcontainer/docker-compose.devcontainer.yml
    version: '3'
    services:
    php:
        image: google85/vscode-devcontainer-php:8.1
        container_name: php
        restart: unless-stopped
        working_dir: /var/www/html
        #env_file:
        #- ../.env
        environment:
        - TZ=Europe/Bucharest
        - COMPOSER_AUTH=
        volumes:
        - .:/var/www/html:cached
        extra_hosts:
        - "host.docker.internal:host-gateway"
        networks:
            app-net:

    networks:
        app-net:
    EOF
    ```

- Use VsCode `Reopen in DevContainer` option.
