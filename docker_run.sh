#!/bin/bash

#------------------------------------------------------------------------------------------
docker network create --driver=bridge --subnet=172.25.0.0/16 replication_mysql_netology
docker stop replication-master
docker stop replication-slave
docker rm replication-master
docker rm replication-slave
docker run --name replication-master --network=replication_mysql_netology --ip 172.25.0.4 -p 33306:3306 -v ./etc_to_cont/my_master.cnf:/etc/mysql/my.cnf -e MYSQL_ROOT_PASSWORD=123456 -d mysql/mysql-server:latest
docker run --name replication-slave --network=replication_mysql_netology --ip 172.25.0.5 -p 43306:3306 -v ./etc_to_cont/my_slave.cnf:/etc/mysql/my.cnf -e MYSQL_ROOT_PASSWORD=123456 -d mysql/mysql-server:latest

v=$(docker ps | grep "replication" | grep "healthy" | wc | cut -d " " -f7)

until [ $v == 2 ]
    do
        echo "not yet"
        sleep 10
        v=$(docker ps | grep "replication" | grep "healthy" | wc | cut -d " " -f7)

    done

docker exec -it replication-master mysql -u root -p123456 -e "create user IF NOT EXISTS 'other_main'@'172.25.0.1' IDENTIFIED WITH 'caching_sha2_password' BY 'super';GRANT ALL PRIVILEGES ON *.* TO 'other_main'@'172.25.0.1';
FLUSH PRIVILEGES;"
docker exec -it replication-slave mysql -u root -p123456 -e "create user IF NOT EXISTS 'other_main'@'172.25.0.1' IDENTIFIED WITH 'caching_sha2_password' BY 'super';GRANT ALL PRIVILEGES ON *.* TO 'other_main'@'172.25.0.1';
FLUSH PRIVILEGES;"

#------------------------------------------------------------------------------------------
docker exec -it replication-master mysql -u root -p123456 -e "CREATE user IF NOT EXISTS 'replication_user'@'172.25.0.5' IDENTIFIED WITH sha256_password BY 'replication_password'; GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'172.25.0.5'; FLUSH PRIVILEGES;FLUSH TABLES WITH READ LOCK;UNLOCK TABLES;"
docker exec -it replication-master mysql -u root -p123456 -e "show master status;" | grep "mysql-bin" > bin_name_mysql_m.txt

FL=$(cat bin_name_mysql_m.txt | cut -d "|" -f2| xargs)
echo $FL

POS=$(cat bin_name_mysql_m.txt | cut -d "|" -f3| xargs)
echo $POS

docker exec -it replication-slave mysql -u root -p123456 -e "STOP SLAVE; change replication source to source_user='replication_user', source_password='replication_password', source_host='172.25.0.4', source_log_file=\"$FL\", source_log_pos=$POS; STart SLAVE;"

docker exec -it replication-slave mysql -u root -p123456 -e "show replica status \G;" 

#------------------------------------------------------------------------------------------

docker exec -it replication-master mysql -u root -p123456 -e "create database netology_test;"