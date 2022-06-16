/*�������� �������
DML � PostgreSQL

����:
�������� ������ � ������������� SELECT, JOIN
�������� ������ � ����������� ������ INSERT INTO
�������� ������ � ����������� ������ � UPDATE FROM
������������ using ��� ��������� DELETE

��������/��������� ���������� ���������� ��������� �������:
1. �������� ������ �� ����� ���� � ���������� ����������, �������� ���������, ��� �� ������ �����.
2. �������� ������ �� ����� ���� � �������������� LEFT JOIN � INNER JOIN, ��� ������� ���������� � FROM ������ �� ���������? ������?
3. �������� ������ �� ���������� ������ � ������� ���������� � ����������� �������.
4. �������� ������ � ����������� ������ ��������� UPDATE FROM.
5. �������� ������ ��� �������� ������ � ���������� DELETE ��������� join � ������ �������� � ������� using.*/

--1.�������� ������ �� ����� ���� � ���������� ����������, �������� ���������, ��� �� ������ �����.

--��� ������, ��� desscription ���������� � '������%'
select *
from dc.play_cards
where description like '������%';
--������, ��� � description ���� ����� �����
select *
from dc.play_cards
where description similar to '%[0-9]%';
--������, ��� � description ���� ����� "����������" ��� "��������"
select *
from dc.play_cards
where description similar to '%(����������|��������)%';

--2. �������� ������ �� ����� ���� � �������������� LEFT JOIN � INNER JOIN, ��� ������� ���������� � FROM ������ �� ���������? ������?

--inner join. ������ ��������� ����� � ��������
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

--left join � inner join. ������� ��� ������������ ��������, ���� ��� ����, � ��������� �������
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

--3. �������� ������ �� ���������� ������ � ������� ���������� � ����������� �������.
truncate table dc.bases cascade;

select * from dc.bases;

INSERT INTO dc.bases (name, code, description, lives, first_place_award, second_place_award, third_place_award)
SELECT name, ur.ru_translit(name), properties, health, first_place, second_place, third_place
FROM ur.bases
returning id,name, code, description, lives, first_place_award, second_place_award, third_place_award;

--4. �������� ������ � ����������� ������ ��������� UPDATE FROM.
update dc.bases d
set name = d.name || ' ; ' ||u.id
from ur.bases u
where u.name = d.name;

--5. �������� ������ ��� �������� ������ � ���������� DELETE ��������� join � ������ �������� � ������� using.

select * from dc.bases b
 join ur.bases using (name)
where b.lives between 18 and 20;

start transaction ;

delete from dc.bases b
    using ur.bases u
where b.lives between 18 and 20;

rollback ;