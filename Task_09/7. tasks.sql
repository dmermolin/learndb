/*Домашнее задание
DML в PostgreSQL

Цель:
Написать запрос с конструкциями SELECT, JOIN
Написать запрос с добавлением данных INSERT INTO
Написать запрос с обновлением данных с UPDATE FROM
Использовать using для оператора DELETE

Описание/Пошаговая инструкция выполнения домашнего задания:
1. Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.
2. Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?
3. Напишите запрос на добавление данных с выводом информации о добавленных строках.
4. Напишите запрос с обновлением данные используя UPDATE FROM.
5. Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.*/

--1.Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.

--все записи, где desscription начинается с 'Можешь%'
select *
from dc.play_cards
where description like 'Можешь%';
--записи, где в description есть любая цифра
select *
from dc.play_cards
where description similar to '%[0-9]%';
--записи, где в description есть слово "приспешник" или "действие"
select *
from dc.play_cards
where description similar to '%(приспешник|действие)%';

--2. Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?

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

--3. Напишите запрос на добавление данных с выводом информации о добавленных строках.
truncate table dc.bases cascade;

select * from dc.bases;

INSERT INTO dc.bases (name, code, description, lives, first_place_award, second_place_award, third_place_award)
SELECT name, ur.ru_translit(name), properties, health, first_place, second_place, third_place
FROM ur.bases
returning id,name, code, description, lives, first_place_award, second_place_award, third_place_award;

--4. Напишите запрос с обновлением данные используя UPDATE FROM.
update dc.bases d
set name = d.name || ' ; ' ||u.id
from ur.bases u
where u.name = d.name;

--5. Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.

select * from dc.bases b
 join ur.bases using (name)
where b.lives between 18 and 20;

start transaction ;

delete from dc.bases b
    using ur.bases u
where b.lives between 18 and 20;

rollback ;