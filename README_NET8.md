1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP.

	```
	sergey@pc:~$ telnet route-views.routeviews.org
	Trying 128.223.51.103...
	Connected to route-views.routeviews.org.
	
	Username: rviews
	
	route-views>show ip route 212.58.***.***
	Routing entry for 212.58.96.0/19, supernet
	  Known via "bgp 6447", distance 20, metric 0
	  Tag 2497, type externa
	  Last update from 202.232.0.2 5d21h ago
	  Routing Descriptor Blocks:
	  * 202.232.0.2, from 202.232.0.2, 5d21h ago
	      Route metric is 0, traffic share count is 1
	      AS Hops 5
	      Route tag 2497
	      MPLS label: none

	route-views>show bgp 212.58.***.***     
	BGP routing table entry for 212.58.96.0/19, version 2667410705
	Paths: (20 available, best #20, table default)
	  Not advertised to any peer
	  Refresh Epoch 1
	  8283 1273 15924 44327 16010
	    94.142.247.3 from 94.142.247.3 (94.142.247.3)
	      Origin IGP, metric 0, localpref 100, valid, external
	      Community: 1273:12792 8283:1 8283:101 8283:102 15924:400 15924:900 15924:995
	      unknown transitive attribute: flag 0xE0 type 0x20 length 0x30
	        value 0000 205B 0000 0000 0000 0001 0000 205B
	              0000 0005 0000 0001 0000 205B 0000 0005
	              0000 0002 0000 205B 0000 0008 0000 001A
	      path 7FE0F0070628 RPKI State valid
	      rx pathid: 0, tx pathid: 0
	  Refresh Epoch 2
	  2497 1273 15924 44327 16010
	    202.232.0.2 from 202.232.0.2 (58.138.96.254)
	      Origin IGP, localpref 100, valid, external, best
	      path 7FE171A7A9A8 RPKI State valid
	      rx pathid: 0, tx pathid: 0x0
	```

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

	```
	sergey@pc:/$ sudo ip link add dummy0 type dummy
	sergey@pc:/$ sudo ip addr add 192.168.98.1/24 dev dummy0
	sergey@pc:/$ sudo ip link set dummy0 up
	sergey@pc:/$ ip route
	default via 192.168.100.1 dev wlp2s0 proto dhcp metric 600
	169.254.0.0/16 dev wlp2s0 scope link metric 1000
	192.168.98.0/24 dev dummy0 proto kernel scope link src 192.168.98.1
	192.168.100.0/24 dev wlp2s0 proto kernel scope link src 192.168.100.77 metric 600
	sergey@pc:/$ sudo ip route add to 10.10.0.0/16 via 192.168.98.1
	sergey@pc:/$ sudo ip route add to 10.1.1.11/32 via 192.168.98.1
	sergey@pc:/$ sudo ip route add to 10.2.2.11/32 via 192.168.98.1
	sergey@pc:/$ ip route
	default via 192.168.100.1 dev wlp2s0 proto dhcp metric 600
	10.1.1.11 via 192.168.98.1 dev dummy0
	10.2.2.11 via 192.168.98.1 dev dummy0
	10.10.0.0/16 via 192.168.98.1 dev dummy0
	169.254.0.0/16 dev wlp2s0 scope link metric 1000
	192.168.98.0/24 dev dummy0 proto kernel scope link src 192.168.98.1
	192.168.100.0/24 dev wlp2s0 proto kernel scope link src 192.168.100.77 metric 600
	```

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

	```
	sergey@pc:/$ sudo netstat -ntlp
	Active Internet connections (only servers)
	Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
	tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      929/cupsd           
	tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/init              
	tcp        0      0 0.0.0.0:2049            0.0.0.0:*               LISTEN      -                   
	tcp        0      0 0.0.0.0:39737           0.0.0.0:*               LISTEN      1103/rpc.mountd     
	tcp        0      0 0.0.0.0:47935           0.0.0.0:*               LISTEN      1103/rpc.mountd     
	tcp        0      0 0.0.0.0:46591           0.0.0.0:*               LISTEN      1103/rpc.mountd     
	tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      771/systemd-resolve 
	tcp        0      0 0.0.0.0:33971           0.0.0.0:*               LISTEN      -                   
	tcp        0      0 0.0.0.0:48177           0.0.0.0:*               LISTEN      1102/rpc.statd      
	tcp6       0      0 ::1:631                 :::*                    LISTEN      929/cupsd           
	tcp6       0      0 :::43481                :::*                    LISTEN      -                   
	tcp6       0      0 :::43485                :::*                    LISTEN      1103/rpc.mountd     
	tcp6       0      0 :::111                  :::*                    LISTEN      1/init              
	tcp6       0      0 :::2049                 :::*                    LISTEN      -                   
	tcp6       0      0 :::45953                :::*                    LISTEN      1102/rpc.statd      
	tcp6       0      0 :::34255                :::*                    LISTEN      1103/rpc.mountd     
	tcp6       0      0 :::42551                :::*                    LISTEN      1103/rpc.mountd     
	```

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

	```
	sergey@pc:/$ ss -lup
	State  Recv-Q Send-Q Local Address:Port					Peer Address:Port Process                                   
	UNCONN 0      0      127.0.0.1:854             				0.0.0.0:*         
	UNCONN 0      0      0.0.0.0:56254             				0.0.0.0:*         
	UNCONN 0      0      0.0.0.0:42107             				0.0.0.0:*          
	UNCONN 0      0      0.0.0.0:52399             				0.0.0.0:*         
	UNCONN 0      0      224.0.0.251:mdns          				0.0.0.0:*         users:(("chrome",pid=6635,fd=55))        
	UNCONN 0      0      24.0.0.251:mdns                             	0.0.0.0:*         users:(("chrome",pid=6635,fd=41))        
	UNCONN 0      0      224.0.0.251:mdns                             	0.0.0.0:*         users:(("chrome",pid=6584,fd=167))       
	UNCONN 0      0      224.0.0.251:mdns                             	0.0.0.0:*         users:(("chrome",pid=6584,fd=166))       
	UNCONN 0      0      0.0.0.0:mdns                             		0.0.0.0:*         
	UNCONN 0      0      0.0.0.0:59282                            		0.0.0.0:*         
	UNCONN 0      0      127.0.0.53%lo:domain                           	0.0.0.0:*         
	UNCONN 0      0      0.0.0.0:sunrpc                           		0.0.0.0:*         
	UNCONN 0      0      0.0.0.0:32946                            		0.0.0.0:*         
	UNCONN 0      0      0.0.0.0:51470                            		0.0.0.0:*         
	UNCONN 0      0      0.0.0.0:631                              		0.0.0.0:*         
	UNCONN 0      0      [::]:42156                               		[::]:*            
	UNCONN 0      0      [::]:mdns                                		[::]:*            
	UNCONN 0      0      [::]:52570                               		[::]:*            
	UNCONN 0      0      [::]:55382                               		[::]:*            
	UNCONN 0      0      [::]:49253                               		[::]:*            
	UNCONN 0      0      [::]:sunrpc                              		[::]:*            
	UNCONN 0      0      [fe80::519:51d8:a6dc:6391]%wlp2s0:dhcpv6-client    [::]:*            
	UNCONN 0      0      [::]:55885                               		[::]:*            
	UNCONN 0      0      [::]:33408                               		[::]:*
	```

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

	```
	Пример домашней сети на рисунке Network.png. Маска подсети 255.255.255.0 (/24).
	```
