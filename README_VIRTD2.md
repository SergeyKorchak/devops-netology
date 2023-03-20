## Задача 1

- Опишите основные преимущества применения на практике IaaC-паттернов.
- Какой из принципов IaaC является основополагающим?

```
Преимущества:
- ускорение производства и вывода продукта на рынок
- стабильность среды, устранение дрейфа конфигураций
- более быстрая и эффективная разработка

Принцип идемпотентности — свойство объекта или операции, при повторном выполнении которой мы получаем результат идентичный предыдущему и всем последующим выполнениям.
```

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?

```
Преимущества:
- скорость
- простота
- расширяемость
- применяемость на всех этапах жизненного цикла

Однозначно определить сложно какой метод более надежный pull или push, зависит от типов задач, механизмов безопасности и прочего.
В равной степени есть свои плюсы и минусы.
```

## Задача 3

Установите на личный компьютер:

- [VirtualBox](https://www.virtualbox.org/),
- [Vagrant](https://github.com/netology-code/devops-materials),
- [Terraform](https://github.com/netology-code/devops-materials/blob/master/README.md),
- Ansible.

*Приложите вывод команд установленных версий каждой из программ, оформленный в Markdown.*

```
sergey@pc:~$ vagrant -v
Vagrant 2.2.19

sergey@pc:~$ ansible --version
ansible 2.10.8
config file = None
configured module search path = ['/home/sergey/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
ansible python module location = /usr/lib/python3/dist-packages/ansible
executable location = /usr/bin/ansible
python version = 3.10.6 (main, Nov 14 2022, 16:10:14) [GCC 11.3.0]

vagrant@sysadm-fs:~$ terraform -v
Terraform v1.4.2
on linux_amd64

VirtualBox в графическом режиме версия 6.1.38_Ubuntu r153438
```

## Задача 4 

Воспроизведите практическую часть лекции самостоятельно.

- Создайте виртуальную машину.
- Зайдите внутрь ВМ, убедитесь, что Docker установлен с помощью команды
```
docker ps,
```
Vagrantfile из лекции и код ansible находятся в [папке](https://github.com/netology-code/virt-homeworks/tree/virt-11/05-virt-02-iaac/src).

Примечание. Если Vagrant выдаёт ошибку:
```
URL: ["https://vagrantcloud.com/bento/ubuntu-20.04"]     
Error: The requested URL returned error: 404:
```

выполните следующие действия:

1. Скачайте с [сайта](https://app.vagrantup.com/bento/boxes/ubuntu-20.04) файл-образ "bento/ubuntu-20.04".
2. Добавьте его в список образов Vagrant: "vagrant box add bento/ubuntu-20.04 <путь к файлу>".

```
С установкой докера возникли вопросы. Устанавливается, но при попытке вывести информацию - ошибка, что докера нет.

vagrant@server1:~$ sudo apt install docker
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 wmdocker
The following NEW packages will be installed:
  docker libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 wmdocker
0 upgraded, 7 newly installed, 0 to remove and 0 not upgraded.
Need to get 766 kB of archives.
After this operation, 3298 kB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libxau6 amd64 1:1.0.9-0ubuntu1 [7488 B]
Get:2 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libxdmcp6 amd64 1:1.1.3-0ubuntu1 [10.6 kB]
Get:3 http://us.archive.ubuntu.com/ubuntu focal/main amd64 libxcb1 amd64 1.14-2 [44.7 kB]
Get:4 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libx11-data all 2:1.6.9-2ubuntu1.2 [113 kB]
Get:5 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 libx11-6 amd64 2:1.6.9-2ubuntu1.2 [575 kB]
Get:6 http://us.archive.ubuntu.com/ubuntu focal/universe amd64 wmdocker amd64 1.5-2 [13.0 kB]
Get:7 http://us.archive.ubuntu.com/ubuntu focal/universe amd64 docker all 1.5-2 [1316 B]
Fetched 766 kB in 2s (335 kB/s)
Selecting previously unselected package libxau6:amd64.
(Reading database ... 41188 files and directories currently installed.)
Preparing to unpack .../0-libxau6_1%3a1.0.9-0ubuntu1_amd64.deb ...
Unpacking libxau6:amd64 (1:1.0.9-0ubuntu1) ...
Selecting previously unselected package libxdmcp6:amd64.
Preparing to unpack .../1-libxdmcp6_1%3a1.1.3-0ubuntu1_amd64.deb ...
Unpacking libxdmcp6:amd64 (1:1.1.3-0ubuntu1) ...
Selecting previously unselected package libxcb1:amd64.
Preparing to unpack .../2-libxcb1_1.14-2_amd64.deb ...
Unpacking libxcb1:amd64 (1.14-2) ...
Selecting previously unselected package libx11-data.
Preparing to unpack .../3-libx11-data_2%3a1.6.9-2ubuntu1.2_all.deb ...
Unpacking libx11-data (2:1.6.9-2ubuntu1.2) ...
Selecting previously unselected package libx11-6:amd64.
Preparing to unpack .../4-libx11-6_2%3a1.6.9-2ubuntu1.2_amd64.deb ...
Unpacking libx11-6:amd64 (2:1.6.9-2ubuntu1.2) ...
Selecting previously unselected package wmdocker.
Preparing to unpack .../5-wmdocker_1.5-2_amd64.deb ...
Unpacking wmdocker (1.5-2) ...
Selecting previously unselected package docker.
Preparing to unpack .../6-docker_1.5-2_all.deb ...
Unpacking docker (1.5-2) ...
Setting up libxau6:amd64 (1:1.0.9-0ubuntu1) ...
Setting up libxdmcp6:amd64 (1:1.1.3-0ubuntu1) ...
Setting up libxcb1:amd64 (1.14-2) ...
Setting up libx11-data (2:1.6.9-2ubuntu1.2) ...
Setting up libx11-6:amd64 (2:1.6.9-2ubuntu1.2) ...
Setting up wmdocker (1.5-2) ...
Setting up docker (1.5-2) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.9) ...
vagrant@server1:~$ docker ps
-bash: docker: command not found
```
