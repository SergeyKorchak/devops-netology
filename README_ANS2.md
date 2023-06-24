1. Подготовьте свой inventory-файл [`prod.yml`](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2/inventory/prod.yml).

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

sergey@pc:~/playbook2$ ansible-playbook -i inventory/prod.yml site.yml
PLAY [Install Clickhouse] ******************************************************
TASK [Gathering Facts] *********************************************************
fatal: [clickhouse-01]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: sergey@localhost: Permission denied (publickey,password).", "unreachable": true}
PLAY RECAP *********************************************************************
clickhouse-01              : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0  

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
sergey@pc:~/playbook2$ ansible-lint site.yml
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```
sergey@pc:~/playbook2$ ansible-playbook -i inventory/prod.yml site.yml --check
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```
sergey@pc:~/playbook2$ ansible-playbook -i inventory/prod.yml site.yml --diff
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```
sergey@pc:~/playbook2$ ansible-playbook -i inventory/prod.yml site.yml --diff
```

9. Подготовьте README.md-файл по своему [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2). В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

10. Готовый [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook2) выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.
