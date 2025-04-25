# How to add a VPN connection on  a peer device


To add another machine (e.g., an Arch Linux device like my device) to `WireGuard` `VPN`, you need to configure **both the server and client**, but the process is straightforward. Here’s how to do it:


## **Step 1: Generate Keys for the New Client**

On the new Arch machine, generate a **private key** and its corresponding **public key**:## **Step 1: Generate Keys for the New Client**

On the new Arch machine, generate a **private key** and its corresponding **public key**:

```bash
wg genkey | tee client-privatekey | wg pubkey > client-publickey
```

- `client-privatekey`: The client’s private key (keep this secure).
- `client-publickey`: The client’s public key (add this to the server’s config).
- Or whatever name you give it

## **Step 2: Update the Server Config**

On your `WireGuard` server, edit the server config (e.g., `/etc/wireguard/wg0.conf`) and add a new `[Peer]` section for the client:

```bash
[Peer]
# Name: Arch-Machine
PublicKey = <client-public-key-from-step-1>
AllowedIPs = 10.0.0.X/32  # Assign a unique IP in your VPN subnet (e.g., 10.0.0.3/32)
```

- Replace `<client-public-key-from-step-1>` with the contents of `client-publickey`.
- Use a unique IP address (e.g., `10.0.0.3/32`) for the client.

## **Step 3: Reload the Server Config**

Apply the changes without dropping existing connections:

```bash
sudo wg syncconf wg0 <(sudo wg-quick strip wg0)
```

Or restart the interface (disruptive):

```bash
sudo wg-quick down wg0 && sudo wg-quick up wg0
```

## **Step 4: Create the Client Config**

On the Arch machine, create a client config file (e.g., `wg0-client.conf`):

```bash
[Interface]
PrivateKey = <client-private-key-from-step-1>
Address = 10.0.0.X/24  # Same IP as in Step 2 (e.g., 10.0.0.3/24)
DNS = 10.0.0.1  # Your server/Pi-hole IP or a public DNS (e.g., 8.8.8.8)

[Peer]
PublicKey = <server-public-key>
Endpoint = your-server-ip-or-domain:51820
AllowedIPs = 0.0.0.0/0, ::/0  # Route all traffic through the VPN
PersistentKeepalive = 25
```

- Replace `<client-private-key-from-step-1>` with the contents of `client-privatekey`.
- Replace `<server-public-key>` with your server’s public key (found in its config).


## **Step 5: Connect the Client**

On the Arch machine:

```bash
sudo wg-quick up wg0-client
```

Verify the connection:

```bash
sudo wg show
```

## **Key Notes**

- **No Server Restart Needed:** Use `wg syncconf` to avoid disrupting existing connections.
- **Firewall/NAT:** If your server already has NAT rules (e.g., `iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE`), new clients will work without changes.
- **Unique IPs:** Ensure no two clients share the same IP in the `AllowedIPs` field.


## **Troubleshooting**

- If the client can’t connect:
    
    - Verify keys and IPs match between server/client configs
    - Ensure the server’s firewall allows UDP port `51820`.
    - Check NAT rules on the server.
- Test connectivity with `ping 10.0.0.1` (server IP) from the client.


|Step|Server Action|Client Action|
|---|---|---|
|Generate Keys|None|`wg genkey` and `wg pubkey`|
|Update Server|Add `[Peer]` section|None|
|Reload Server|`wg syncconf` or `wg-quick restart`|None|
|Client Config|None|Create `wg0-client.conf`|
|Connect Client|None|`wg-quick up wg0-client`|



