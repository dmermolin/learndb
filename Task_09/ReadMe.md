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
