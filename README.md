# ⚡ ShellStrike

```text
███████╗██╗  ██╗███████╗██╗     ██╗         ███████╗████████╗██████╗ ██╗██╗  ██╗███████╗
██╔════╝██║  ██║██╔════╝██║     ██║         ██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝
███████╗███████║█████╗  ██║     ██║         ███████╗   ██║   ██████╔╝██║█████╔╝ █████╗
╚════██║██╔══██║██╔══╝  ██║     ██║         ╚════██║   ██║   ██╔══██╗██║██╔═██╗ ██╔══╝
███████║██║  ██║███████╗███████╗███████╗    ███████║   ██║   ██║  ██║██║██║  ██╗███████╗
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝
```

### Kali Linux Security Toolkit

> Bash-powered toolkit for network discovery, port scanning, Linux auditing, log analysis, and passive web reconnaissance.

[![Platform](https://img.shields.io/badge/Platform-Kali%20Linux-blue?style=for-the-badge\&logo=kalilinux)](https://www.kali.org/)
[![Shell](https://img.shields.io/badge/Shell-Bash-green?style=for-the-badge\&logo=gnubash)](https://www.gnu.org/software/bash/)
[![Security](https://img.shields.io/badge/Focus-Cybersecurity-red?style=for-the-badge)](#)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

---

## `> ./shellstrike.sh`

ShellStrike is modular cybersecurity toolkit built from scratch in Bash for Kali Linux.

It combines:

```text
Network Discovery
      ↓
Port Scanning
      ↓
Linux Security Audit
      ↓
Log Analysis
      ↓
Passive Web Recon
      ↓
Timestamped Reports
```

Built as hands-on project to learn:

* Bash scripting
* Linux internals
* Networking
* Nmap
* DNS
* HTTP/TLS
* Linux security
* Log analysis
* Security automation

---

# `01 // FEATURES`

| Module        | Function                                             |
| ------------- | ---------------------------------------------------- |
| `NetScout`    | Local network discovery and live-host detection      |
| `PortPilot`   | Nmap-based port and service scanning                 |
| `LinuxAudit`  | Linux security hardening checks                      |
| `LogSentinel` | Failed-login and suspicious log analysis             |
| `WebRecon`    | Passive DNS, HTTP, robots.txt and TLS checks         |
| `ShellStrike` | Interactive terminal interface and report management |

---

# `02 // TERMINAL PREVIEW`

<p align="center">
  <img width="735" height="447" alt="image" src="https://github.com/user-attachments/assets/016dfbfc-ef58-4bd8-b4a4-7e19d275719a" />
</p>

<p align="center">
  <i>ShellStrike running on Kali Linux</i>
</p>

---

# `03 // TOOLKIT`

## `NetScout`

Discovers local network information and identifies live hosts.

```text
Interface
    ↓
Local IP
    ↓
Gateway
    ↓
Subnet
    ↓
Nmap Ping Scan
    ↓
Live Hosts
```

Run:

```bash
./tools/netscout.sh
```

---

## `PortPilot`

Nmap wrapper for top 100 common ports with service/version detection.

```bash
./tools/portpilot.sh 192.168.1.10
```

Example target:

```text
192.168.1.10
```

Output includes:

```text
PORT
STATE
SERVICE
VERSION
```

---

## `LinuxAudit`

Performs heuristic Linux security checks.

Checks include:

```text
Users
SSH configuration
Firewall status
File permissions
Running services
SUID files
System configuration
```

Run:

```bash
./tools/linuxaudit.sh
```

> Score is project-specific heuristic score. Not professional security certification.

---

## `LogSentinel`

Analyzes authentication logs for failed login attempts and repeated suspicious patterns.

Run:

```bash
./tools/logsentinel.sh
```

Some log analysis may require:

```bash
sudo ./tools/logsentinel.sh
```

---

## `WebRecon`

Passive web reconnaissance tool.

Checks:

```text
DNS records
HTTP headers
robots.txt
TLS certificate information
```

Run:

```bash
./tools/webrecon.sh https://example.com
```

No exploitation.

No brute forcing.

Passive checks only.

---

# `04 // INSTALLATION`

Clone repository:

```bash
git clone https://github.com/anshnarsale/ShellStrike.git
cd ShellStrike
```

Make scripts executable:

```bash
chmod +x shellstrike.sh tools/*.sh
```

---

## Dependencies

Check installed tools:

```bash
which nmap dig curl openssl figlet
```

Install missing dependencies:

```bash
sudo apt install nmap dnsutils curl openssl figlet
```

Designed for Kali Linux.

---

# `05 // USAGE`

Launch ShellStrike:

```bash
./shellstrike.sh
```

Direct tool execution:

```bash
./tools/netscout.sh

./tools/portpilot.sh 192.168.1.10

./tools/linuxaudit.sh

./tools/logsentinel.sh

./tools/webrecon.sh https://example.com
```

Help:

```bash
./tools/netscout.sh --help
```

Version:

```bash
./shellstrike.sh --version
```

---

# `06 // PROJECT STRUCTURE`

```text
ShellStrike/
│
├── shellstrike.sh
│
├── lib/
│   ├── colors.sh
│   ├── messages.sh
│   ├── validate.sh
│   ├── logging.sh
│   └── traps.sh
│
├── tools/
│   ├── netscout.sh
│   ├── portpilot.sh
│   ├── linuxaudit.sh
│   ├── logsentinel.sh
│   └── webrecon.sh
│
├── reports/
│   └── *.log
│
├── screenshots/
│   └── shellstrike-demo.png
│
├── README.md
├── LICENSE
└── .gitignore
```

---

# `07 // ARCHITECTURE`

```text
                    ┌──────────────────────┐
                    │     ShellStrike      │
                    │    Main Interface    │
                    └──────────┬───────────┘
                               │
             ┌─────────────────┼─────────────────┐
             │                 │                 │
             ▼                 ▼                 ▼
        ┌─────────┐       ┌──────────┐      ┌───────────┐
        │ NetScout│       │PortPilot │      │LinuxAudit │
        └────┬────┘       └────┬─────┘      └─────┬─────┘
             │                 │                  │
             └─────────────────┼──────────────────┘
                               │
             ┌─────────────────┼─────────────────┐
             ▼                                   ▼
       ┌─────────────┐                     ┌───────────┐
       │LogSentinel  │                     │ WebRecon  │
       └──────┬──────┘                     └─────┬─────┘
              │                                  │
              └────────────────┬─────────────────┘
                               ▼
                       ┌────────────────┐
                       │    Reports     │
                       │ Timestamped Log│
                       └────────────────┘
```

---

# `08 // REPORTING`

ShellStrike automatically stores scan output inside:

```text
reports/
```

Reports use timestamps so multiple scans can be stored without overwriting previous results.

Example:

```text
reports/
├── netscout_2026-09-14_143022.log
├── portpilot_2026-09-14_143155.log
├── linuxaudit_2026-09-14_143401.log
└── webrecon_2026-09-14_143522.log
```

---

# `09 // SECURITY`

ShellStrike is intended strictly for:

```text
[+] Education
[+] Lab environments
[+] Own systems
[+] Authorized security testing
```

Use only against systems and networks you own or have explicit permission to test.

Unauthorized scanning, access, or testing may be illegal.

The author assumes no responsibility for misuse.

---

# `10 // LIMITATIONS`

```text
[!] LinuxAudit uses project-specific heuristic scoring.

[!] PortPilot scans top 100 common ports by default.

[!] WebRecon performs passive checks only.

[!] Some LogSentinel checks require sudo.

[!] No exploitation functionality included.
```

---

# `11 // ROADMAP`

```text
[x] Network discovery
[x] Port scanning
[x] Linux security auditing
[x] Authentication log analysis
[x] Passive web reconnaissance
[x] Automatic reports
[x] Interactive terminal UI

[ ] WebRecon subdomain enumeration
[ ] JSON report export
[ ] HTML report export
[ ] IPv6-aware NetScout
[ ] Configurable PortPilot port ranges
[ ] LogSentinel email alerts
[ ] Webhook alerts
```

---

# `12 // WHY I BUILT THIS`

ShellStrike started as hands-on Bash project to understand what happens behind common cybersecurity tools.

Instead of building one large application, toolkit was split into small modules.

Each module focuses on one security task.

```text
Learn Bash
    ↓
Understand Linux
    ↓
Understand Networking
    ↓
Automate Security Tasks
    ↓
Build ShellStrike
```

---

# `13 // AUTHOR`

### Ansh Narsale

Computer Engineering Student | Cybersecurity & Networking Learner | Developer

Built as hands-on learning project focused on:

```text
Bash
Linux
Networking
Cybersecurity
Security Automation
```

GitHub:

```text
https://github.com/anshnarsale
```

Portfolio:

```text
https://anshnarsale.netlify.app/
```

---

## `> END OF TRANSMISSION`

```text
[ ShellStrike ]
[ Scan. Audit. Analyze. Learn. ]
```

Made for learning. Built with Bash.
