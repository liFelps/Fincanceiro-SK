SELECT NAT.CODNAT AS "Natureza NV1_ID",
       NAT.DESCRNAT AS "Natureza NV1",
       NAT2.CODNAT AS "Natureza NV2 ID",
       NAT2.DESCRNAT AS "Natureza NV2",
       NAT3.CODNAT AS "Natureza NV3 ID",
       NAT3.DESCRNAT AS "Natureza NV3",
       NAT4.CODNAT AS "Natureza NV4 ID",
       NAT4.DESCRNAT AS "Natureza NV4"
FROM TGFNAT NAT
LEFT JOIN TGFNAT NAT2 ON trunc(NAT.CODNAT,-2) = NAT2.CODNAT
LEFT JOIN TGFNAT NAT3 ON trunc(NAT.CODNAT,-4) = NAT3.CODNAT
LEFT JOIN TGFNAT NAT4 ON trunc(NAT.CODNAT,-5) = NAT4.CODNAT
