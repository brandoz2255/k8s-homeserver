
# 🏡 Kubernetes Home Server for Microservices & DevSecOps Training

This repository documents the infrastructure of a Kubernetes-based home server project designed to enhance personal productivity and serve as a practical DevSecOps learning environment.

The architecture consists of **four nodes**, each hosting containerized microservices to support networking, automation, personal tools, and secure operations. While this repository focuses on the **Kubernetes, Ansible, and GitOps** side of DevSecOps, the application development (Dev side) is handled in a separate repository.

---

## 🚀 Project Goals

- Gain hands-on experience with Kubernetes, Ansible, and GitOps workflows.
- Design a scalable, secure, and maintainable infrastructure for personal use.
- Implement DevSecOps practices across multiple nodes.
- Host and manage containerized services to automate daily tasks and improve productivity.

---

## 📁 Project Scope

This repository covers the **Ops side** of `DevSecOps`:

- `Kubernetes` manifests
- `Ansible` playbooks
- `GitOps` configurations using `FluxCD`
- Node infrastructure definitions

The **Dev side**, including the custom dashboard application to manage containers, is hosted [in a separate repository](#) and built using Go for high performance.

---

## 🧠 Node Architecture

### 🔹 Node 1: Raspberry Pi 5 — DNS & VPN Gateway

- `Pi-hole` DNS ad blocker
- `WireGuard` VPN gateway
- Custom RESTful API container for the web app backend
- `Prometheus` for metrics collection
- `PostgreSQL` container

### 🔹 Node 2: Raspberry Pi 5 — Secure Password Management

- `Vaultwarden` container for password management
- `Prometheus` container for local metrics
- Custom RESTful API container
- `PostgreSQL` container

### 🔹 Node 3: Main PC — Central Node with Productivity Services

- `Wallabag` for article saving and offline reading
- `pgAdmin` for managing local databases
- Three `PostgreSQL` databases (for separate services)
- Web app front-end container (React/Next.js)
- Web app backend container (Go)
- Ingress controller (NGINX)
- Bookmark manager container (e.g., Shiori or Linkwarden)

### 🔹 Node 4: Main PC KVM — Other to use

- Still brainstorming
- I turned my Arch set up into a hypervisor using `KVM` and `automations` like `ansible` and `terraform` to provision but haven't used them

---

## 🔧 Technologies Used

- **Kubernetes** for orchestration
- **Ansible** for configuration management
- **FluxCD** for GitOps deployments
- **Docker** for containerization
- **Prometheus** for observability
- **GitLab & GitHub** for CI/CD and public documentation

---

## 🛠️ Work In Progress

- [ ] Build and deploy Go-based container dashboard
- [x] Set up FluxCD to automate deployments across all nodes ✅ 2025-04-13
- [ ] Harden network security between nodes
- [ ] Implement centralized monitoring and alerting

---

## 📄 License

This repository is maintained for educational and personal use. See `LICENSE` for details.
