-- Trasações abertas no banco

SELECT DB_NAME(dbid) AS dbname,
		cmd,
		nt_domain,
		nt_username,
		hostname,
		program_name
FROM master..sysprocesses 
WHERE open_tran > 0