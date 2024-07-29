# Домашнее задание к занятию «Репликация и масштабирование. Часть 1»
---

### Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

master-slave - один пишет, другой его повторяет. с обоих моджно считывать
master-master - пишут оба, повторяют друг за другом. с обоих моджно считывать

---

### Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*


`Запуск и создание docker_run.sh`
[docker_run.sh](https://github.com/SeSloup/Mysql_replication/blob/main/docker_run.sh) 


![00](https://github.com/SeSloup/Mysql_replication/blob/main/screens/00.png)

![01](https://github.com/SeSloup/Mysql_replication/blob/main/screens/01.png)

![02](https://github.com/SeSloup/Mysql_replication/blob/main/screens/02.png)

![03](https://github.com/SeSloup/Mysql_replication/blob/main/screens/03.png)

![04](https://github.com/SeSloup/Mysql_replication/blob/main/screens/04.png)

-----------------------------------------

Спасибо за проверку !

---

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

---

### Задание 3* 

Выполните конфигурацию master-master репликации. Произведите проверку.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*
