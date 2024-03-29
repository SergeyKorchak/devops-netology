### Задание 1

1. Изучите проект. В файле variables.tf объявлены переменные для yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
3. Сгенерируйте или используйте свой текущий ssh ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
4. Инициализируйте проект, выполните код. Исправьте возникшую ошибку. Ответьте в чем заключается ее суть?
5. Ответьте, как в процессе обучения могут пригодиться параметры```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ? Ответ в документации Yandex cloud.

В качестве решения приложите:
- скриншот ЛК Yandex Cloud с созданной ВМ,
- скриншот успешного подключения к консоли ВМ через ssh,
- ответы на вопросы.

```
Ошибка: указанное количество ядер недоступно на платформе "standard-v1"; допустимое количество ядер: 2, 4

Ответы на вопросы в документации по ссылке https://cloud.yandex.ru/docs/compute/concepts/instance-groups/instance-template

preemptible = true - сделать виртуальную машину прерываемой

Прерываемые виртуальные машины — это виртуальные машины, которые могут быть принудительно остановлены в любой момент. Это может произойти в двух случаях:
 1. Если с момента запуска виртуальной машины прошло 24 часа.
 2. Если возникнет нехватка ресурсов для запуска обычной виртуальной машины в той же зоне доступности. Вероятность такого события низкая, но может меняться изо дня в день.

core_fraction=5 - базовый уровень производительности vCPU
```

![VM](https://github.com/SergeyKorchak/devops-netology/assets/119151349/13673792-afde-4ab4-b3e2-11f3bec5f525)

### Задание 2

1. Изучите файлы проекта.
2. Замените все "хардкод" **значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле [**variables.tf**](https://github.com/SergeyKorchak/devops-netology/blob/main/terraform-02/02/src/variables.tf), обязательно указывайте тип переменной. Заполните их **default** прежними значениями из [**main.tf**](https://github.com/SergeyKorchak/devops-netology/blob/main/terraform-02/02/src/main.tf). 
3. Проверьте terraform plan (изменений быть не должно). 

```
No changes. Your infrastructure matches the configuration.
Изменений нет.
```

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ(в файле main.tf): **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом **vm_db_** в том же файле([**vms_platform.tf**](https://github.com/SergeyKorchak/devops-netology/blob/main/terraform-02/02/src/vms_platform.tf)).
3. Примените изменения.

```
Выполнено. Вторая ВМ создана.
```

### Задание 4

1. Объявите в файле [**outputs.tf**](https://github.com/SergeyKorchak/devops-netology/blob/main/terraform-02/02/src/outputs.tf) output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```

```
Outputs:

outputs = {
  "external_ip" = "51.250.95.97"
  "external_ip_2" = "158.160.46.241"
  "instance_name" = "netology-develop-platform-web"
  "instance_name_2" = "netology-develop-platform-db"
}
```

### Задание 5

1. В файле [**locals.tf**](https://github.com/SergeyKorchak/devops-netology/blob/main/terraform-02/02/src/locals.tf) опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.
3. Примените изменения.

```
Выполнено. Переменные обновил.
```

### Задание 6

1. Вместо использования 3-х переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедените их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources".
2. Так же поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan (изменений быть не должно).

```
Выполнено. Лишние переменные удалены.
```
