# Molecule Shell

A Shell Container to tests your [Ansible](https://www.ansible.com/) role using [Molecule](https://molecule.readthedocs.io/en/stable/).

## Requirements

This action can work with Molecule scenarios that use the [`docker`](https://molecule.readthedocs.io/en/latest/configuration.html#docker) driver.

This action expects the default Ansible role structure:

## Inputs

### `platform`

The OS you want to run on. Default `"fedora"`.

### `ansible`

The Ansible version of the container image to use. Default `"2.12"`.
Possible choices are: "previous", "current", "next"
    previous => Ansible 2.11
    current  => Ansible 2.12
    next     => Ansible latest package available

### `scenario`

The molecule scenario to run. Default `"default"`

### `command`

The molecule command to use. For example `lint`. Default `"test"`.

## Example usage


### local testing

-   Build Image
    ```BASH
    docker build -t docker-molecule-shell:local -f Dockerfile .
    ```
-   Go to a role-directory
-   Try linting
    ```BASH
    docker run --privileged \
               --volume $(pwd):/workspace/:z \
               --volume /var/run/docker.sock:/var/run/docker.sock:z \
               --tty \
               --interactive \
               --env command="lint" \
               docker-molecule-shell:local
    ```
-   Try testing (default scenario, default image)
    ```BASH
    docker run --privileged \
               --volume $(pwd):/workspace/:z \
               --volume /var/run/docker.sock:/var/run/docker.sock:z \
               --tty \
               --interactive \
               --env ansible="current" \
               docker-molecule-shell:local
    ```
-   Try testing (alterantive scenario, image ubuntu2004)
    ```BASH
    docker run --privileged \
               --volume $(pwd):/workspace/:z \
               --volume /var/run/docker.sock:/var/run/docker.sock:z \
               --tty \
               --interactive \
               --env ansible="current" \
               --env scenario="alternative" \
               --env platform="ubuntu2004" \
               docker-molecule-shell:local
    ```
