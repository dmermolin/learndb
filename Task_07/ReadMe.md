# DDL: создание, изменение и удаление объектов в PostgreSQL 

### База, роль и схема
Создал роль **smashup**

```
create role smashup with password 'qwerty' login createdb ;
```

Потом базу данных, назвал так же **smashup**. Назвал так же, что бы самому не запутаться, что юзер **smashup** работает с базой, с таким же именем. Издержки работы в Оракле с поьзователем и схемой пользователя) 
Если так делать не стоит, то переделаю, может быть плохая практика? 

Потом создал базу 
```
create database smashup OWNER = smashup;
```

И дал гранты

```
grant all privileges on database smashup to smashup;
```

Создал две схемы: 
- dc - условно для справочников, какие то постоянные вещи, которые особо изменять и не нужно будет
- gm уже непосредственно относящиеся к игре таблицы, пользователи, матч и т.д. 

База:

![image](https://user-images.githubusercontent.com/95203401/174113073-003caeef-a577-4ec2-b762-f1e40686a3ae.png)

Подключился под **smashup**, смотрю схемы

![image](https://user-images.githubusercontent.com/95203401/174113516-aeb802ad-7add-4c56-a1b0-40947b90b8e0.png)


### Таблицы

Схема *dc*

