# DML: вставка, обновление, удаление, выборка данных 

### Подготовка справочников
Сначала загружаю данные в ранее созданные таблицы, по сути заполняю справочники, в схеме **dc**.

Заранее подготовил три файла: 

[action.csv](https://github.com/dmermolin/learndb/files/8901068/action.csv)
[bases.csv](https://github.com/dmermolin/learndb/files/8901069/bases.csv)
[minions.csv](https://github.com/dmermolin/learndb/files/8901070/minions.csv)

Создал схему **ur** для работы с промежуточными данными.

```
create schema ur;
```

Для них создал три временные таблицы, из которых потом буду раскидывать по справочникам:
- bases
```
create table if not exists ur.bases
(
    id           int2,
    name         varchar(50),
    properties   varchar(2000),
    health       int2,
    first_place  int2,
    second_place int2,
    third_place  int2
);
```
- actions
```
create table if not exists ur.actions
(
    id            int2,
    fractions     varchar(100),
    name          varchar(100),
    description   varchar(2000),
    type_action   varchar(20),
    count_in_desc int2
);
```
- minions
```
create table if not exists ur.minions
(
    id            int2,
    fractions     varchar(100),
    name          varchar(100),
    properties    varchar(2000),
    action_type   varchar(100),
    attack        int2,
    count_in_desc int2
);
```

Создал директорию:
![01](https://user-images.githubusercontent.com/95203401/173617826-5b5fc19c-67b0-4ecd-b018-08dc36f4c80a.png)

В закинул файлы в дирректорию. Я работаю в Windows через сабсистему linux (wsl) поэтому данные закинул через проводник: 
![02](https://user-images.githubusercontent.com/95203401/173618115-fb4d4924-cdae-43ea-9cbd-92af29bf03ae.png)

Посмотрел, файлы есть:
![03](https://user-images.githubusercontent.com/95203401/173618188-ff4fb479-3272-42d4-8ebe-12723f28d270.png)

Далее с помощью утилиты *\copy* загрузил данные.
Комманды для трех таблиц:
```
\copy ur.bases FROM '/var/lib/postgresql/data/pgdata/csv_data/bases.csv' DELIMITER ';' CSV HEADER;
\copy ur.actions FROM '/var/lib/postgresql/data/pgdata/csv_data/action.csv' DELIMITER ';' CSV HEADER;
\copy ur.minions FROM '/var/lib/postgresql/data/pgdata/csv_data/minions.csv' DELIMITER ';' CSV HEADER;
```

Сами данные:
- таблица **ur.bases** ![04](https://user-images.githubusercontent.com/95203401/173618512-9ece4874-8962-419f-bb79-1f6d41516b8c.png)
- таблица **ur.actions** ![05](https://user-images.githubusercontent.com/95203401/173618621-3d3ae208-9320-4f2b-b432-6a9f470fd102.png)
- таблица **ur.minions** ![06](https://user-images.githubusercontent.com/95203401/173618709-1d0b9fbb-56f7-451f-a3e9-e2ad0d1bd597.png)

### Заполняю справочники из подготовленных таблиц

Предварительно пришлось альтернуть таблицы, не угадал с размерностью. 
Скрипт [Task_09/2. alter_tables.sql](https://github.com/dmermolin/learndb/blob/8ff1dcaec7d88cb454262c0a3f009df2b4229d46/Task_09/2.%20alter_tables.sql)

Потом написал пару функций - помогашек:
- транслит русских символов в английские, для заполнения полей **code** https://github.com/dmermolin/learndb/blob/8ff1dcaec7d88cb454262c0a3f009df2b4229d46/Task_09/3.%20ru_translit.sql
- для транкейта, удаления лишних символов https://github.com/dmermolin/learndb/blob/8ff1dcaec7d88cb454262c0a3f009df2b4229d46/Task_09/4.%20def_str.sql

Дальше уже функции и процедуры для заполнения https://github.com/dmermolin/learndb/blob/8ff1dcaec7d88cb454262c0a3f009df2b4229d46/Task_09/5.%20functions.sql
Можно было с хранимками не заморачиваться, но интересно было попробовать)

Непосредственно заполнение данных, используя хранимки:
```
do
$$
    declare
        vr_bases ur.bases%rowtype;
        vr_minions ur.minions%rowtype;
        vr_actions ur.actions%rowtype;
    begin
        for vr_bases in select * from ur.bases
        loop
            call ur.p_set_bases(vr_bases.*);
        end loop;

        for vr_minions in select * from ur.minions
        loop
            call ur.p_set_play_cards(p_fraction := vr_minions.fractions,
                p_name := vr_minions.name,
                p_description := vr_minions.properties,
                p_action_type := vr_minions.action_type,
                p_damage := vr_minions.attack,
                p_quantity_in_deck := vr_minions.count_in_desc,
                p_type_play_card := 'm');
        end loop;

        for vr_actions in select * from ur.actions
        loop
            call ur.p_set_play_cards(p_fraction := vr_actions.fractions,
                p_name := vr_actions.name,
                p_description := vr_actions.description,
                p_action_type := vr_actions.type_action,
                p_damage := null,
                p_quantity_in_deck := vr_actions.count_in_desc,
                p_type_play_card := 'a');
        end loop;

        commit;
    end;
$$ language plpgsql;

call ur.p_set_player_card_state('колода');
call ur.p_set_player_card_state('рука');
call ur.p_set_player_card_state('база');
call ur.p_set_player_card_state('сброс');
```

Получилось примерно так:
**dc.fraction**
![image](https://user-images.githubusercontent.com/95203401/174103651-1a95f045-8eb4-4d2c-8e51-651264305d7a.png)

**dc.bases**
![image](https://user-images.githubusercontent.com/95203401/174103922-1be22f73-7b2f-468c-bce5-dbd93d9b80c9.png)

**dc.play_cards**
![image](https://user-images.githubusercontent.com/95203401/174104167-c35cc5e2-aebb-45bd-9154-108997cca81f.png)

### Непосредственно задания
* Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.

```
--все записи, где desscription начинается с 'Можешь%'
select *
from dc.play_cards
where description like 'Можешь%';
```
![image](https://user-images.githubusercontent.com/95203401/174105045-24678d12-1ca7-48d9-9c5c-0ffafff492f8.png)

```
--записи, где в description есть любая цифра
select *
from dc.play_cards
where description similar to '%[0-9]%';
```
![image](https://user-images.githubusercontent.com/95203401/174105188-50a432c8-2c52-417d-b10c-03574d3ee436.png)

```
--записи, где в description есть слово "приспешник" или "действие"
select *
from dc.play_cards
where description similar to '%(приспешник|действие)%';
```
![image](https://user-images.githubusercontent.com/95203401/174105297-619e1658-ca1a-449b-b9d3-a9671c5c0cdb.png)



* Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?

```
--inner join. Просто соединяем карты с фракцией
select pc.id,
       f.name as fraction,
       pc.name,
       pc.description,
       pc.action_type,
       pc.damage,
       pc.quantity_in_deck,
       pc.code,
       pc.type_play_card
from dc.play_cards pc
         inner join dc.fractions f on f.id = pc.fraction;
```
![image](https://user-images.githubusercontent.com/95203401/174105402-ed663be8-4656-4a53-8977-72566b71b6bd.png)


```
--left join и inner join. Смотрим тип специального действия, если оно есть, и добавляем фракцию
select pc.id,
       f.name   as fraction,
       pc.name,
       pc.description,
       cat.name as action_type,
       pc.damage,
       pc.quantity_in_deck,
       pc.code,
       pc.type_play_card
from dc.play_cards pc
         inner join dc.fractions f on f.id = pc.fraction
         left join dc.card_action_type cat on cat.id = pc.action_type;
```
![image](https://user-images.githubusercontent.com/95203401/174105484-790fd32e-a069-4f57-8b1e-16cebc1715b4.png)


* Напишите запрос на добавление данных с выводом информации о добавленных строках.

```
truncate table dc.bases cascade;

INSERT INTO dc.bases (name, code, description, lives, first_place_award, second_place_award, third_place_award)
SELECT name, ur.ru_translit(name), properties, health, first_place, second_place, third_place
FROM ur.bases
returning id,name, code, description, lives, first_place_award, second_place_award, third_place_award;
```
![image](https://user-images.githubusercontent.com/95203401/174105614-9c676878-226e-484e-98fd-a43a1f952fb8.png)


* Напишите запрос с обновлением данные используя UPDATE FROM

```
update dc.bases d
set name = d.name || ' ; ' ||u.id
from ur.bases u
where u.name = d.name;
```
До
![image](https://user-images.githubusercontent.com/95203401/174105745-000533c5-7b8a-422d-8246-7f6935de1efd.png)

После 

![image](https://user-images.githubusercontent.com/95203401/174105798-a7ed3525-1817-4095-b59f-546f8d92d9c9.png)



* Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using

```
delete from dc.bases b
    using ur.bases u
where b.lives between 18 and 20;
```
![image](https://user-images.githubusercontent.com/95203401/174105942-b3039e66-e549-4100-b03c-c112dac40a26.png)

