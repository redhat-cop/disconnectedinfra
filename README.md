# NOTE: This repository is still in very early incubation stages (you might call it Pre-Alpha)
## What does this mean?
Basically there's a lot of code in here that works but is not particularly well-documented or designed to be run in a pipeline just yet.  There's a lot of reasons for that, but the short answer is that bootstrapping a system is no fun.  We love pre-deployed systems that have been standardized with credentials and can leverage SSH or WinRM to start configuring them.  Unfortunately installing those systems means a wide variety of syntax and possible failure domains and there are problems ranging from systems that don't support answer files at all to systems that need answer file tweaks for every platform they might be deployed to.

All of that just gets you to a point where you have a system that could be leveraged by Ansible/Terraform/<config language here> to actually spin up a target environment.
  
As we move toward a model where most users of the codebase are consuming rather than developing it, the goal is to abstract that complexity to a simple solution that just gets you a VM (and gives you ways to do something interesting with that VM).  

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
