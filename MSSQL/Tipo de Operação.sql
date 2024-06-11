SELECT TPO.CODTIPOPER AS "Tipo de Operação ID",
       TPO.DESCROPER AS "Tipo de Operação",
       TPO.TIPMOV AS "Tipo de Movimentação ID",
       TPV.OPCAO AS "Tipo de Movimentação"
FROM TGFTOP TPO
LEFT JOIN
  (SELECT VALOR,
          OPCAO
   FROM TDDOPC
   WHERE NUCAMPO = 856) TPV ON (TPV.VALOR = TPO.TIPMOV)
