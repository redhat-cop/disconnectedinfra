# vmware-disconnected

We use Terraform to create a bastion host with disconnected networks set up from which to operate.

## What gets set up

1. 2 internet connected portgroups (A WAN and LAN).  We could also place the artifact collection host directly on the "WAN", but more infrastructure may be desirable on the artifact collection network.
2. 3 disconnected portgroups (BASTION, SERVER, SHARED SERVICES).
3. An artifact collection VM.
