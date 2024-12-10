# Network Information Tool (netinfo.sh)
netinfo.sh is a Bash script designed to calculate and display subnetting information for a given IP address w
## Features
- Calculates and displays:
- Network Mask
- Total Hosts Available
- Network ID
- Broadcast Address
- Validates input for proper IP and CIDR format.
- Handles special cases for /31 and /32 CIDR notations.
## Usage
### Example
```bash
./netinfo.sh 192.168.1.10/24
```
### Output
```
==============================================
Network Information for 192.168.1.10/24
----------------------------------------------
Network Mask: 255.255.255.0
Total Hosts: 254
Network ID: 192.168.1.0
Broadcast: 192.168.1.255
==============================================
```
## Requirements
- A Unix-like environment with Bash.
## Installation
1. Clone the repository:
```bash
git clone https://github.com/yourusername/netinfo.git
```
2. Navigate to the directory:
```bash
cd netinfo
```
3. Make the script executable:
```bash
chmod +x netinfo.sh
```
## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes with a descriptive message.
4. Submit a pull request.
## License
This project is licensed under the MIT License. See the LICENSE file for details.
---
Created as part of ethical hacking studies.
=======
# subneting-tool
A simple Bash tool for calculating subnet information (network mask, total hosts, network ID, and broadcast address) given an IP and CIDR.
