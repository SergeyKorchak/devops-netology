## Задача 1

В этом задании вы потренируетесь в:

- установке Elasticsearch,
- первоначальном конфигурировании Elasticsearch,
- запуске Elasticsearch в Docker.

Используя Docker-образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для Elasticsearch,
- соберите Docker-образ и сделайте `push` в ваш docker.io-репозиторий,
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины.

Требования к `elasticsearch.yml`:

- данные `path` должны сохраняться в `/var/lib`,
- имя ноды должно быть `netology_test`.

В ответе приведите:

- текст Dockerfile-манифеста,
- ссылку на образ в репозитории dockerhub,
- ответ `Elasticsearch` на запрос пути `/` в json-виде.

```
Прошу подсказать, что может быть некорректно в dockerfile. Контейнер удалось поднять только один раз. Остальное время устанавливается статус "exited".

- текст Dockerfile-манифеста:
FROM centos:7
RUN yum -y install wget sudo perl-Digest-SHA && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.7.0-linux-x86_64.tar.gz && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.7.0-linux-x86_64.tar.gz.sha512 && shasum -a 512 -c elasticsearch-8.7.0-linux-x86_64.tar.gz.sha512 && tar -xzf elasticsearch-8.7.0-linux-x86_64.tar.gz
RUN /bin/sh -c 'mkdir /var/lib/elasticsearch && mkdir /var/lib/elasticsearch/logs && mkdir /var/lib/elasticsearch/data && useradd -s /sbin/nologin elastic'
WORKDIR /usr/src/elasticsearch
RUN /bin/sh -c 'rm -f /usr/src/elasticsearch/elasticsearch-8.7.0/config/elasticsearch.yml'
COPY ./elasticsearch.yml /usr/src/elasticsearch/elasticsearch-8.7.0/config
RUN /bin/sh -c 'chown -R elastic /usr/src/elasticsearch/elasticsearch-8.7.0 && chown -R elastic /var/lib/elasticsearch'
EXPOSE 9200 9300
ENTRYPOINT sudo -u elastic /usr/src/elasticsearch/elasticsearch-8.7.0/bin/elasticsearch

- ссылку на образ в репозитории dockerhub:
https://hub.docker.com/repository/docker/sergeykorchak/repo/general

- ответ `Elasticsearch` на запрос пути `/` в json-виде:
sergey@pc:~$ sudo docker run --rm -d --name elasticsearch -p 9200:9200 -p 9300:9300 sergeykorchak/repo:elasticsearch
0491dabdf16fac23afe5315754559a62f75b43318e953dce2559005eb4c0f6f4
sergey@pc:~$ sudo docker ps -a
CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS         PORTS                                                                                  NAMES
0491dabdf16f   sergeykorchak/repo:elasticsearch   "/bin/sh -c 'sudo -u…"   7 seconds ago   Up 2 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elasticsearch

sergey@pc:~$ sudo docker ps -all
CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS                     PORTS     NAMES
8b12a89723e5   sergeykorchak/repo:elasticsearch   "/bin/sh -c 'sudo -u…"   5 minutes ago   Exited (1) 5 minutes ago             elasticsearch
```

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы,
- изучать состояние кластера,
- обосновывать причину деградации доступности данных.

Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `Elasticsearch` 3 индекса в соответствии с таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API, и **приведите в ответе** на задание.

Получите состояние кластера `Elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

Удалите все индексы.

```
-----
```

## Задача 3

Создайте директорию `{путь до корневой директории с Elasticsearch в образе}/snapshots`.

Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
эту директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `Elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `Elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```
-----
```
