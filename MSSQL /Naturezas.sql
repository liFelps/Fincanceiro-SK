SELECT 
    NAT.CODNAT AS "ID Natureza NV1",
    NAT.DESCRNAT AS "Natureza NV1",
    NAT2.CODNAT AS "ID Natureza NV2",
    NAT2.DESCRNAT AS "Natureza NV2",
    NAT3.CODNAT AS "ID Natureza NV3",
    NAT3.DESCRNAT AS "Natureza NV3",
    NAT4.CODNAT AS "ID Natureza NV4",
    NAT4.DESCRNAT AS "Natureza NV4"
FROM TGFNAT NAT
LEFT JOIN TGFNAT NAT2 ON CAST(FLOOR(NAT.CODNAT / 100) * 100 AS INT) = NAT2.CODNAT
LEFT JOIN TGFNAT NAT3 ON CAST(FLOOR(NAT.CODNAT / 10000) * 10000 AS INT) = NAT3.CODNAT
LEFT JOIN TGFNAT NAT4 ON CAST(FLOOR(NAT.CODNAT / 100000) * 100000 AS INT) = NAT4.CODNAT
