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
