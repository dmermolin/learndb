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
                                                  'ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÛÝàáâãäåçèéêëìíîïðñòóôûý',
                                                  'ABVGDEZIYKLMNOPRSTUFYEabvgdeziyklmnoprstufye'
                                                ),
                                              '¸', 'yo'),
                                            'æ', 'zh'),
                                          'õ', 'kh'),
                                        'ö', 'ts'),
                                      '÷', 'ch'),
                                    'ø', 'sh'),
                                  'ù', 'shch'),
                                'ú', ''),
                              'ü', ''),
                            'ý', 'e'),
                          'þ', 'yu'),
                        'ÿ', 'ya'),
                      '¨', 'Yo'),
                    'Æ', 'Zh'),
                  'Õ', 'Kh'),
                'Ö', 'Ts'),
              '×', 'Ch'),
            'Ø', 'Sh'),
          'Ù', 'Shch'),
        'Ú', ''),
      'Ü', ''),
    'Ý', 'E'),
  'Þ', 'Yu'),
'ß', 'Ya');
$BODY$
  LANGUAGE sql;