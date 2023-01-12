1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter.

	```	
	[Unit]
	Description=Node Exporter
	
	[Service]
	User=node_exporter
	Group=node_exporter
	ExecStart=/usr/local/bin/node_exporter $OPTIONS
	
	[Install]
	WantedBy=multi-user.target

	node_exporter.service - Node Exporter
	     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor>
	     Active: active (running) since Wed 2023-01-11 17:06:34 MSK; 53s ago
	   Main PID: 2880 (node_exporter)
	      Tasks: 5 (limit: 4485)
	     Memory: 13.4M
	        CPU: 48ms
	     CGroup: /system.slice/node_exporter.service
           	  └─2880 /usr/local/bin/node_exporter
	
	sergey@pc:~$ ps -e |grep node_exporter
	    825 ?        00:00:00 node_exporter
	
	Выполнено добавление в автозапуск, проверка запуска, завершения, автозапуска после перезагрузки.
	
	Дополнительные опции запуска службы можно передать в файле .service в ExecStart через переменную. Задать в значение переменной необходимые опции. Или задать опции в ExecStart напрямую.
	```

2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

	``````
	Несколько примеров:
	
	# TYPE node_cpu_seconds_total counter
	node_cpu_seconds_total{cpu="0",mode="idle"} 750
	node_cpu_seconds_total{cpu="0",mode="iowait"} 91.05
	node_cpu_seconds_total{cpu="0",mode="irq"} 0
	node_cpu_seconds_total{cpu="0",mode="nice"} 1.32
	node_cpu_seconds_total{cpu="0",mode="softirq"} 0.69
	node_cpu_seconds_total{cpu="0",mode="steal"} 0
	node_cpu_seconds_total{cpu="0",mode="system"} 35.32
	node_cpu_seconds_total{cpu="0",mode="user"} 81.93
	
	# TYPE node_memory_Active_anon_bytes gauge
	node_memory_Active_anon_bytes 3.44064e+06
	# TYPE node_memory_Active_bytes gauge
	node_memory_Active_bytes 4.332544e+08
	
	# TYPE node_disk_reads_completed_total counter
	node_disk_reads_completed_total{device="sda"} 20821
	node_disk_reads_completed_total{device="sdb"} 2
	node_disk_reads_completed_total{device="sr0"} 10
	
	# TYPE node_network_protocol_type gauge
	node_network_protocol_type{device="enp3s0"} 1
	node_network_protocol_type{device="lo"} 772
	node_network_protocol_type{device="wlp2s0"} 1
	# TYPE node_network_receive_bytes_total counter
	node_network_receive_bytes_total{device="enp3s0"} 0
	node_network_receive_bytes_total{device="lo"} 31697
	node_network_receive_bytes_total{device="wlp2s0"} 6.572226e+06
	``````

3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки. После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

	```
	На localhost:19999 зайти удалось.
	В верхней части отображается информация по used swap, disk read, disk write, cpu, net inbound, net outbound, user ram.	
	```

4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

	```
	vagrant@vagrant:~$ sudo dmesg | grep "Hypervisor detected"
	[    0.000000] Hypervisor detected: KVM
	
	Для виртуальной машины появится сообщение выше. Для обычной сообщения не будет.
	```

5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

	```
	Системное ограничение на количество открытых дескрипторов.
	sergey@pc:~$ sysctl -n fs.nr_open
	1048576
	
	Максимальное количество открытых файловых дескрипторов.
	vagrant@vagrant:~$ ulimit -n
	1024
	```

6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter.

	```
	Пока не выполнено.

	sergey@pc:~$ sudo -i
	root@pc:~# sleep 1h
	```

7. Найдите информацию о том, что такое :(){ :|:& };:. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

	```
	При запуске данной команды происходит зависание и перезагрузка.
	```
