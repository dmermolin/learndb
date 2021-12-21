# Установка СУБД PostgreSQL в Docker

### выполнил команду **docker_images**, образа нет. Выполнил поиск коммандой **docker search postges**, нашел образ, выполнил комманду **docker pull postgres**
![01](https://user-images.githubusercontent.com/95203401/146886409-0e2ea551-de55-4eeb-892b-ee092a46d56d.png)

### запулил образ, теперь отображается 
![02](https://user-images.githubusercontent.com/95203401/146886447-71730dd2-3816-4a79-9e30-e71bc48f85fe.png)

### выполнил комманду **docker run --rm postgres14 -e POSTGRES_PASSWORD=12346 -d -p 5432:5432 postgres**. Проверка коммандой **docker ps**, контейнер отображается 
![03](https://user-images.githubusercontent.com/95203401/146886637-dadadd64-9412-48cd-8fa7-1f3f1f03b7a5.png)

### выполнил команду **docker exec -t postgres14 bash**, запустил оболочку psql, отобразил существующие базы данных
![04](https://user-images.githubusercontent.com/95203401/146886783-ea8511ed-ec6f-42c6-b479-9b76d3ba3580.png)


### предварительно установил pqAdmin 4, подключился
![05](https://user-images.githubusercontent.com/95203401/146886860-409b0d67-cb80-4216-84cc-fd7b3ac99365.png)

### далее настроил файл docker-compose.yml, где прописал конфигурацию запуска
![06](https://user-images.githubusercontent.com/95203401/146886970-33fbb9ac-4f5f-4ce1-b9a1-dd9180d80ce7.png)

### запустил контейнер
![07](https://user-images.githubusercontent.com/95203401/146887044-5e0d8b28-8e82-4875-a309-4e61daee0f0b.png)

### создал базу данных otus_test_db
![08](https://user-images.githubusercontent.com/95203401/146887111-08f541db-d422-4ced-9757-6a4dff9fb0d3.png)

### выполнил команду **docker stop docker_postgres_1**
![09](https://user-images.githubusercontent.com/95203401/146887229-2a0294da-d91a-46be-8fca-282d44472149.png)

### запустил еще раз командой **docker-compose up -d**
![10](https://user-images.githubusercontent.com/95203401/146887535-5519ed0a-c969-4482-a409-e78ce202b33e.png)

### подключился через pgAdmin
![11](https://user-images.githubusercontent.com/95203401/146887821-a450c051-1321-4081-aa5e-d1b6a6392e08.png)

