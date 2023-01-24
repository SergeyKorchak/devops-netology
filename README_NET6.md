1. Работа c HTTP через телнет. Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80. Отправьте HTTP запрос. В ответе укажите полученный HTTP код, что он означает.

	```
	В ответ получил код 403 - стандартный код ответа HTTP, означающий, что доступ к запрошенному ресурсу запрещен.
	
	sergey@pc:~$ telnet stackoverflow.com 80
	Trying 151.101.1.69...
	Connected to stackoverflow.com.
	Escape character is '^]'.
	GET /questions HTTP/1.0
	HOST: stackoverflow.com
	
	HTTP/1.1 403 Forbidden
	Connection: close
	Content-Length: 1923
	Server: Varnish
	Retry-After: 0
	Content-Type: text/html
	Accept-Ranges: bytes
	Date: Mon, 23 Jan 2023 12:03:04 GMT
	Via: 1.1 varnish
	X-Served-By: cache-sof1510059-SOF
	X-Cache: MISS
	X-Cache-Hits: 0
	X-Timer: S1674475385.805787,VS0,VE1
	X-DNS-Prefetch-Control: off
	
	<!DOCTYPE html>
	<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <title>Forbidden - Stack Exchange</title>
	    <style type="text/css">
			body
			{
				color: #333;
				font-family: 'Helvetica Neue', Arial, sans-serif;
				font-size: 14px;
				background: #fff url('img/bg-noise.png') repeat left top;
				line-height: 1.4;
			}
			h1
			{
				font-size: 170%;
				line-height: 34px;
				font-weight: normal;
			}
			a { color: #366fb3; }
			a:visited { color: #12457c; }
			.wrapper {
				width:960px;
				margin: 100px auto;
				text-align:left;
			}
			.msg {
				float: left;
				width: 700px;
				padding-top: 18px;
				margin-left: 18px;
			}
	    </style>
	</head>
	<body>
	    <div class="wrapper">
			<div style="float: left;">
				<img src="https://cdn.sstatic.net/stackexchange/img/apple-touch-icon.png" alt="Stack Exchange" />
			</div>
			<div class="msg">
				<h1>Access Denied</h1>
	                        <p>This IP address (212.58.119.253) has been blocked from access to our services. If you believe this to be in error, please contact us at <a href="mailto:team@stackexchange.com?Subject=Blocked%20212.58.119.253%20(Request%20ID%3A%202518500375-SOF)">team@stackexchange.com</a>.</p>
	                        <p>When contacting us, please include the following information in the email:</p>
	                        <p>Method: block</p>
	                        <p>XID: 2518500375-SOF</p>
	                        <p>IP: 212.58.119.253</p>
	                        <p>X-Forwarded-For: </p>
	                        <p>User-Agent: </p>
	                        
	                        <p>Time: Mon, 23 Jan 2023 12:03:04 GMT</p>
	                        <p>URL: stackoverflow.com/questions</p>
	                        <p>Browser Location: <span id="jslocation">(not loaded)</span></p>
			</div>
		</div>
		<script>document.getElementById('jslocation').innerHTML = window.location.href;</script>
	</body>
	</html>Connection closed by foreign host.

	```

2. Повторите задание 1 в браузере, используя консоль разработчика F12.

	```
	В ответ получили код 307 - запрошенный ресурс был временно перемещён в URL-адрес, указанный в заголовке Location (en-US).
	Страница загрузилась за 6.92 с.
	Дольше всего отрабатывал запрос Request URL: https://stackoverflow.com/ (412 мс).
	Скриншоты из браузера добавлены в файлах Screenshot_2_1.png и Screenshot_2_2.png.
	```

3. Какой IP адрес у вас в интернете?

	```
	sergey@pc:~$ dig @resolver1.opendns.com myip.opendns.com +short
	212.58.119.253
	```

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois.

	```
	sergey@pc:~$ whois 212.58.119.253
	netname:        GE-TELENETADSL
	descr:          Caucasus Online LLC
	origin:         AS16010
	```

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute.

	```
	Через AS16010, AS15924, AS1273, AS15169, AS263411.
	
	sergey@pc:~$ traceroute -A 8.8.8.8
	traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
	 1  _gateway (192.168.100.1) [*]  60.605 ms  71.969 ms  72.550 ms
	 2  100.68.64.1 (100.68.64.1) [*]  80.850 ms  81.731 ms  82.839 ms
	 3  100.127.255.34 (100.127.255.34) [*]  76.616 ms  77.750 ms  80.113 ms
	 4  host-213-157-192-157.customer.magticom.ge (213.157.192.157) [AS16010]  73.364 ms  74.192 ms  75.822 ms
	 5  10.9.2.33 (10.9.2.33) [*]  87.441 ms  88.889 ms  89.624 ms
	 6  10.9.100.45 (10.9.100.45) [*]  88.110 ms  54.204 ms  34.595 ms
	 7  212.15.2.177 (212.15.2.177) [AS15924]  61.001 ms  61.650 ms  62.248 ms
	 8  31.206.37.69 (31.206.37.69) [AS15924]  63.317 ms  64.132 ms  65.014 ms
	 9  10.135.56.173 (10.135.56.173) [*]  66.346 ms  67.397 ms  69.039 ms
	10  ae3-17-xcr1.ise.cw.net (195.2.26.253) [AS1273]  76.086 ms  76.638 ms  77.235 ms
	11  ae29-xcr1.sof.cw.net (195.2.18.210) [AS1273]  78.273 ms  78.833 ms  80.014 ms
	12  72.14.217.24 (72.14.217.24) [AS15169]  78.919 ms 72.14.208.246 (72.14.208.246) [AS15169]  75.442 ms 72.14.218.54 (72.14.218.54) [AS15169]  70.109 ms
	13  142.251.92.1 (142.251.92.1) [AS15169]  70.687 ms 142.251.92.65 (142.251.92.65) [AS15169]  69.357 ms *
	14  dns.google (8.8.8.8) [AS15169/AS263411]  63.944 ms  63.127 ms  64.483 ms
	```
	
