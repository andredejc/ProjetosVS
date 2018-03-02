-------------------------------------------------
-- TABELAS
-------------------------------------------------

use master
go

declare 
	@base nvarchar(100),
	@tabela nvarchar(100) = 'ClienteEndereco',	
	@sql nvarchar(max),
	@nomeIgual bit = 1 -- 1 - nome = '' / ELSE - nome LIKE '%%'	

if object_id('tempdb..##infoTabela','U') is not null begin
	drop table ##infoTabela
end

create table ##infoTabela ( base varchar(100), tabela varchar(100), coluna varchar(100) )

declare cur cursor for
select name
from sys.databases 
where name not in ( 'master' ,'tempdb' ,'model' ,'msdb' ,'ReportServer' ,'ReportServerTempDB' )

open cur
fetch next from cur into @base

while @@fetch_status = 0
begin	

	if ( select has_dbaccess(@base) ) = 1 begin
		if @nomeIgual = 1 begin
			set @sql = 'use ' + @base + char(10) 
				set @sql += '
						insert into ##infoTabela
						select ' + quotename(@base,'''') + ' as banco, c.name + ''.'' + a.name, b.name
						from sys.tables as a
							inner join sys.columns as b
								on a.object_id = b.object_id
							inner join sys.schemas as c
								on a.schema_id = c.schema_id
						where a.name = ' + '''' + @tabela + '''
					'		
				execute ( @sql )
		end	else begin
			set @sql = 'use ' + @base + char(10) 
			set @sql += '
					insert into ##infoTabela
					select ' + quotename(@base,'''') + ' as banco, c.name + ''.'' + a.name, b.name
					from sys.tables as a
						inner join sys.columns as b
							on a.object_id = b.object_id
						inner join sys.schemas as c
							on a.schema_id = c.schema_id
					where a.name like ' + '''%' + @tabela + '%''
				'		
			execute ( @sql )
		end
	end

	fetch next from cur into @base
end
close cur
deallocate cur;

select distinct base, tabela from ##infoTabela order by 1
drop table ##infoTabela


-------------------------------------------------
-- COLUNAS
-------------------------------------------------

use master
go

declare 
	@base nvarchar(100),
	@tabela nvarchar(100),
	@coluna nvarchar(100) = 'sig_life_sun_key_id',
	@sql nvarchar(max),
	@nomeIgual bit = 1 -- 1 - nome = '' / ELSE - nome LIKE '%%'	

if object_id('tempdb..##infoColuna','U') is not null begin
	drop table ##infoColuna
end

create table ##infoColuna ( base varchar(100), tabela varchar(100), coluna varchar(100) )

declare cur cursor for
select name
from sys.databases 
where name not in ( 'master' ,'tempdb' ,'model' ,'msdb' ,'ReportServer' ,'ReportServerTempDB' )

open cur
fetch next from cur into @base

while @@fetch_status = 0
begin	

	if ( select has_dbaccess(@base) ) = 1 begin
		if @nomeIgual = 1 begin
			set @sql = 'use ' + @base + char(10) 
				set @sql += '
						insert into ##infoColuna
						select ' + quotename(@base,'''') + ' as banco, c.name + ''.'' + a.name, b.name
						from sys.tables as a
							inner join sys.columns as b
								on a.object_id = b.object_id
							inner join sys.schemas as c
								on a.schema_id = c.schema_id
						where b.name = ' + '''' + @coluna + '''
					'		
				execute ( @sql )
		end	else begin
			set @sql = 'use ' + @base + char(10) 
			set @sql += '
					insert into ##infoColuna
					select ' + quotename(@base,'''') + ' as banco, c.name + ''.'' + a.name, b.name
					from sys.tables as a
						inner join sys.columns as b
							on a.object_id = b.object_id
						inner join sys.schemas as c
							on a.schema_id = c.schema_id
					where b.name like ' + '''%' + @coluna + '%''
				'		
			execute ( @sql )
		end
	end

	fetch next from cur into @base
end
close cur
deallocate cur;

select * from ##infoColuna
drop table ##infoColuna



