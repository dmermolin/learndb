CREATE OR REPLACE FUNCTION ur.ru_translit(p_string character varying)
  RETURNS character varying AS
$BODY$
select
replace(
  replace(
    replace(
      replace(
        replace(
          replace(
            replace(
              replace(
                replace(
                  replace(
                    replace(
                      replace(
                        replace(
                          replace(
                            replace(
                              replace(
                                replace(
                                  replace(
                                    replace(
                                      replace(
                                        replace(
                                          replace(
                                            replace(
                                              replace(
                                                translate(
                                                  $1,
                                                  '��������������������������������������������',
                                                  'ABVGDEZIYKLMNOPRSTUFYEabvgdeziyklmnoprstufye'
                                                ),
                                              '�', 'yo'),
                                            '�', 'zh'),
                                          '�', 'kh'),
                                        '�', 'ts'),
                                      '�', 'ch'),
                                    '�', 'sh'),
                                  '�', 'shch'),
                                '�', ''),
                              '�', ''),
                            '�', 'e'),
                          '�', 'yu'),
                        '�', 'ya'),
                      '�', 'Yo'),
                    '�', 'Zh'),
                  '�', 'Kh'),
                '�', 'Ts'),
              '�', 'Ch'),
            '�', 'Sh'),
          '�', 'Shch'),
        '�', ''),
      '�', ''),
    '�', 'E'),
  '�', 'Yu'),
'�', 'Ya');
$BODY$
  LANGUAGE sql;