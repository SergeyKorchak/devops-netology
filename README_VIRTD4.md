## Задача 1

Создайте собственный образ любой операционной системы (например ubuntu-20.04) с помощью Packer ([инструкция]).

Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud.

```
https://github.com/SergeyKorchak/devops-netology/blob/main/VIRTD4_1.png
```

## Задача 2

**2.1.** Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud.        

**2.2.*** **(Необязательное задание)**      
Создайте вашу первую виртуальную машину в YandexCloud с помощью Terraform (вместо использования веб-интерфейса YandexCloud).
Используйте Terraform-код в директории ([src/terraform]).

Чтобы получить зачёт, вам нужно предоставить вывод команды terraform apply и страницы свойств, созданной ВМ из личного кабинета YandexCloud.

```
https://github.com/SergeyKorchak/devops-netology/blob/main/VIRTD4_2.png
```

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
