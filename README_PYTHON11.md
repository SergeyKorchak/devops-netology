------

## Задание 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | TypeError: unsupported operand type(s) for +: 'int' and 'str'  |
| Как получить для переменной `c` значение 12?  | c = str(a) + b  |
| Как получить для переменной `c` значение 3?  | c = a + int(b)  |

------

## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(os.path.abspath(prepare_result))
```

### Вывод скрипта при запуске при тестировании:
```
sergey@pc:~$ python3
Python 3.10.6 (main, Nov 14 2022, 16:10:14) [GCC 11.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> #!/usr/bin/env python3
>>> import os
>>> bash_command = ["cd /media/sergey/FADC250CDC24C52B/Users/Sergey/Project/devops-netology/devops-netology", "git status"]
>>> result_os = os.popen(' && '.join(bash_command)).read()
>>> for result in result_os.split('\n'):
...     if result.find('modified') != -1:
...             prepare_result = result.replace('\tmodified:   ', '')
...             print(os.path.abspath(prepare_result))
... 
/home/sergey/README.md
/home/sergey/README_GIT_TOOLS.md
/home/sergey/README_GIT_TOOLS.txt
/home/sergey/README_IS9.md
/home/sergey/README_OS3.md
/home/sergey/README_OS4.md
/home/sergey/README_TERM1.md
/home/sergey/branching/merge.sh
/home/sergey/branching/rebase.sh
/home/sergey/terraform/.gitignore
```

------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

path = input()
bash_command = ["cd "+path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
	if result.find('modified') != -1:
		prepare_result = result.replace('\tmodified:   ', '')
		print(os.path.abspath(prepare_result))
```

### Вывод скрипта при запуске при тестировании:
```
sergey@pc:~$ python3
Python 3.10.6 (main, Nov 14 2022, 16:10:14) [GCC 11.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> #!/usr/bin/env python3
>>> import os
>>> path = input()
/media/sergey/FADC250CDC24C52B/Users/Sergey/Project/devops-netology/devops-netology
>>> bash_command = ["cd "+path, "git status"]
>>> result_os = os.popen(' && '.join(bash_command)).read()
>>> for result in result_os.split('\n'):
...     if result.find('modified') != -1:
...             prepare_result = result.replace('\tmodified:   ', '')
...             print(os.path.abspath(prepare_result))
... 
/home/sergey/README.md
/home/sergey/README_GIT_TOOLS.md
/home/sergey/README_GIT_TOOLS.txt
/home/sergey/README_IS9.md
/home/sergey/README_OS3.md
/home/sergey/README_OS4.md
/home/sergey/README_TERM1.md
/home/sergey/branching/merge.sh
/home/sergey/branching/rebase.sh
/home/sergey/terraform/.gitignore

```

------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 
- опрашивает веб-сервисы, 
- получает их IP, 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
import sys
import socket
import time

hosts = {'drive.google.com':'142.251.141.46', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}
while 1 == 1:
    for host in hosts:
        ip = socket.gethostbyname(host)
        if ip != hosts[host]:
            print('[ERROR] '+str(host)+' IP mistmatch: '+hosts[host]+' '+ip)
            hosts[host]=ip
        else:
            print(str(host) + ' ' + ip)
            time.sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
sergey@pc:~$ python3 1.py
[ERROR] drive.google.com IP mistmatch: 142.251.141.46 172.217.17.110
[ERROR] mail.google.com IP mistmatch: 0.0.0.0 142.250.184.133
[ERROR] google.com IP mistmatch: 0.0.0.0 142.250.187.110
drive.google.com 172.217.17.110
mail.google.com 142.250.184.133
google.com 142.250.187.110
drive.google.com 172.217.17.110
mail.google.com 142.250.184.133
google.com 142.250.187.110
```

------
