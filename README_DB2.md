## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.

```
sergey@pc:~$ sudo docker run --rm --name postgres -e POSTGRES_USER=test-admin-user -e POSTGRES_PASSWORD=admin -d -p 5432:5432 -v sergey_bd:/home/segrey/bd -v sergey_bd_backup:/home/sergey/bd_backup postgres:12
ab8d00b9b01afe2c8b22214b2b5e3b6d75240b5420dce47f6a894b4c07d5e898
sergey@pc:~$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED              STATUS              PORTS                                       NAMES
ab8d00b9b01a   postgres:12   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres

sergey@pc:~$ sudo docker volume ls
DRIVER    VOLUME NAME
local     3fbd1a3ff72c1caac408e25b6e400f7f4256166fbb56872f65e1abfbf7eaa763
local     4cfbb72af497c988d78f72d449c2ea4e90671b856635d1624d1781f018960925
local     47bbe4ddd432ffd74507537440a643f94a7b3f60f0eec6a437f0e57ffcb4cb4f
local     sergey_bd
local     sergey_bd_backup
```

## Задача 2

В БД из задачи 1: 

- создайте пользователя test-admin-user и БД test_db;
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
- создайте пользователя test-simple-user;
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.

Таблица orders:

- id (serial primary key);
- наименование (string);
- цена (integer).

Таблица clients:

- id (serial primary key);
- фамилия (string);
- страна проживания (string, index);
- заказ (foreign key orders).

Приведите:

- итоговый список БД после выполнения пунктов выше;
- описание таблиц (describe);
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
- список пользователей с правами над таблицами test_db.

```
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | ru_RU.UTF-8 | ru_RU.UTF-8 | 
 template0 | postgres | UTF8     | ru_RU.UTF-8 | ru_RU.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | ru_RU.UTF-8 | ru_RU.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 test_db   | postgres | UTF8     | ru_RU.UTF-8 | ru_RU.UTF-8 | 
(4 rows)

test_db=# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default               
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying |           |          | 
 цена         | integer           |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d clients
                                       Table "public.clients"
      Column       |       Type        | Collation | Nullable |               Default               
-------------------+-------------------+-----------+----------+-------------------------------------
 id                | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying |           |          | 
 страна проживания | character varying |           |          | 
 заказ             | integer           |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "strana" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# select * from information_schema.table_privileges where table_name in ('orders', 'clients');
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | postgres         | test_db       | public       | orders     | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | orders     | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRIGGER        | YES          | NO
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | postgres         | test_db       | public       | clients    | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | clients    | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRIGGER        | YES          | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(36 rows)
```

## Задача 3

Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL-синтаксис:
- вычислите количество записей для каждой таблицы.

Приведите в ответе:

    - запросы,
    - результаты их выполнения.

```
test_db=# insert into orders values (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# select count(*) from orders;
 count 
-------
     5
(1 row)

test_db=# insert into clients values (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# select count(*) from clients;
 count 
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения этих операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.
 
Подсказка: используйте директиву `UPDATE`.

```
test_db=# update clients set "заказ" = 3 where id = 1;
UPDATE 1
test_db=# update clients set "заказ" = 4 where id = 2;
UPDATE 1
test_db=# update clients set "заказ" = 5 where id = 3;
UPDATE 1

test_db=# select * from clients c, orders o where c."заказ" is not null and o.id = c."заказ";
 id |       фамилия        | страна проживания | заказ | id | наименование | цена 
----+----------------------+-------------------+-------+----+--------------+------
  1 | Иванов Иван Иванович | USA               |     3 |  3 | Книга        |  500
  2 | Петров Петр Петрович | Canada            |     4 |  4 | Монитор      | 7000
  3 | Иоганн Себастьян Бах | Japan             |     5 |  5 | Гитара       | 4000
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.

```
test_db=# explain select * from clients c, orders o where c."заказ" is not null and o.id = c."заказ";
                               QUERY PLAN                                
-------------------------------------------------------------------------
 Hash Join  (cost=37.00..57.23 rows=806 width=112)
   Hash Cond: (c."заказ" = o.id)
   ->  Seq Scan on clients c  (cost=0.00..18.10 rows=806 width=72)
         Filter: ("заказ" IS NOT NULL)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=40)
         ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=40)
(6 rows)

cost - затраты на получение первой строки .. всех строк
rows - число записей, обработанных для получения данных
width - размер строки
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

```
sergey@pc:/etc/postgresql/14/main$ sudo pg_dump -d test_db -U postgres > /home/sergey/db_backup/test_db.backup
30338981abc0aa8c970a498dcd07cc69a5f444cbab44393bdabe253b603dbfc8
sergey@pc:~$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
30338981abc0   postgres:12   "docker-entrypoint.s…"   13 seconds ago   Up 10 seconds   5432/tcp                                    test_bd
ab8d00b9b01a   postgres:12   "docker-entrypoint.s…"   43 minutes ago   Up 43 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres
sergey@pc:~$ sudo docker stop postgres
postgres
sergey@pc:~$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS      NAMES
30338981abc0   postgres:12   "docker-entrypoint.s…"   7 minutes ago   Up 7 minutes   5432/tcp   test_bd
sergey@pc:~$ sudo psql -U postgres -d test_db -f /home/sergey/db_backup/test_db.backup
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
psql:/home/sergey/db_backup/test_db.backup:32: ERROR:  relation "clients" already exists
ALTER TABLE
psql:/home/sergey/db_backup/test_db.backup:47: ERROR:  relation "clients_id_seq" already exists
ALTER TABLE
ALTER SEQUENCE
psql:/home/sergey/db_backup/test_db.backup:67: ERROR:  relation "orders" already exists
ALTER TABLE
psql:/home/sergey/db_backup/test_db.backup:82: ERROR:  relation "orders_id_seq" already exists
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
psql:/home/sergey/db_backup/test_db.backup:118: ERROR:  duplicate key value violates unique constraint "clients_pkey"
DETAIL:  Key (id)=(4) already exists.
CONTEXT:  COPY clients, line 1
psql:/home/sergey/db_backup/test_db.backup:131: ERROR:  duplicate key value violates unique constraint "orders_pkey"
DETAIL:  Key (id)=(1) already exists.
CONTEXT:  COPY orders, line 1
 setval 
--------
      1
(1 row)

 setval 
--------
      1
(1 row)

psql:/home/sergey/db_backup/test_db.backup:153: ERROR:  multiple primary keys for table "clients" are not allowed
psql:/home/sergey/db_backup/test_db.backup:161: ERROR:  multiple primary keys for table "orders" are not allowed
psql:/home/sergey/db_backup/test_db.backup:168: ERROR:  relation "strana" already exists
psql:/home/sergey/db_backup/test_db.backup:176: ERROR:  constraint "clients_заказ_fkey" for relation "clients" already exists
GRANT
GRANT
GRANT
GRANT
```
