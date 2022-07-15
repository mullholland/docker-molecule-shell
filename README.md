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
docker run -d --name docker-molecule-shell \
    --cap-add SYS_ADMIN \
    --privileged \
    --cgroupns=host \
    -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /PATH/TO/REPOSITORY/:/workspace \
    ghcr.io/mullholland/docker-molecule-shell:latest /usr/sbin/init

docker exec -it docker-molecule-shell /bin/bash
```
