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
[user@node01 ~]$ docker ps
CONTAINER ID   IMAGE                              COMMAND                  CREATED          STATUS                    PORTS                                                                              NAMES
cf821f9f5e99   prom/pushgateway:v1.2.0            "/bin/pushgateway"       44 minutes ago   Up 44 minutes             9091/tcp                                                                           pushgateway
cf6500209077   prom/alertmanager:v0.20.0          "/bin/alertmanager -…"   44 minutes ago   Up 44 minutes             9093/tcp                                                                           alertmanager
70c707c5b313   grafana/grafana:7.4.2              "/run.sh"                44 minutes ago   Up 44 minutes             3000/tcp                                                                           grafana
504a79a0eb86   prom/prometheus:v2.17.1            "/bin/prometheus --c…"   44 minutes ago   Up 44 minutes             9090/tcp                                                                           prometheus
788db159ec1f   prom/node-exporter:v0.18.1         "/bin/node_exporter …"   44 minutes ago   Up 44 minutes             9100/tcp                                                                           nodeexporter
d4210bb1ccda   stefanprodan/caddy                 "/sbin/tini -- caddy…"   44 minutes ago   Up 44 minutes             0.0.0.0:3000->3000/tcp, 0.0.0.0:9090-9091->9090-9091/tcp, 0.0.0.0:9093->9093/tcp   caddy
36c48e2cd06f   gcr.io/cadvisor/cadvisor:v0.47.0   "/usr/bin/cadvisor -…"   44 minutes ago   Up 44 minutes (healthy)   8080/tcp                                                                           cadvisor
```

## Задача 4

1. Откройте веб-браузер, зайдите на страницу http://<внешний_ip_адрес_вашей_ВМ>:3000.
2. Используйте для авторизации логин и пароль из [.env-file].
3. Изучите доступный интерфейс, найдите в интерфейсе автоматически созданные docker-compose-панели с графиками([dashboards]).
4. Подождите 5-10 минут, чтобы система мониторинга успела накопить данные.

Чтобы получить зачёт, предоставьте:
- скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже.

![VIRTD4_3](https://user-images.githubusercontent.com/119151349/228792696-f7d65cbe-220d-4c47-9f56-a4a402a704ad.png)
