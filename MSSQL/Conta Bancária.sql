SELECT CTA.CODCTABCOINT AS "Conta Bancária_ID",
       CTA.DESCRICAO AS "Conta Bancária",
       BCO.CODBCO AS "Banco_ID",
       BCO.ABREVIATURA AS "Banco",
       CLS.VALOR AS "Classe_ID",
       CLS.OPCAO AS "Classe",
       CTA.ATIVA AS "Conta Ativa_ID",
       CASE
           WHEN ATIVA= 'S' THEN 'Sim'
           ELSE 'Não'
       END AS "Conta Ativa"
FROM TSICTA CTA
LEFT JOIN TSIBCO BCO ON BCO.CODBCO = CTA.CODBCO
LEFT JOIN
  (SELECT VALOR,
          OPCAO
   FROM TDDOPC
   WHERE NUCAMPO = 1048) CLS ON (CLS.VALOR = CTA.CLASSE)