6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?

	```
	Наибольшая задержка на 10.
	
	sergey@pc:~$ mtr 8.8.8.8 -r
	Start: 2023-01-23T18:04:03+0300
	HOST: pc                          Loss%   Snt   Last   Avg  Best  Wrst StDev
	  1.|-- _gateway                   0.0%    10    1.5   4.3   1.4  21.1   6.1
	  2.|-- 100.68.64.1                0.0%    10    4.0   4.0   3.5   5.9   0.7
	  3.|-- 100.127.255.34             0.0%    10    5.0   4.5   3.7   6.2   0.7
	  4.|-- host-213-157-192-157.cust  0.0%    10    4.8   5.4   3.2  10.8   2.6
	  5.|-- 10.9.2.33                  0.0%    10   10.0  10.5   8.2  25.2   5.2
	  6.|-- 10.9.100.45                0.0%    10    9.0  11.9   8.3  35.2   8.3
	  7.|-- 212.15.2.177               0.0%    10   47.3  59.4  46.3 145.9  30.8
	  8.|-- 31.206.37.69               0.0%    10   55.8  61.7  55.8 104.5  15.1
	  9.|-- 10.135.56.173              0.0%    10   61.9  59.9  55.6  89.1  10.4
	 10.|-- ae3-17-xcr1.ise.cw.net     0.0%    10   85.5  77.1  56.1 145.6  27.8
	 11.|-- ae29-xcr1.sof.cw.net       0.0%    10   64.5  70.1  63.4 114.3  15.7
	 12.|-- google-gw.sof.cw.net       0.0%    10   64.8  69.5  63.3 108.6  14.0
	 13.|-- 108.170.250.177            0.0%    10   67.0  68.5  66.6  77.2   3.5
	 14.|-- 142.251.52.87              0.0%    10   66.0  80.7  65.9 204.8  43.6
	 15.|-- dns.google                 0.0%    10   61.4  68.6  61.0 132.9  22.6

	```

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? Воспользуйтесь утилитой dig

	```
	sergey@pc:~$ dig dns.google

	; <<>> DiG 9.18.1-1ubuntu1.2-Ubuntu <<>> dns.google
	;; global options: +cmd
	;; Got answer:
	;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42646
	;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
	
	;; OPT PSEUDOSECTION:
	; EDNS: version: 0, flags:; udp: 65494
	;; QUESTION SECTION:
	;dns.google.			IN	A
	
	;; ANSWER SECTION:
	dns.google.		539	IN	A	8.8.4.4
	dns.google.		539	IN	A	8.8.8.8
	
	;; Query time: 64 msec
	;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
	;; WHEN: Mon Jan 23 18:10:08 MSK 2023
	;; MSG SIZE  rcvd: 71
	```

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? Воспользуйтесь утилитой dig.

	```
	Используется PTR dns.google.
	
	sergey@pc:~$ dig -x 8.8.8.8
	
	; <<>> DiG 9.18.1-1ubuntu1.2-Ubuntu <<>> -x 8.8.8.8
	;; global options: +cmd
	;; Got answer:
	;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 8585
	;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
	
	;; OPT PSEUDOSECTION:
	; EDNS: version: 0, flags:; udp: 65494
	;; QUESTION SECTION:
	;8.8.8.8.in-addr.arpa.		IN	PTR
	
	;; ANSWER SECTION:
	8.8.8.8.in-addr.arpa.	5936	IN	PTR	dns.google.
	
	;; Query time: 0 msec
	;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
	;; WHEN: Mon Jan 23 18:23:35 MSK 2023
	;; MSG SIZE  rcvd: 73
	
	sergey@pc:~$ dig -x 8.8.4.4
	
	; <<>> DiG 9.18.1-1ubuntu1.2-Ubuntu <<>> -x 8.8.4.4
	;; global options: +cmd
	;; Got answer:
	;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54249
	;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
	
	;; OPT PSEUDOSECTION:
	; EDNS: version: 0, flags:; udp: 65494
	;; QUESTION SECTION:
	;4.4.8.8.in-addr.arpa.		IN	PTR
	
	;; ANSWER SECTION:
	4.4.8.8.in-addr.arpa.	7128	IN	PTR	dns.google.
	
	;; Query time: 3 msec
	;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
	;; WHEN: Mon Jan 23 18:23:56 MSK 2023
	;; MSG SIZE  rcvd: 73
	```
