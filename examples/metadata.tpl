network:
  version: 2
  ethernets:
    eth0:
      match: 
        macaddress: 00:50:56:AA:BB:CC
      addresses:
      - 10.80.2.10/24
      gateway4: 10.80.2.254
      nameservers:
        addresses:
        - 1.1.1.1
local-hostname: testme.disconnect.blue
instance-id: testme.disconnect.blue
