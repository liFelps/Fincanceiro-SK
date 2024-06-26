SELECT TRUNC(DTLANC) AS "Dia",
       NAT.CODNAT AS "Natureza NV1",
       NVL(CTA.CODCTABCOINT, -999) AS "Conta Bancária",
       PAR.CODPARC AS "Parceiro",
       CUS.CODCENCUS AS "Centro de Resultado",
       TOP.CODTIPOPER AS "Tipo de Operação",
       EMP.CODEMP AS "Empresa ID",
       EMP.RAZAOSOCIAL AS "Empresa",
       TIT.CODTIPTIT AS "Tipo de Título ID",
       TIT.DESCRTIPTIT AS "Tipo de Título",
       'N' AS "Provisão ID",
       'Não' AS "Provisão",
       CASE
           WHEN TRUNC(FIN.DTVENC) > TRUNC(FIN.DHBAIXA) THEN 6
           WHEN TRUNC(FIN.DTVENC) < TRUNC(FIN.DHBAIXA) THEN 7
           WHEN TRUNC(FIN.DTVENC) = TRUNC(FIN.DHBAIXA) THEN 8
       END AS "Status ID",
       CASE
           WHEN TRUNC(FIN.DTVENC) > TRUNC(FIN.DHBAIXA) THEN 'Atrasada'
           WHEN TRUNC(FIN.DTVENC) < TRUNC(FIN.DHBAIXA) THEN 'ADiantada'
           WHEN TRUNC(FIN.DTVENC) = TRUNC(FIN.DHBAIXA) THEN 'No vencimento'
       END AS "Status" ,
       FIN.RECDESP AS "Recdesp ID",
       CASE
           WHEN FIN.RECDESP = 1 THEN 'Receita'
           WHEN FIN.RECDESP = -1 THEN 'Despesa'
           ELSE 'N/A'
       END AS "Recdesp",
       NUFIN AS "Nufin ID",
       NUFIN AS "Nufin",
       (CASE
            WHEN FIN.RECDESP = 1 THEN FIN.VLRBAIXA
        END) AS "Recebidos",
       (CASE
            WHEN FIN.RECDESP = -1 THEN FIN.VLRBAIXA
        END) AS "Pagos",
       NULL AS "A Receber",
       NULL AS "A Pagar"
FROM TGFMBC MBC
LEFT JOIN TGFFIN FIN ON FIN.NUBCO = MBC.NUBCO
LEFT JOIN TGFPAR PAR ON PAR.CODPARC = FIN.CODPARC
LEFT JOIN TGFNAT NAT ON NAT.CODNAT = FIN.CODNAT
LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = FIN.CODCENCUS
LEFT JOIN TSIEMP EMP ON EMP.CODEMP = FIN.CODEMP
LEFT JOIN TGFTOP TOP ON TOP.CODTIPOPER = FIN.CODTIPOPER
AND FIN.DHTIPOPER = TOP.DHALTER
LEFT JOIN TGFTIT TIT ON TIT.CODTIPTIT = FIN.CODTIPTIT
LEFT JOIN TSICTA CTA ON CTA.CODCTABCOINT = FIN.CODCTABCOINT
WHERE DHBAIXA IS NOT NULL
    AND FIN.NUFIN IS NOT NULL/*BAIXAS*/
    
UNION ALL

SELECT TRUNC(DTVENC) AS "Dia",
       NAT.CODNAT AS "Natureza NV1",
       NVL(CTA.CODCTABCOINT, -999) AS "Conta Bancária",
       PAR.CODPARC AS "Parceiro",
       CUS.CODCENCUS AS "Centro de Resultado",
       TOP.CODTIPOPER AS "Tipo de Operação",
       EMP.CODEMP AS "Empresa ID",
       EMP.RAZAOSOCIAL AS "Empresa",
       TIT.CODTIPTIT AS "Tipo de Título ID",
       TIT.DESCRTIPTIT AS "Tipo de Título",
       FIN.PROVISAO AS "Provisão ID",
       CASE
           WHEN FIN.PROVISAO = 'N' THEN 'Não'
           ELSE 'Sim'
       END AS "Provisão",
       CASE
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) >= 0 THEN 1
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) BETWEEN -7 AND -1 THEN 2
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) BETWEEN -15 AND -8 THEN 3
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) BETWEEN -30 AND -16 THEN 4
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) < -30 THEN 5
       END AS "Status ID",
       CASE
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) >= 0 THEN 'Em Dia'
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) BETWEEN -7 AND -1 THEN 'Venceu nos últimos 7 Dias'
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) BETWEEN -15 AND -8 THEN 'Venceu nos últimos 15 Dias'
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) BETWEEN -30 AND -16 THEN 'Venceu nos últimos 30 Dias'
           WHEN TRUNC(FIN.DTVENC - SYSDATE, 0) < -30 THEN 'Venceu a mais de 30 Dias'
       END AS "Status",
       FIN.RECDESP AS "Recdesp ID",
       CASE
           WHEN FIN.RECDESP = 1 THEN 'Receita'
           WHEN FIN.RECDESP = -1 THEN 'Despesa'
           ELSE 'N/A'
       END AS "Recdesp",
       NUFIN AS "Nufin ID",
       NUFIN AS "Nufin",
       NULL AS "Recebidos",
       NULL AS "Pagos",
       (CASE
          WHEN RECDESP = 1 THEN VLRDESDOB
         END) AS "A Receber",
       (CASE
          WHEN RECDESP = -1 THEN VLRDESDOB
        END) AS "A Pagar"
FROM TGFFIN FIN
LEFT JOIN TGFPAR PAR ON PAR.CODPARC = FIN.CODPARC
LEFT JOIN TGFNAT NAT ON NAT.CODNAT = FIN.CODNAT
LEFT JOIN TSICUS CUS ON CUS.CODCENCUS = FIN.CODCENCUS
LEFT JOIN TSIEMP EMP ON EMP.CODEMP = FIN.CODEMP
LEFT JOIN TGFTOP TOP ON TOP.CODTIPOPER = FIN.CODTIPOPER
AND FIN.DHTIPOPER = TOP.DHALTER
LEFT JOIN TGFTIT TIT ON TIT.CODTIPTIT = FIN.CODTIPTIT
LEFT JOIN TSICTA CTA ON CTA.CODCTABCOINT = FIN.CODCTABCOINT
WHERE FIN.DHBAIXA IS NULL
    AND TO_CHAR(DTVENC, 'YYYY') <= 2030 
    AND FIN.NUANTBANC IS NULL/*TITULOS EM ABERTO*/
