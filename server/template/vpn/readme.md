# <code>-htz-srv-vpn

The one server with a public IP: WireGuard for the peers, and NAT so the
private network reaches the internet through here. Settings in `server.env`,
peers in `peers`.

| Item | Value |
|---|---|
| Type | <server type>, <location> |
| Public IP | <code>-htz-ip4-vpn |
| Private address | <10.20.0.x> |
| Tunnel | 10.21.0.1, UDP 51820 |
| Users | <admin> |
| State | the WireGuard key, made on the server and kept there |

A peer is added as a line in `peers`, then `make baseline SRV=<code>-htz-srv-vpn`.
An on-site server's tunnel address also goes into `WG_SERVER_PEERS`, so the
other peers reach it.
