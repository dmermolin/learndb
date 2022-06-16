/*join*/
--������� �������
select *
from dc.play_cards pc
         join dc.fractions f on f.id = pc.fraction;

--using join �� ���������� ������ ��������. � ������ ������ �� id
select *
from dc.play_cards pc
         join dc.fractions f using (id);

--natural. ���������� �� ����� �����
select *
from dc.play_cards pc
         natural join dc.fractions f;


/*reg exp*/

--�� �������� �������
select *
from actor
where first_name ilike '%En';

/*
~~ - like
~~* ilike
*/
select *
from actor
where first_name !~~* '%En';
~~* 	!~~	!~~*


select *
from actor
where first_name similar to 'J(O|E)%';