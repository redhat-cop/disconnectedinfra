
## Notes to install a custom cert on VMWare
```
#Enter bash shell
shell

#Reset shell to root
chsh -s /bin/bash root

#Trust the Let's Encrypt Root Cert
/usr/lib/vmware-vmafd/bin/dir-cli trustedcert publish --chain --cert /root/DARootCAX3.pem

administrator@vsphere.infrabuild.xyz

administrator@vsphere.disconnect.blue

#Run certificate manager to trust system
/usr/lib/vmware-vmca/bin/certificate-manager
/root/vsphere.disconnect.blue.pem
/root/vsphere.disconnect.blue-fullchain.crt

/root/vsphere.infrabuild.xyz.pem
/root/vsphere.infrabuild.xyz-fullchain.crt
```
