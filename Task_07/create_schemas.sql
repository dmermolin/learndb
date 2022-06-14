drop database SmashUp;
revoke usage on schema public FROM smashup;
drop role smashup;

--create user SmashUpRole with password 'qwerty' login ;
create role smashup with password 'qwerty' login createdb ;
create database smashup OWNER = smashup;
grant all privileges on database smashup to smashup;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA dc TO smashup;
--GRANT ALL PRIVILEGES ON TABLE table1 IN SCHEMA public TO SmashUpRole;

create schema dc;--справочники
create schema gm;--таблицы для игры