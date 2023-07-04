1. Подготовьте свой inventory-файл [`prod.yml`](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2/inventory/prod.yml).

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

```
sergey@pc:~/playbook2$ ansible-playbook -i inventory/prod.yml site.yml --ask-become-pass
BECOME password: 
[WARNING]: While constructing a mapping from /home/sergey/playbook2/site.yml,
line 24, column 9, found a duplicate dict key (deb). Using last defined value
only.

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static.deb", "elapsed": 0, "gid": 1000, "group": "sergey", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "sergey", "response": "HTTP Error 404: Not Found", "size": 246378832, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/deb/pool/main/c/clickhouse-common-static/clickhouse-common-static_22.3.3.44_all.deb"}

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
ok: [clickhouse-01]

TASK [Create database] *********************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "cmd": "clickhouse-client -q 'create database logs;'", "failed_when_result": true, "msg": "[Errno 2] Нет такого файла или каталога: b'clickhouse-client'", "rc": 2}

PLAY RECAP *********************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
sergey@pc:~/playbook2$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```
sergey@pc:~/playbook2$ ansible-playbook --check -i inventory/prod.yml site.yml --ask-become-pass
BECOME password: 
[WARNING]: While constructing a mapping from /home/sergey/playbook2/site.yml,
line 24, column 9, found a duplicate dict key (deb). Using last defined value
only.

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static.deb", "elapsed": 0, "gid": 1000, "group": "sergey", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "sergey", "response": "HTTP Error 404: Not Found", "size": 246378832, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/deb/pool/main/c/clickhouse-common-static/clickhouse-common-static_22.3.3.44_all.deb"}

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
ok: [clickhouse-01]

TASK [Create database] *********************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [Get Vector distrib] ******************************************************
fatal: [vector-01]: FAILED! => {"changed": false, "dest": "./vector-0.21.1-1_amd64.deb", "elapsed": 0, "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.timber.io/vector/0.29.1/vector-0.29.1-1_amd64.deb"}

PLAY RECAP *********************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
vector-01                  : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0  
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```
sergey@pc:~/playbook2$ ansible-playbook --diff -i inventory/prod.yml site.yml --ask-become-pass
BECOME password: 
[WARNING]: While constructing a mapping from /home/sergey/playbook2/site.yml,
line 24, column 9, found a duplicate dict key (deb). Using last defined value
only.

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static.deb", "elapsed": 0, "gid": 1000, "group": "sergey", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "sergey", "response": "HTTP Error 404: Not Found", "size": 246378832, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/deb/pool/main/c/clickhouse-common-static/clickhouse-common-static_22.3.3.44_all.deb"}

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
ok: [clickhouse-01]

TASK [Create database] *********************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "cmd": "clickhouse-client -q 'create database logs;'", "failed_when_result": true, "msg": "[Errno 2] Нет такого файла или каталога: b'clickhouse-client'", "rc": 2}

PLAY RECAP *********************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```
sergey@pc:~/playbook2$ ansible-playbook --diff -i inventory/prod.yml site.yml --ask-become-pass
BECOME password: 
[WARNING]: While constructing a mapping from /home/sergey/playbook2/site.yml,
line 24, column 9, found a duplicate dict key (deb). Using last defined value
only.

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static.deb", "elapsed": 0, "gid": 1000, "group": "sergey", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "sergey", "response": "HTTP Error 404: Not Found", "size": 246378832, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/deb/pool/main/c/clickhouse-common-static/clickhouse-common-static_22.3.3.44_all.deb"}

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
ok: [clickhouse-01]

TASK [Create database] *********************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "cmd": "clickhouse-client -q 'create database logs;'", "failed_when_result": true, "msg": "[Errno 2] Нет такого файла или каталога: b'clickhouse-client'", "rc": 2}

PLAY RECAP *********************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```

9. Подготовьте README.md-файл по своему [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2). В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

10. Готовый [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2) выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.
