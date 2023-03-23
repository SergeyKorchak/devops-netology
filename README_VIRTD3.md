## Задача 1

Сценарий выполнения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберите любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

Опубликуйте созданный fork в своём репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

```
sergey@pc:~/Docker$ sudo docker build -f /home/sergey/Docker/Dockerfile -t sergeykorchak:repo .
Sending build context to Docker daemon  3.072kB
Step 1/3 : FROM nginx:latest
latest: Pulling from library/nginx
f1f26f570256: Pull complete 
84181e80d10e: Pull complete 
1ff0f94a8007: Pull complete 
d776269cad10: Pull complete 
e9427fcfa864: Pull complete 
d4ceccbfc269: Pull complete 
Digest: sha256:e07e4692ca241f85348e4c25bb61cbedd7fa5633a5fbace43003b88c4cd8cfef
Status: Downloaded newer image for nginx:latest
 ---> ac232364af84
Step 2/3 : RUN rm /etc/nginx/conf.d/default.conf
 ---> Running in e3b28e51a8fb
Removing intermediate container e3b28e51a8fb
 ---> df6f7bc30d5f
Step 3/3 : COPY ./index.html /usr/share/nginx/html/index.html
 ---> d565e01aab23
Successfully built d565e01aab23
Successfully tagged sergeykorchak:repo

sergey@pc:~/Docker$ sudo docker images
REPOSITORY      TAG       IMAGE ID       CREATED          SIZE
sergeykorchak   repo      d565e01aab23   11 minutes ago   142MB

https://hub.docker.com/u/sergeykorchak
```

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
«Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- высоконагруженное монолитное Java веб-приложение;
- Nodejs веб-приложение;
- мобильное приложение c версиями для Android и iOS;
- шина данных на базе Apache Kafka;
- Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana;
- мониторинг-стек на базе Prometheus и Grafana;
- MongoDB как основное хранилище данных для Java-приложения;
- Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry.

```
- высоконагруженное монолитное Java веб-приложение (физическая машина, т.к. высокая нагрузка и монолитность);
- Nodejs веб-приложение (использование Docker-контейнеров, т.к. скорее всего потребуется множественное развертование);
- мобильное приложение c версиями для Android и iOS (виртуальная машина или физическая машина, т.к. есть графический интерфейс);
- шина данных на базе Apache Kafka (подходит как виртуальная машина, так и использование Docker-контейнеров, если потребуется множить, то контейнеры);
- Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana (в сочетании виртуальные машины и использование Docker-контейнеров);
- мониторинг-стек на базе Prometheus и Grafana (виртуальная машина, меньший расход ресурсов);
- MongoDB как основное хранилище данных для Java-приложения (использование Docker-контейнеров, виртуальная машина, физическая машина);
- Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry (использование Docker-контейнеров).
```

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тегом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера.
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера.
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```.
- Добавьте ещё один файл в папку ```/data``` на хостовой машине.
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```
sergey@pc:~$ sudo docker run -v /data:/data --name centos-container -d -t centos
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
525b65842768af25e860be62106c6525110917f8e5c1571c08d29e93a7f406b0

sergey@pc:~$ sudo docker run -v /data:/data --name debian-container -d -t debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
3e440a704568: Pull complete 
Digest: sha256:7b991788987ad860810df60927e1adbaf8e156520177bd4db82409f81dd3b721
Status: Downloaded newer image for debian:latest
9ff02f5f52c39c7487b9f13bf8b415dbe13f0db305a26000d77254c89e801f73

sergey@pc:~$ sudo docker exec centos-container /bin/bash -c "echo test>/data/test.txt"
sergey@pc:~$ sudo touch /data/test2.txt
sergey@pc:~$ sudo docker exec -it debian-container /bin/bash
root@9ff02f5f52c3:/# cd /data
root@9ff02f5f52c3:/data# ls
test.txt  test2.txt

sergey@pc:~$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS         PORTS     NAMES
9ff02f5f52c3   debian    "bash"        27 minutes ago   Up 27 minutes             debian-container
525b65842768   centos    "/bin/bash"   38 minutes ago   Up 38 minutes             centos-container
```
