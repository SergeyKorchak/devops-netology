## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,
- подключения к БД,
- вывода списка таблиц,
- вывода описания содержимого таблиц,
- выхода из psql.

```
postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres-# \c postgres
You are now connected to database "postgres" as user "postgres".

postgres-# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner   
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 ...
 pg_catalog | pg_user_mapping         | table | postgres
(62 rows)

postgres-# \dS+ pg_aggregate
                                   Table "pg_catalog.pg_aggregate"
      Column      |   Type   | Collation | Nullable | Default | Storage  | Stats target | Description 
------------------+----------+-----------+----------+---------+----------+--------------+-------------
 aggfnoid         | regproc  |           | not null |         | plain    |              | 
 ...
 aggminitval      | text     | C         |          |         | extended |              | 
Indexes:
    "pg_aggregate_fnoid_index" UNIQUE, btree (aggfnoid)
Access method: heap

postgres-# \q
root@4bf3c5067b1a:/# 
```

## Задача 2

Используя `psql`, создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.

```
test_database=# select * from pg_stats where tablename = 'orders';
 schemaname | tablename | attname | inherited | null_frac | avg_width | n_distinct | most_common_vals | most_common_freqs |                                                     
            histogram_bounds                                                                  | correlation | most_common_elems | most_common_elem_freqs | elem_count_histogram 
------------+-----------+---------+-----------+-----------+-----------+------------+------------------+-------------------+-----------------------------------------------------
----------------------------------------------------------------------------------------------+-------------+-------------------+------------------------+----------------------
 public     | orders    | id      | f         |         0 |         4 |         -1 |                  |                   | {1,2,3,4,5,6,7,8}                                   
                                                                                              |           1 |                   |                        | 
 public     | orders    | title   | f         |         0 |        16 |         -1 |                  |                   | {"Adventure psql time",Dbiezdmin,"Log gossips","Me a
nd my bash-pet","My little database","Server gravity falls","WAL never lies","War and peace"} |  -0.3809524 |                   |                        | 
 public     | orders    | price   | f         |         0 |         4 |     -0.875 | {300}            | {0.25}            | {100,123,499,500,501,900}                           
                                                                                              |   0.5952381 |                   |                        | 
(3 rows)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

```
test_database=# create table orders_1 (like orders);
CREATE TABLE
test_database=# create table orders_2 (like orders);
CREATE TABLE
test_database=# insert into orders_1 select * from orders where price > 499;
INSERT 0 3
test_database=# insert into orders_2 select * from orders where price <= 499;
INSERT 0 5

Можно исключить ручное разбиение при проектировании (восстановлении из бэкапа) таблицы orders.

test_database=# CREATE TABLE public.orders_new (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
) partition by range (price);
CREATE TABLE

test_database=# create table orders_1_new partition of orders_new for values from (500) to (maxvalue);
CREATE TABLE
test_database=# create table orders_2_new partition of orders_new for values from (minvalue) to (500);
CREATE TABLE

test_database=# \dtS+
 ...
 public     | orders_1_new            | table             | postgres | permanent   | 0 bytes    | 
 public     | orders_2_new            | table             | postgres | permanent   | 0 bytes    | 
 public     | orders_new              | partitioned table | postgres | permanent   | 0 bytes    | 
 ...
```

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```
root@4bf3c5067b1a:/# pg_dump -U postgres -d test_database > test_database_dump.sql

test_database=# create index idx_title on orders(title);
CREATE INDEX
```
