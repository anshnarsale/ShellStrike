# ShellStrike

**Kali Linux Security Toolkit** — a Bash-based collection of network, host, log, and web security tools built for learning and authorized security testing.

## Overview

ShellStrike is a modular cybersecurity toolkit built from scratch in Bash, designed to run on Kali Linux. It combines network discovery, port scanning, Linux security auditing, log analysis, and passive web reconnaissance into a single interactive toolkit — all wrapped in a clean, hacker-styled terminal interface.

This project was built step-by-step as a hands-on way to learn Bash scripting, Linux internals, and core networking/cybersecurity concepts.

## Features

- 🔍 **Network Discovery** — detect local network info and live hosts
- 🎯 **Port Scanning** — Nmap-powered service/version detection
- 🛡️ **Security Auditing** — heuristic Linux hardening checks
- 📋 **Log Analysis** — failed login detection and pattern flagging
- 🌐 **Web Reconnaissance** — passive DNS, HTTP, and TLS checks
- 🖥️ **Interactive Menu** — colorized, figlet-branded terminal UI
- 📁 **Automatic Reporting** — timestamped reports saved for every scan

## Tools

| Tool | Description |
|------|-------------|
| **NetScout** | Discovers local network interface, IP, gateway, and live hosts via Nmap ping scan |
| **PortPilot** | Nmap wrapper for scanning top 100 ports with service/version detection |
| **LinuxAudit** | Heuristic Linux security audit (users, SSH config, firewall, permissions, services) |
| **LogSentinel** | Analyzes auth logs for failed logins and suspicious repeated-failure patterns |
| **WebRecon** | Passive web recon — DNS records, HTTP headers, robots.txt, TLS certificate info |

## Installation

```bash
git clone https://github.com/anshnarsale/ShellStrike.git
cd ShellStrike
chmod +x shellstrike.sh tools/*.sh
```

### Dependencies

ShellStrike relies on standard Kali Linux tools. Most are pre-installed; verify with:

```bash
which nmap dig curl openssl figlet
```

If any are missing, install with:

```bash
sudo apt install nmap dnsutils curl openssl figlet
```

## Usage

Launch the interactive menu:

```bash
./shellstrike.sh
```

Or run any tool directly:

```bash
./tools/netscout.sh
./tools/portpilot.sh 192.168.1.10
./tools/linuxaudit.sh
./tools/logsentinel.sh
./tools/webrecon.sh https://example.com
```

Every tool supports `--help`:

```bash
./tools/netscout.sh --help
```

Check the main menu version:

```bash
./shellstrike.sh --version
```

## Project Structure

```
ShellStrike/
├── shellstrike.sh # Main interactive menu
├── lib/ # Shared Bash framework
│ ├── colors.sh
│ ├── messages.sh
│ ├── validate.sh
│ ├── logging.sh
│ └── traps.sh
├── tools/ # Individual security tools
│ ├── netscout.sh
│ ├── portpilot.sh
│ ├── linuxaudit.sh
│ ├── logsentinel.sh
│ └── webrecon.sh
├── reports/ # Auto-generated scan reports (gitignored)
├── screenshots/ # Demo screenshots
├── README.md
├── LICENSE
└── .gitignore
```

## Security & Ethical Use

ShellStrike is built strictly for **educational purposes and authorized security testing**. Only use these tools against:

- Your own systems and networks
- Environments you have explicit written permission to test

Unauthorized scanning, access, or testing of systems you do not own or have permission to test may be illegal. The author assumes no responsibility for misuse of this toolkit.

## Limitations

- LinuxAudit produces a **project heuristic score**, not a professional security certification
- PortPilot scans only the top 100 common ports by default (not a full port sweep)
- WebRecon performs passive checks only — no active exploitation or brute forcing
- Some checks require `sudo` for full log access (e.g. reading `/var/log/auth.log`)

## Future Improvements

- Add subdomain enumeration to WebRecon
- Export reports in JSON/HTML format
- Add IPv6-aware subnet detection in NetScout
- Configurable port ranges in PortPilot
- Optional email/webhook alerts for LogSentinel findings

## Author

Built by Ansh Narsale as a hands-on learning project in Bash scripting, Linux security, and networking fundamentals.
