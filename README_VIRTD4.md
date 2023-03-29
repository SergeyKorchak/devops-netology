## Задача 1

Создайте собственный образ любой операционной системы (например ubuntu-20.04) с помощью Packer ([инструкция]).

Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud.

![VIRTD4_1](https://user-images.githubusercontent.com/119151349/227656689-2d46ab2f-5b28-439f-bd3f-25c681529b81.png)

## Задача 2

**2.1.** Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud.        

**2.2.*** **(Необязательное задание)**      
Создайте вашу первую виртуальную машину в YandexCloud с помощью Terraform (вместо использования веб-интерфейса YandexCloud).
Используйте Terraform-код в директории ([src/terraform]).

Чтобы получить зачёт, вам нужно предоставить вывод команды terraform apply и страницы свойств, созданной ВМ из личного кабинета YandexCloud.

![VIRTD4_2](https://user-images.githubusercontent.com/119151349/227656722-cf9ec14b-7538-429a-bd7b-70d5a7816aa5.png)

## Задача 3

С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana.
Используйте Ansible-код в директории ([src/ansible]).

Чтобы получить зачёт, вам нужно предоставить вывод команды "docker ps" , все контейнеры, описанные в [docker-compose]),  должны быть в статусе "Up".

```
CONTAINER ID   IMAGE                              COMMAND                  CREATED              STATUS                          PORTS      NAMES
5665b55c9eec   grafana/grafana:7.4.2              "/run.sh"                About a minute ago   Up 46 seconds                   3000/tcp   grafana
64d68568a22c   prom/pushgateway:v1.2.0            "/bin/pushgateway"       About a minute ago   Up 47 seconds                   9091/tcp   pushgateway
be62a686d4ef   gcr.io/cadvisor/cadvisor:v0.47.0   "/usr/bin/cadvisor -…"   About a minute ago   Up 46 seconds (healthy)         8080/tcp   cadvisor
2a4730dbb1fa   prom/node-exporter:v0.18.1         "/bin/node_exporter …"   About a minute ago   Up 46 seconds                   9100/tcp   nodeexporter
8e99d165ac4e   prom/alertmanager:v0.20.0          "/bin/alertmanager -…"   About a minute ago   Up 47 seconds                   9093/tcp   alertmanager
bbe514c0496f   prom/prometheus:v2.17.1            "/bin/prometheus --c…"   About a minute ago   Up 46 seconds                   9090/tcp   prometheus
71b6d48c2409   stefanprodan/caddy                 "/sbin/tini -- caddy…"   About a minute ago   Restarting (2) 17 seconds ago              caddy  

sergeykorchak@vm-yc:~$ sudo ansible-playbook provision.yml -i inventory

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
fatal: [node01.netology.cloud]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: centos@158.160.47.125: Permission denied (publickey).", "unreachable": true}

PLAY RECAP *********************************************************************
node01.netology.cloud      : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0   

sergeykorchak@test:~/ansible/stack$ sudo docker ps
CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS                          PORTS      NAMES
26a976ebb918   prom/node-exporter:v0.18.1         "/bin/node_exporter …"   3 minutes ago   Up 3 minutes                    9100/tcp   nodeexporter
7b86dcf1f34b   gcr.io/cadvisor/cadvisor:v0.47.0   "/usr/bin/cadvisor -…"   3 minutes ago   Up 3 minutes (healthy)          8080/tcp   cadvisor
35dd9396bf9a   prom/alertmanager:v0.20.0          "/bin/alertmanager -…"   3 minutes ago   Up 3 minutes                    9093/tcp   alertmanager
e7199e551f3e   grafana/grafana:7.4.2              "/run.sh"                3 minutes ago   Up 3 minutes                    3000/tcp   grafana
1448b8c82214   prom/prometheus:v2.17.1            "/bin/prometheus --c…"   3 minutes ago   Up 3 minutes                    9090/tcp   prometheus
03a8b104ea19   prom/pushgateway:v1.2.0            "/bin/pushgateway"       3 minutes ago   Up 3 minutes                    9091/tcp   pushgateway
31e86f6664ee   stefanprodan/caddy                 "/sbin/tini -- caddy…"   3 minutes ago   Restarting (2) 44 seconds ago              caddy
sergeykorchak@test:~/ansible/stack$ sudo docker-compose logs caddy
caddy  | panic: runtime error: slice bounds out of range
caddy  | 
caddy  | goroutine 1 [running]:
caddy  | github.com/mholt/caddy/vendor/github.com/miekg/dns.ClientConfigFromFile(0xbb4739, 0x10, 0x0, 0x0, 0x0)
caddy  | 	src/github.com/mholt/caddy/vendor/github.com/miekg/dns/clientconfig.go:86 +0xad6
caddy  | github.com/mholt/caddy/vendor/github.com/xenolf/lego/acme.getNameservers(0xbb4739, 0x10, 0xfeaf20, 0x2, 0x2, 0xf77460, 0xc4200402c0, 0xc420037f50)
caddy  | 	src/github.com/mholt/caddy/vendor/github.com/xenolf/lego/acme/dns_challenge.go:40 +0x4d
caddy  | github.com/mholt/caddy/vendor/github.com/xenolf/lego/acme.init()
caddy  | 	src/github.com/mholt/caddy/vendor/github.com/xenolf/lego/acme/dns_challenge.go:33 +0x12d
caddy  | github.com/mholt/caddy/caddy/caddymain.init()
caddy  | 	<autogenerated>:1 +0x75
caddy  | main.init()
caddy  | 	<autogenerated>:1 +0x44
caddy  | panic: runtime error: slice bounds out of range
caddy  | 
```

## Задача 4

1. Откройте веб-браузер, зайдите на страницу http://<внешний_ip_адрес_вашей_ВМ>:3000.
2. Используйте для авторизации логин и пароль из [.env-file].
3. Изучите доступный интерфейс, найдите в интерфейсе автоматически созданные docker-compose-панели с графиками([dashboards]).
4. Подождите 5-10 минут, чтобы система мониторинга успела накопить данные.

Чтобы получить зачёт, предоставьте: 

- скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже.
<p align="center">
  <img width="1200" height="600" src="./assets/yc_02.png">
</p>

```
Пока страница недоступна.
```
