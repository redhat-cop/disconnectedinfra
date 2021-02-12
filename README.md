# Disconnected Infra

Disconnected Infra automates the modeling of disconnected infrastructure in a connected world.  Many networks have restricted or no internet access, and are often regulated to ensure data ingress and egress is highly controlled (i.e. just putting things on a USB drive and transferring to the other network is broadly disallowed).  It can be very difficult to learn how to manage such infrastructure in such highly controlled environments where mistakes may have severe consequences.

Disconnected Infra allows you to model this environment so that you can freely experiment and learn without restriction.  The focus is not on being plug and play (although there is a reference architecture), but rather exploring the problem and how different solutions may be more or less suitable.

This repository is structured as an Ansible collection.

## Important Roles

[Image Creation](roles/image_creation/README.md) - this role is meant to solve the problem of consistently creating virtual machines across disparate infrastructure such as QEMU-KVM and VMWare.  
[Environment Bootstrapping](roles/env_bootstrap/README.md) - this role is meant to solve the problem of consistently creating virtual machines across disparate infrastructure such as QEMU-KVM and VMWare.

## What gets set up

1. 2 internet connected portgroups (A WAN and LAN).  We could also place the artifact collection host directly on the "WAN", but more infrastructure may be desirable on the artifact collection network.
2. 3 disconnected portgroups (BASTION, SERVER, SHARED SERVICES).
3. An artifact collection VM.

## Building images
`ansible-playbook -i ~/inventory playbooks/image_creation.yml`
