# <server>

<what the server is for, and why it sits on site>. Settings in `server.env`.

| Item | Value |
|---|---|
| Hardware | <board or box, memory, boot disk> |
| Site | <site>, its infra network |
| Address | <site address>, reserved on the gateway; `<server>.<site domain>` |
| Tunnel | <10.21.0.x> |
| Users | <admin> admin; <service-user> runs the jobs, no sudo |
| State | <what it holds, where it is copied nightly> |

## Adding it

1. On the gateway, reserve an address on the infra network and add the
   server's name to the site's local domain.
2. Fill in `server.env` and this readme, then `make banner SRV=<server>`.
3. Image it. A Pi: Raspberry Pi OS Lite 64-bit, hostname the server's name,
   the service user with a key from `base/authorized-keys`, SSH by key
   only, no WiFi.
4. `make baseline SRV=<server> LOGIN=<service-user>`, from the site's
   network. It creates the admins, takes the service user out of sudo,
   closes SSH to `SSH_FROM`, and with `TUNNEL_ADDRESS` set makes the server a
   tunnel peer and prints its public key. Every later run is without `LOGIN`.
5. The key into the vpn server's `peers` with that address, the address into
   its `WG_SERVER_PEERS`, then `make baseline` for the vpn server. SSH moves
   to the tunnel address.
6. Secrets, the test alert and the console password, as for every server.
