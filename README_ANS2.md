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
TASK [Install clickhouse packages] *********************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No package matching 'clickhouse-common-static-22.3.3.44.rpm' is available"}
PLAY RECAP *********************************************************************
clickhouse-01              : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
sergey@pc:~/playbook2$ ansible-lint site.yml
Failed to guess project directory using git: fatal: не найден git репозиторий (или один из родительских каталогов): .git
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
WARNING  Listing 1 violation(s) that are fatal
yaml: wrong indentation: expected 4 but found 2 (indentation)
site.yml:40
You can skip specific rules or tags by adding them to your configuration file:
# .ansible-lint
warn_list:  # or 'skip_list' to silence them completely
  - yaml  # Violations reported by yamllint
Finished with 1 failure(s), 0 warning(s) on 1 files.
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```
sergey@pc:~/playbook2$ ansible-playbook --check -i inventory/prod.yml site.yml --ask-become-pass
BECOME password: 
PLAY [Install Clickhouse] ******************************************************
TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]
TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
TASK [Install clickhouse packages] *********************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No package matching 'clickhouse-common-static-22.3.3.44.rpm' is available"}
PLAY RECAP *********************************************************************
clickhouse-01              : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```
sergey@pc:~/playbook2$ ansible-playbook --diff -i inventory/prod.yml site.yml --ask-become-pass
BECOME password: 
PLAY [Install Clickhouse] ******************************************************
TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]
TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
TASK [Install clickhouse packages] *********************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No package matching 'clickhouse-common-static-22.3.3.44.rpm' is available"}
PLAY RECAP *********************************************************************
clickhouse-01              : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0 
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```
sergey@pc:~/playbook2$ ansible-playbook --diff -i inventory/prod.yml site.yml --ask-become-pass
```

9. Подготовьте README.md-файл по своему [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2). В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

10. Готовый [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2) выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.
