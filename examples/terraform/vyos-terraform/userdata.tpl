#cloud-config
write_files:
- content: |
    interfaces {
        ethernet eth0 {
            address 10.80.0.254/24
        }
        ethernet eth1 {
            address 10.90.0.254/24
        }
        ethernet eth2 {
            address 10.100.0.254/24
        }
        loopback lo {
        }
    }
    protocols {
        ospf {
            area 0 {
                network 0.0.0.0/0
            } 
            parameters {
                abr-type cisco
                router-id 10.80.0.254
            }
        }
    }
    service {
        ssh {
            port 22
        }
    }
    system {
        config-management {
            commit-revisions 100
        }
        console {
            device ttyS0 {
                speed 115200
            }
        }
        host-name vyos
        login {
            user vyos {
                authentication {
                    encrypted-password $6$ZzbNSkBMynro0fR$pTXkbQ52S/42INaOQsduB8pgXUJh.GgKT3.17CTWyPKakO3UPrtYkHngB7TxRSm8JN8tewhO8HdSQJxp4/i4c1
                    plaintext-password ""
                }
                level admin
            }
        }
        name-server 1.1.1.1
        ntp {
            server 0.pool.ntp.org {
            }
            server 1.pool.ntp.org {
            }
            server 2.pool.ntp.org {
            }
        }
        syslog {
            global {
                facility all {
                    level info
                }
                facility protocols {
                    level debug
                }
            }
        }
    }

    /* Warning: Do not remove the following line. */
    /* === vyatta-config-version: "broadcast-relay@1:cluster@1:config-management@1:conntrack@1:conntrack-sync@1:dhcp-relay@2:dhcp-server@5:dns-forwarding@2:firewall@5:interfaces@4:ipsec@5:l2tp@2:mdns@1:nat@4:ntp@1:pptp@1:qos@1:quagga@4:snmp@1:ssh@1:system@15:vrrp@2:vyos-accel-ppp@2:wanloadbalance@3:webgui@1:webproxy@2:zone-policy@1" === */
    /* Release version: 1.3-rolling-202001040217 */
  owner: root:vyattacfg
  path: /config/config.boot
  permissions: '0775'
power_state:
  mode: reboot
  message: Bye Bye
  timeout: 30
  condition: False
