-- Traz as refer�ncias de chave da table
SELECT * 
FROM sys.foreign_keys
WHERE referenced_object_id = object_id('[tbBR_tab_Arquivo]')


-- Gera o SQL din�mico com dos drops das constraints
SELECT 
    'ALTER TABLE ' +  OBJECT_SCHEMA_NAME(parent_object_id) +
    '.[' + OBJECT_NAME(parent_object_id) + 
    '] DROP CONSTRAINT ' + name
FROM sys.foreign_keys
WHERE referenced_object_id = object_id('tbBR_tab_Arquivo')