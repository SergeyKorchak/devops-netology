1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

	```
	sergey@pc:~$ ip address
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	    inet 127.0.0.1/8 scope host lo
	       valid_lft forever preferred_lft forever
	    inet6 ::1/128 scope host 
	       valid_lft forever preferred_lft forever
	2: enp3s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
	    link/ether 60:02:92:15:80:89 brd ff:ff:ff:ff:ff:ff
	3: wlp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
	    link/ether 1c:d2:1x:f6:a0:01 brd ff:ff:ff:ff:ff:ff
	    inet 192.168.100.00/24 brd 192.168.100.255 scope global dynamic noprefixroute wlp2s0
	       valid_lft 13621sec preferred_lft 13621sec
	    inet6 fk39::239:51as:addc:6014/64 scope link noprefixroute 
	       valid_lft forever preferred_lft forever
	
	sergey@pc:~$ ip link
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	2: enp3s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
	    link/ether 11:02:14:61:80:80 brd ff:ff:ff:ff:ff:ff
	3: wlp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DORMANT group default qlen 1000
	    link/ether c1:d2:a1:f6:a1:61 brd ff:ff:ff:ff:ff:ff
	
	sergey@pc:~$ ifconfig
	enp3s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        	ether 60:02:92:15:80:89  txqueuelen 1000  (Ethernet)
        	RX packets 0  bytes 0 (0.0 B)
        	RX errors 0  dropped 0  overruns 0  frame 0
        	TX packets 0  bytes 0 (0.0 B)
        	TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        	device interrupt 18  
	
	lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        	inet 127.0.0.1  netmask 255.0.0.0
        	inet6 ::1  prefixlen 128  scopeid 0x10<host>
        	loop  txqueuelen 1000  (Local Loopback)
        	RX packets 665  bytes 68564 (68.5 KB)
        	RX errors 0  dropped 0  overruns 0  frame 0
        	TX packets 665  bytes 68564 (68.5 KB)
        	TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
	
	wlp2s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        	inet 192.168.100.77  netmask 255.255.255.0  broadcast 192.168.100.255
        	inet6 fk39::239:51as:addc:6014  prefixlen 64  scopeid 0x20<link>
        	ether 1c:d2:1x:f6:a0:01  txqueuelen 1000  (Ethernet)
        	RX packets 104023  bytes 142382957 (142.3 MB)
        	RX errors 0  dropped 0  overruns 0  frame 36116
        	TX packets 47096  bytes 5688125 (5.6 MB)
        	TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
	        device interrupt 17  
	```

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

	```
	Протокол LLDP. Пакет lldpd. Команда lldpctl.
	
	sergey@pc:~$ lldpctl
	-------------------------------------------------------------------------------
	LLDP neighbors:
	-------------------------------------------------------------------------------
	```

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

	```
	Технология VLAN - виртуальное разделение коммутатора.
	Пакет vlan.
	
	Пример файла /etc/network/interfaces:
	auto bond0
	iface bond0 inet manual
        	bond-slaves eno1 eno2
	        bond-mode 4
        	bond-miimon 100
	        bond-downdelay 200
        	bond-updelay 200
	        bond-lacp-rate 1
        	bond-xmit-hash-policy layer2+3
	        up ifconfig bond0 0.0.0.0 up
	
	auto bond0.123
	iface bond0.123 inet static
		address 10.123.0.3
        	netmask 255.255.255.0
	        mtu 1500
        	gateway 10.123.0.1
	        vlan-raw-device bond0
        	post-up ifconfig bond0.123 mtu 1500
	
	auto bond0.456
	iface bond0.456 inet static
        	address 192.168.456.4
	        netmask 255.255.255.0
        	mtu 9000
	        vlan-raw-device bond0
        	post-up ifconfig vlan456 mtu 9000
	        post-up ifconfig eno1 mtu 9000 && ifconfig eno2 mtu 9000 && ifconfig bond0 mtu 9000 && ifconfig bond0.456 9000
	```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

	```
	Mode-0(balance-rr) – Данный режим используется по умолчанию. Balance-rr обеспечивается балансировку нагрузки и отказоустойчивость. В данном режиме сетевые пакеты отправляются “по кругу”, от первого интерфейса к последнему. Если выходят из строя интерфейсы, пакеты отправляются на остальные оставшиеся. Дополнительной настройки коммутатора не требуется при нахождении портов в одном коммутаторе. При разностных коммутаторах требуется дополнительная настройка.

	Mode-1(active-backup) – Один из интерфейсов работает в активном режиме, остальные в ожидающем. При обнаружении проблемы на активном интерфейсе производится переключение на ожидающий интерфейс. Не требуется поддержки от коммутатора.

	Mode-2(balance-xor) – Передача пакетов распределяется по типу входящего и исходящего трафика по формуле ((MAC src) XOR (MAC dest)) % число интерфейсов. Режим дает балансировку нагрузки и отказоустойчивость. Не требуется дополнительной настройки коммутатора/коммутаторов.

	Mode-3(broadcast) – Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость. Рекомендуется только для использования MULTICAST трафика.

	Mode-4(802.3ad) – динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика. Для данного режима необходима поддержка и настройка коммутатора/коммутаторов.

	Mode-5(balance-tlb) – Адаптивная балансировки нагрузки трафика. Входящий трафик получается только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.

	Mode-6(balance-alb) – Адаптивная балансировка нагрузки. Отличается более совершенным алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как исходящего так и входящего трафика. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.
	
	Modify the /etc/network/interfaces file:
	# Define slaves   
	auto eth0
	iface eth0 inet manual
	    bond-master bond0
	    bond-primary eth0
	    bond-mode active-backup
	   
	auto wlan0
	iface wlan0 inet manual
	    wpa-conf /etc/network/wpa.conf
	    bond-master bond0
	    bond-primary eth0
	    bond-mode active-backup
	
	# Define master
	auto bond0
	iface bond0 inet dhcp
	    bond-slaves none
	    bond-primary eth0
	    bond-mode active-backup
	    bond-miimon 100
	```

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

	```
	Для маски /29 доступных адресов - 8. Хостов - 6.
	Для маски /24 доступных адресов - 256. Хостов - 254. Можно разбить на 32 подсети.
	Примеры: 10.10.10.0/29, 10.10.10.8/29, 10.10.10.16/29, 10.10.10.24/29, ...
	
	sergey@pc:/$ ipcalc 192.168.1.1/29
	Address:   192.168.1.1          11000000.10101000.00000001.00000 001
	Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
	Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
	=>
	Network:   192.168.1.0/29       11000000.10101000.00000001.00000 000
	HostMin:   192.168.1.1          11000000.10101000.00000001.00000 001
	HostMax:   192.168.1.6          11000000.10101000.00000001.00000 110
	Broadcast: 192.168.1.7          11000000.10101000.00000001.00000 111
	Hosts/Net: 6                     Class C, Private Internet

	sergey@pc:/$ ipcalc 192.168.1.1/24
	Address:   192.168.1.1          11000000.10101000.00000001. 00000001
	Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
	Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
	=>
	Network:   192.168.1.0/24       11000000.10101000.00000001. 00000000
	HostMin:   192.168.1.1          11000000.10101000.00000001. 00000001
	HostMax:   192.168.1.254        11000000.10101000.00000001. 11111110
	Broadcast: 192.168.1.255        11000000.10101000.00000001. 11111111
	Hosts/Net: 254                   Class C, Private Internet
	```
	
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

	```
	100.64.0.0 — 100.127.255.255 (маска подсети: 255.192.0.0 или /10) Carrier-Grade NAT.
	Маска /26 для 62 хостов.
	```

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

	```
	sergey@pc:/$ ip neigh show
	192.168.100.19 dev wlp2s0 lladdr d8:**:**:**:**:d9 STALE
	192.168.100.30 dev wlp2s0 lladdr 14:**:**:**:**:0f STALE
	192.168.100.1 dev wlp2s0 lladdr a4:**:**:**:**:93 REACHABLE
	fe80::131b:d38a:a367:ddb5 dev wlp2s0 lladdr 14:**:**:**:**:0f STALE
	fe80::331e:c038:6fd2:d076 dev wlp2s0 lladdr d8:**:**:**:**:d9 STALE
	fe80::1 dev wlp2s0 lladdr a4:**:**:**:**:93 router STALE
	
	ip neigh flush all - очистить полностью
	ip neigh delete <IP> dev <INTERFACE> - удалить один
	```