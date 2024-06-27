 WITH r AS (
    SELECT 0 AS n
    UNION ALL
    SELECT n+1 FROM r WHERE n+1<=(DATEDIFF( DD, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0),GETDATE()) )
)

  SELECT CONVERT(DATE,  DIA)  as "Data",
            CAST(ISNULL( CTA.CODCTABCOINT, -999)AS INT) AS "Conta Bancária",
            ISNULL( EMP.RAZAOSOCIAL,'Nulo')  AS "Empresa",
            CAST(ISNULL( EMP.CODEMP,-999) AS INT) AS "Empresa ID",
            SALDO+MOVIMENTO AS "Saldo Bancário"
    FROM  
      (   SELECT 
             DIAS.DIA,
             C.DESCRICAO,
             C.CODCTABCOINT,
             C.CODEMP,
             ISNULL(SUM(S.SALDOREAL),0) AS SALDO,
             ISNULL((SELECT 
                            SUM(M.VLRLANC*M.RECDESP)
                           FROM 
                            TGFMBC M
                          WHERE 
                            M.CODCTABCOINT = C.CODCTABCOINT
                        AND CONVERT(VARCHAR(6), M.DTLANC, 112) = CONVERT(VARCHAR(6), DIAS.DIA, 112)
                        AND CONVERT(DATE,M.DTLANC) <= CONVERT(DATE,DIAS.DIA)
                        
                    ),0)
             AS MOVIMENTO
            FROM 
             TGFSBC S
  INNER JOIN TSICTA C ON S.CODCTABCOINT = C.CODCTABCOINT,
   (SELECT DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)+N DIA FROM r) DIAS
           WHERE 
             S.REFERENCIA = (SELECT 
                                MAX(REFERENCIA) 
                               FROM 
                                TGFSBC SBC 
                              WHERE 
                                SBC.CODCTABCOINT = S.CODCTABCOINT
                            AND REFERENCIA <= DIAS.DIA)
        GROUP BY 
             C.DESCRICAO, C.CODCTABCOINT, C.CODEMP, DIAS.DIA
      ) A
LEFT JOIN TSICTA CTA ON A.CODCTABCOINT = CTA.CODCTABCOINT  
LEFT JOIN TSIEMP EMP ON A.CODEMP = EMP.CODEMP

OPTION (MAXRECURSION 1000)
