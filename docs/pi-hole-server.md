## **How You Set Up Pi-hole as Your DNS Server**

- I installed Pi-hole, typically on a Raspberry Pi, using its automated script.

```bash
curl -sSL https://install.pi-hole.net | bash
```

Then you would do this as well

- select _upstream DNS providers_—these are external `DNS` servers Pi-hole queries when it doesn’t already have an answer cached
- choose providers like `Cloudflare` (1.1.1.1) or `Quad9` (9.9.9.9)
- Pi-hole then provided you with its own IP address, which you set as the `DNS` server for your network
- Which I did on my home router

## **How the DNS Settings Work (Cloudflare, Quad9, etc.)**

- In the Pi-hole admin interface (Settings > `DNS`), the _check mark section_ lets you select which upstream `DNS` providers Pi-hole should use
- When you check `Cloudflare` or `Quad9`, you’re telling Pi-hole to forward `DNS` queries it can’t answer locally to these providers.
- Cloudflare (1.1.1.1) and Quad9 (9.9.9.9) are public DNS resolvers known for privacy and security:
  - **Cloudflare** emphasizes privacy, claiming not to log your IP and offering fast resolution.
  - **Quad9** blocks known malicious domains, adding a layer of security.

### How I used this with my VPN

- Essentially when I connect to my `VPN` Using `Wireguard` I'm using my Pi as a `DNS`  server that my `VPN` can use
- My `VPN` server  routes its `DNS` queries through the `VPN` tunnel onto my Pi-hole server
- Which means I get ad-blocking and tracking protection even When I'm away from home since all of my DNS traffic is filtered by my `Pi-hole server`
