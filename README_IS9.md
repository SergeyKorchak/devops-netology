1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
	
	```
	Выполнено
	```

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

	```
	Выполнено
	```

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

	```
	sergey@pc:~$ sudo apt install apache2
	sergey@pc:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
	sergey@pc:/$ sudo vim /etc/apache2/sites-available/your_domain_or_ip.conf
	sergey@pc:/$ sudo a2ensite your_domain_or_ip.conf
	sergey@pc:/$ sudo apache2ctl configtest
	sergey@pc:/$ sudo systemctl reload apache2
	sergey@pc:/$ sudo systemctl start apache2	
	sergey@pc:/$ journalctl -xeu apache2.service
	Starting The Apache HTTP Server...
	Subject: A start job for unit apache2.service has begun execution
	Defined-By: systemd
	Support: http://www.ubuntu.com/support
	A start job for unit apache2.service has begun execution.
	The job identifier is 4852.
	Started The Apache HTTP Server.
	Subject: A start job for unit apache2.service has finished successfully
	Defined-By: systemd
	Support: http://www.ubuntu.com/support
	A start job for unit apache2.service has finished successfully.
	The job identifier is 4852.
	```

4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).

	```
	sergey@pc:~/testssl.sh$ ./testssl.sh -U --sneaky https://ya.ru
	 Testing vulnerabilities 
	 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
	 CCS (CVE-2014-0224)                       not vulnerable (OK)
	 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
	 ROBOT                                     not vulnerable (OK)
	 Secure Renegotiation (RFC 5746)           supported (OK)
	 Secure Client-Initiated Renegotiation     not vulnerable (OK)
	 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
	 BREACH (CVE-2013-3587)                    potentially NOT ok, "br" HTTP compression detected. - only supplied "/" tested
	                                           Can be ignored for static pages or if no secrets in the page
	 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
	 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
	 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
	 FREAK (CVE-2015-0204)                     not vulnerable (OK)
	 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
	                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services, see
	                                           https://search.censys.io/search?	resource=hosts&virtual_hosts=INCLUDE&q=68C56160382AD96C62E4392A124209B291A40846890AB7832E23101BCA739A85
	 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
	 BEAST (CVE-2011-3389)                     TLS1: ECDHE-ECDSA-AES128-SHA
                                                 ECDHE-RSA-AES128-SHA 
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
	 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
	 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
	 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)
	```

5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.

	```
	sergey@pc:/$ sudo apt install openssh-server
	sergey@pc:/$ sudo systemctl start sshd.service
	sergey@pc:/$ sudo systemctl enable sshd.service
	sergey@pc:/$ ssh-keygen
	Generating public/private rsa key pair.
	Enter file in which to save the key (/home/sergey/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /home/sergey/.ssh/id_rsa
	Your public key has been saved in /home/sergey/.ssh/id_rsa.pub
	The key fingerprint is:
	...
	The key's randomart image is:
	...
	sergey@pc:~$ ssh-copy-id -i .ssh/id_rsa vagrant@192.168.56.3
	sergey@pc:~$ ssh vagrant@192.168.56.3
	Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)
	  System information as of Thu 02 Feb 2023 12:26:25 PM UTC
	  System load:  0.0                Processes:             126
	  Usage of /:   12.1% of 30.34GB   Users logged in:       1
	  Memory usage: 12%                IPv4 address for eth0: 10.0.2.15
	  Swap usage:   0%                 IPv4 address for eth1: 192.168.56.3
	This system is built by the Bento project by Chef Software
	More information can be found at https://github.com/chef/bento
	Last login: Thu Feb  2 12:06:31 2023 from 10.0.2.2
	vagrant@sysadm-fs:~$ 
	```

6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

	```
	vagrant@sysadm-fs:~$ systemctl status sshd.service
	● ssh.service - OpenBSD Secure Shell server
     	Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: e>
     	Active: active (running)
	vagrant@sysadm-fs:~$ ssh-keygen
	Generating public/private rsa key pair.
	Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /home/vagrant/.ssh/id_rsa
	Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
	The key fingerprint is:
	...
	The key's randomart image is:
	...
	
	vagrant@sysadm-fs:/$ ssh-copy-id sergey@192.168.100.77
	/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
	The authenticity of host '192.168.100.77 (192.168.100.77)' can't be established.
	ECDSA key fingerprint is SHA256:...
	Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
	/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
	/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
	sergey@192.168.100.77's password: 
	Number of key(s) added: 1
	Now try logging into the machine, with:   "ssh 'sergey@192.168.100.77'"
	and check to make sure that only the key(s) you wanted were added.
	
	sergey@pc:~$ cat ~/.ssh/config
	Host test
	HostName 192.168.56.1
	User vagrant
	IdentityFile ~/.ssh/id_rsa
	sergey@pc:~$ ssh test
	vagrant@192.168.56.1's password:
	```

7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

	```
	sergey@pc:~$ sudo apt install tcpdump
	sergey@pc:~$ sudo tcpdump -c 100 -w dmp.pcap
	tcpdump: listening on wlp2s0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
	100 packets captured
	101 packets received by filter
	0 packets dropped by kernel
	```
