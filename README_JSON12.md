------

## Задание 1

Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        }
        { "name" : "second",
        "type" : "proxy",
        "ip : 71.78.22.43
        }
    ]
}
```

Нужно найти и исправить все ошибки, которые допускает наш сервис

### Ваш скрипт:
```
{ "info" : "Sample JSON output from our service\t",
    "elements" : [
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        }
        { "name" : "second",
        "type" : "proxy",
        "ip" : "71.78.22.43"
        }
    ]
}
```

------

## Задание 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
import sys
import socket
import time
import json
import yaml

hosts = {'drive.google.com':'142.251.141.46', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}
mas = []
while True:
    for host in hosts:
        ip = socket.gethostbyname(host)
        if ip != hosts[host]:
            print('[ERROR] '+str(host)+' IP mistmatch: '+hosts[host]+' '+ip)
            hosts[host]=ip
            mas.append({str(host) : ip})
            with open("file1.json", "w") as outfile1:
            	json.dump(mas, outfile1)
            with open("file2.yaml", "w") as outfile2:
            	yaml.dump(mas, outfile2)
        else:
            print(str(host) + ' ' + ip)
            time.sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
sergey@pc:~$ python3 1.py
drive.google.com 142.251.141.46
[ERROR] mail.google.com IP mistmatch: 0.0.0.0 142.250.187.101
[ERROR] google.com IP mistmatch: 0.0.0.0 142.250.187.142
drive.google.com 142.251.141.46
mail.google.com 142.250.187.101
```

### json-файл(ы), который(е) записал ваш скрипт:
```
https://github.com/SergeyKorchak/devops-netology/blob/main/file1.json
```

### yml-файл(ы), который(е) записал ваш скрипт:
```
https://github.com/SergeyKorchak/devops-netology/blob/main/file2.yaml
```

------
