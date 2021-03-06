Конфигурация Ansible
====================

Конфигурация верхнего уровня для развёртывания инфраструктуры с помощью
[Ansible](https://www.ansible.com).



Содержание
----------

* [Обзор](#конфигурация-ansible)
* [Содержание](#содержание)
* [Подготовка серверов](#подготовка-серверов)
* [Подготовка конфигурации](#подготовка-конфигурации)
* [Использование конфигурации](#использование-конфигурации)



Подготовка серверов
-------------------

Необходимо создать на серверах пользователя, добавить его в группу `sudo`,
установить ему пароль и записать его в инвентарь конфигурации. Это можно
сделать, выполнив указанные далее команды на сервере. Имя пользователя
`kotovalexarian` замените на ваше.

```
adduser --gecos '' kotovalexarian
usermod -a -G sudo kotovalexarian
```

Также нужно будет разрешить этому пользователю подключаться по SSH с помощью
вашего публичного ключа. Текущая конфигурация отключает возможность
аутентификации по паролю. Убедитесь, что вы можете войти с помощью публичного
ключа, иначе вы рискуете потерять доступ к серверу.



Подготовка конфигурации
-----------------------

Для ускорения работы Ansible используется библиотека
[Mitogen](https://mitogen.networkgenomics.com/). Необходимо установить её
в директорию `vendor`:

```
wget -O vendor/mitogen-0.2.8.tar.gz https://networkgenomics.com/try/mitogen-0.2.8.tar.gz
tar -xzf vendor/mitogen-0.2.8.tar.gz -C vendor/
```

Конфигурация зависит от ролей [Ansible Galaxy](https://galaxy.ansible.com),
указанных в файле `requirements.yml`. Следующую команду нужно запускать
перед началом работы с конфигурацией, а также после добавления ролей
или изменения их версий:

```
ansible-galaxy install -r requirements.yml -f
```

В директорию `secrets` можно поместить файлы, имя которых соответствует
Ansible Vault ID, а содержимое является паролем от соответствующего Vault ID.
Тогда при использовании скриптов из директории `bin` не придётся указывать эти
Vault ID вручную.

В файл `admin` нужно поместить имя своего пользователя (например,
`kotovalexarian`).



Использование конфигурации
--------------------------

Проверка доступности всех серверов:

```
./bin/ansible all -m ping
```

Перезагрузка всех серверов:

```
./bin/ansible all -m reboot
```

Обновление системных пакетов на всех серверах:

```
./bin/ansible all -m apt -a 'update_cache=yes upgrade=yes'
```

Показать пароль пользователя для каждого сервера:

```
./bin/ansible all -m debug -a var=ansible_become_pass
```

Развёртывание всей инфраструктуры:

```
./bin/ansible-playbook playbooks/deploy/site.yml
```

Создание резервной копии всех данных:

```
./bin/ansible-playbook playbooks/backup/site.yml
```

Шифрование секретных данных (`somedata` и `somevault` замените):

```
ansible-vault encrypt_string 'somedata' --vault-id somevault@secrets/somevault
```
