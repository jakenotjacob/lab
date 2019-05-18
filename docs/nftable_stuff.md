NFTables configuration
======================


Add table named 'filter'for both ip and ip6
---
sudo nft add table inet filter

Add chain named 'input' to filter table
---
sudo nft list table inet filter

Add base chain that filters input packets
---
sudo nft add chain inet filter input { type filter hook input priority 0\; }

Change input chain policy of default table to 'accept'
---
sudo nft chain inet filter input { policy accept \; }

Add rule to default chain accepting traffic originated from us
---
sudo nft add rule inet filter input ct state established,related accept

Accept localhost traffic
---
sudo nft add rule inet filter input iif lo accept

Accept ICMP and IGMP
---
sudo nft add rule inet filter input ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, mld-listener-query, mld-listener-report, mld-listener-reduction, nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, ind-neighbor-solicit, ind-neighbor-advert, mld2-listener-report } accept

sudo nft add rule inet filter input ip protocol icmp icmp type { destination-unreachable, router-solicitation, router-advertisement, time-exceeded, parameter-problem } accept
sudo nft add rule inet filter input ip protocol igmp accept

Drop forward traffic
---
sudo ft add chain inet filter forward { type filter hook forward priority 0 \; policy drop \; }

Allow outgoing traffic
---
sudo nft add chain inet filter output { type filter hook output priority 0 \; policy accept \; }

Add regular TCP and UDP chains
---
sudo nft add chain inet filter TCP
sudo nft add chain inet filter UDP

Drop invalid traffic
---
sudo nft add rule inet filter input ct state invalid drop

New UDP traffic jumped to UDP chain
---
sudo nft add rule inet filter input ip protocol udp ct state new jump UDP

New TCP traffic jump to TCP chain
---
sudo nft add rule inet filter input ip protocol tcp tcp flags \& \(fin\|syn\|rst\|ack\) == syn ct state new jump TCP

Reject traffic unprocessed by other rules
---
sudo nft add rule inet filter input ip protocol udp reject
sudo nft add rule inet filter input counter reject with icmp type prot-unreachable
sudo nft add rule inet filter input ip protocol tcp reject with tcp reset

Accept SSH at 22 (using TCP table and without TCP table)
---
sudo nft add rule inet filter TCP tcp dport { 22 } accept
sudo nft add rule inet filter input tcp dport { 22 } ct state new accept

Count and drop any other traffic
---
sudo nft add rule inet filter input counter drop
