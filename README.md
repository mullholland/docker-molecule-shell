# Molecule Shell

A Shell Container to tests your [Ansible](https://www.ansible.com/) role using [Molecule](https://molecule.readthedocs.io/en/stable/).

# Usage

## Build the container
Clone the repository and build the container (needs docker isntalled)
```
git clone git@github.com:mullholland/docker-molecule-shell.git
cd docker-molecule-shell/
docker build -t docker-molecule-shell:local -f Dockerfile .
```

## Pull the container
```
docker pull ghcr.io/mullholland/docker-molecule-shell:latest
```

# Test ansible roles inside the container
Start the container
```
docker run -

docker exec docker-molecule-shell -it /bin/bash
```
# Test Roles from the outside

## Variables

### `ansible`
### `scenario`
### `command`
## Example usage

### linting
Go to a role-directory
```BASH
docker run --privileged \
        --volume $(pwd):/workspace/:z \
        --volume /var/run/docker.sock:/var/run/docker.sock:z \
        --tty \
        --interactive \
        --env command="lint" \
        docker-molecule-shell:local
```
### Try testing (default scenario, default image)
```BASH
docker run --privileged \
        --volume $(pwd):/workspace/:z \
        --volume /var/run/docker.sock:/var/run/docker.sock:z \
        --tty \
        --interactive \
        --env ansible="current" \
        docker-molecule-shell:local
```
### Try testing (alterantive scenario, image ubuntu2004)
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
