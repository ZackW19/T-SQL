-- ***************************************
-- List all user databases with their size 
-- ***************************************

SELECT
DB_NAME(sdb.database_id) DatabaseName,
(CAST(mfrows.RowSize AS FLOAT)*8)/1024 [DB (mdf) Size MB],
(CAST(mflog.LogSize AS FLOAT)*8)/1024 [Log (ldf) Size MB]
FROM sys.databases sdb
LEFT JOIN (SELECT database_id, SUM(size) RowSize FROM sys.master_files WHERE type = 0 GROUP BY database_id, type) mfrows ON mfrows.database_id = sdb.database_id
LEFT JOIN (SELECT database_id, SUM(size) LogSize FROM sys.master_files WHERE type = 1 GROUP BY database_id, type) mflog ON mflog.database_id = sdb.database_id
where DB_NAME(sdb.database_id) not like 'master'
and DB_NAME(sdb.database_id) not like 'msdb'
and DB_NAME(sdb.database_id) not like 'model'
and DB_NAME(sdb.database_id) not like 'tempdb'

order by DB_NAME(sdb.database_id)