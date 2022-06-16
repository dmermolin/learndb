--созданю схему и три временные таблицы
create schema ur;

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
\copy ur.bases FROM '/var/lib/postgresql/data/pgdata/csv_data/bases.csv' DELIMITER ';' CSV HEADER;

create table if not exists ur.actions
(
    id            int2,
    fractions     varchar(100),
    name          varchar(100),
    description   varchar(2000),
    type_action   varchar(100),
    count_in_desc int2
);
\copy ur.actions FROM '/var/lib/postgresql/data/pgdata/csv_data/action.csv' DELIMITER ';' CSV HEADER;

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
\copy ur.minions FROM '/var/lib/postgresql/data/pgdata/csv_data/minions.csv' DELIMITER ';' CSV HEADER;