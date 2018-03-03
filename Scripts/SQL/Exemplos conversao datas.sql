------------------------------------------------------------------------------------------
Format #	| Query (current date: 12/30/2006)				|Sample			
------------------------------------------------------------------------------------------
1			| select convert(varchar, getdate(), 1)		|12/30/06
2			| select convert(varchar, getdate(), 2)		|06.12.30
3			| select convert(varchar, getdate(), 3)		|30/12/06
4			| select convert(varchar, getdate(), 4)		|30.12.06
5			| select convert(varchar, getdate(), 5)		|30-12-06
6			| select convert(varchar, getdate(), 6)		|30 Dec 06
7			| select convert(varchar, getdate(), 7)		|Dec 30, 06
10			| select convert(varchar, getdate(), 10)	|12-30-06
11			| select convert(varchar, getdate(), 11)	|06/12/30
101			| select convert(varchar, getdate(), 101)	|12/30/2006
102			| select convert(varchar, getdate(), 102)	|2006.12.30
103			| select convert(varchar, getdate(), 103)	|30/12/2006
104			| select convert(varchar, getdate(), 104)	|30.12.2006
105			| select convert(varchar, getdate(), 105)	|30-12-2006
106			| select convert(varchar, getdate(), 106)	|30 Dec 2006
107			| select convert(varchar, getdate(), 107)	|Dec 30, 2006
110			| select convert(varchar, getdate(), 110)	|12-30-2006
111			| select convert(varchar, getdate(), 111)	|2006/12/30
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
8 or 108	|  select convert(varchar, getdate(), 8)	|00:38:54
9 or 109	|  select convert(varchar, getdate(), 9)	|Dec 30 2006 12:38:54:840AM
14 or 114	|  select convert(varchar, getdate(), 14)	|00:38:54:840
-------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------
Sample statement																									|Output
-----------------------------------------------------------------------------------------------------------------------------------
select replace(convert(varchar, getdate(),101),'/','')															|12302006
select replace(convert(varchar, getdate(),101),'/','') + replace(convert(varchar, getdate(),108),':','')	|12302006004426
-----------------------------------------------------------------------------------------------------------------------------------


