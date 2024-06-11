SELECT B.DIA,
       COALESCE(B.CODCTABCOINT, -999) AS "Conta Bancária",
       COALESCE(EMP.RAZAOSOCIAL, 'Sem Empresa') AS "Empresa",
       COALESCE(EMP.CODEMP,0) AS "Empresa ID",
       SUM(B.SALDOREAL) AS "Saldo Bancário"
FROM 
  (SELECT DIA AS DIA,
          DESCRICAO,
          CODCTABCOINT,
          SALDO,
          MOVIMENTO,
          CODEMP,
          SALDO+MOVIMENTO AS SALDOREAL
   FROM
     (SELECT DIAS.DIA,
             C.DESCRICAO,
             C.CODCTABCOINT,
             C.CODEMP,
             COALESCE(SUM(S.SALDOREAL),0) AS SALDO,
             COALESCE(SUM(
                            (SELECT SUM(M.VLRLANC*M.RECDESP)
                             FROM TGFMBC M
                             WHERE M.CODCTABCOINT = S.CODCTABCOINT
                               AND TO_CHAR(M.DTLANC,'MMYYYY') = TO_CHAR(DIAS.DIA, 'MMYYYY')
                               AND TRUNC(M.DTLANC) <= DIAS.DIA )),0) AS MOVIMENTO
      FROM TGFSBC S
      INNER JOIN TSICTA C ON S.CODCTABCOINT = C.CODCTABCOINT,
        (SELECT ULTIMO - ROWNUM + 1 AS DIA,
                ROWNUM,
                QUANTIDADE
         FROM
           (SELECT SYSDATE AS ULTIMO,
                   SYSDATE - TRUNC(SYSDATE, 'YEAR') + 1 AS QUANTIDADE
            FROM DUAL) CONNECT BY ROWNUM <= QUANTIDADE) DIAS
      WHERE S.REFERENCIA =
          (SELECT MAX(REFERENCIA)
           FROM TGFSBC SBC
           WHERE SBC.CODCTABCOINT = S.CODCTABCOINT
             AND REFERENCIA <= DIAS.DIA)
        AND DESCRICAO NOT LIKE 'INATIVA%'
        AND DESCRICAO NOT LIKE 'INATVA%'
      GROUP BY C.DESCRICAO,
               C.CODCTABCOINT,
               C.CODEMP,
               DIAS.DIA ) A)B
LEFT JOIN TSIEMP EMP ON EMP.CODEMP = B.CODEMP 
GROUP BY B.DIA,
         COALESCE(B.CODCTABCOINT, -999),
         COALESCE(EMP.RAZAOSOCIAL, 'Sem Empresa'),
         COALESCE(EMP.CODEMP,0)
