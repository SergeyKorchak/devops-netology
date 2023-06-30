1. Подготовьте свой inventory-файл [`prod.yml`](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2/inventory/prod.yml).

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

```
sergey@pc:~/playbook2$ ansible-playbook -i inventory/prod.yml site.yml --ask-become-pass
BECOME password: 
PLAY [Install Clickhouse] ******************************************************
TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]
TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.deb", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/deb/pool/main/c/clickhouse-common-static/clickhouse-common-static_22.3.3.44_all.deb"}
TASK [Get clickhouse distrib] **************************************************
fatal: [clickhouse-01]: FAILED! => {"msg": "The task includes an option with an undefined variable. The error was: 'item' is undefined\n\nThe error appears to be in '/home/sergey/playbook2/site.yml': line 17, column 11, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n      rescue:\n        - name: Get clickhouse distrib\n          ^ here\n"}
PLAY RECAP *********************************************************************
clickhouse-01              : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
sergey@pc:~/playbook2$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```
sergey@pc:~/playbook2$ ansible-playbook --check -i inventory/prod.yml site.yml --ask-become-pass
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```
sergey@pc:~/playbook2$ ansible-playbook --diff -i inventory/prod.yml site.yml --ask-become-pass
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```
sergey@pc:~/playbook2$ ansible-playbook --diff -i inventory/prod.yml site.yml --ask-become-pass
```

9. Подготовьте README.md-файл по своему [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2). В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

10. Готовый [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2) выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.
