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
- текст Dockerfile-манифеста:
FROM centos:7
ENV PATH=/usr/lib:/elasticsearch-8.7.0/jdk/bin:/elasticsearch-8.7.0/bin:$PATH
RUN yum -y install wget sudo perl-Digest-SHA && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.7.0-linux-x86_64.tar.gz && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.7.0-linux-x86_64.tar.gz.sha512 && shasum -a 512 -c elasticsearch-8.7.0-linux-x86_64.tar.gz.sha512 && tar -xzf elasticsearch-8.7.0-linux-x86_64.tar.gz && rm elasticsearch-8.7.0-linux-x86_64.tar.gz && rm elasticsearch-8.7.0-linux-x86_64.tar.gz.sha512
ENV ES_HOME=/elasticsearch-8.7.0
RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000
RUN mkdir /var/lib/elasticsearch
WORKDIR /var/lib/elasticsearch
RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done
RUN mkdir /elasticsearch-8.7.0/snapshots && chown -R elasticsearch:elasticsearch /elasticsearch-8.7.0
COPY logging.yml /elasticsearch-8.7.0/config/
COPY elasticsearch.yml /elasticsearch-8.7.0/config/
USER elasticsearch
CMD ["elasticsearch"]
EXPOSE 9200 9300

- ссылку на образ в репозитории dockerhub:
https://hub.docker.com/repository/docker/sergeykorchak/elasticsearch/general

- ответ `Elasticsearch` на запрос пути `/` в json-виде:
{
  "name" : "netology_test",
  "cluster_name" : "netology",
  "cluster_uuid" : "7NxDIZGYQIO45v8TPx1OWg",
  "version" : {
    "number" : "8.7.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "09520b59b6bc1057340b55750186466ea715e30e",
    "build_date" : "2023-03-27T16:31:09.816451435Z",
    "build_snapshot" : false,
    "lucene_version" : "9.5.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
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
sergey@pc:~$ sudo curl http://127.0.0.1:9200/_cat/indices
green  open ind-1 mj7GA2KPS0CD-ZtzCcgOwg 1 0 0 0 225b 225b
yellow open ind-3 -4TuRoOySUG1p-u6zJb9JQ 4 2 0 0 900b 900b
yellow open ind-2 hff62P3tRkmGOI1rT7-Lwg 2 1 0 0 450b 450b

sergey@pc:~$ sudo curl http://127.0.0.1:9200/_cluster/health
{"cluster_name":"netology","status":"yellow","timed_out":false,"number_of_nodes":1,"number_of_data_nodes":1,"active_primary_shards":7,"active_shards":7,"relocating_shards":0,"initializing_shards":0,"unassigned_shards":10,"delayed_unassigned_shards":0,"number_of_pending_tasks":0,"number_of_in_flight_fetch":0,"task_max_waiting_in_queue_millis":0,"active_shards_percent_as_number":41.17647058823529}

sergey@pc:~$ sudo curl -X DELETE http://127.0.0.1:9200/ind-1
{"acknowledged":true}

sergey@pc:~$ sudo curl -X DELETE http://127.0.0.1:9200/ind-2
{"acknowledged":true}

sergey@pc:~$ sudo curl -X DELETE http://127.0.0.1:9200/ind-3
{"acknowledged":true}
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
sergey@pc:~$ sudo curl -X PUT "http://127.0.0.1:9200/_snapshot/netology_backup/my_snapshot?pretty
{
  "acknowledged" : true
}

sergey@pc:~$ sudo curl http://127.0.0.1:9200/_cat/indices
green open test qvKtYuavSkih0g7qvERYpQ 1 0 0 0 225b 225b

[elasticsearch@0f4d33bc550e snapshots]$ ll
total 36
-rw-r--r-- 1 elasticsearch elasticsearch   587 May  1 07:04 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 May  1 07:04 index.latest
drwxr-xr-x 3 elasticsearch elasticsearch  4096 May  1 07:04 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18793 May  1 07:04 meta-2yi_NtfuSG6ZhmjCNjhCnw.dat
-rw-r--r-- 1 elasticsearch elasticsearch   303 May  1 07:04 snap-2yi_NtfuSG6ZhmjCNjhCnw.dat

sergey@pc:~$ sudo curl http://127.0.0.1:9200/_cat/indices
green open test-2 bs5C5iE3Re2Igt_TtMFcrA 1 0 0 0 225b 225b

sergey@pc:~$ sudo curl -X POST http://127.0.0.1:9200/_snapshot/netology_backup/my_snapshot/_restore?pretty -H 'Content-Type: application/json' -d' {"include_global_state":true}'
{
  "accepted" : true
}

sergey@pc:~$ sudo curl http://127.0.0.1:9200/_cat/indices
green open test-2 bs5C5iE3Re2Igt_TtMFcrA 1 0 0 0 225b 225b
green open test   oBDKcm3ZQ3ipq0sOp9Xzcw 1 0 0 0 225b 225b
```
