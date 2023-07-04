1. Допишите [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook3): нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл [`prod.yml`](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook3/inventory/prod.yml).
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```
sergey@pc:~/playbook2$ ansible-lint site.yml
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

9. Подготовьте README.md-файл по своему [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook3). В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый [playbook](https://github.com/SergeyKorchak/devops-netology/tree/master/playbook3) выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.
