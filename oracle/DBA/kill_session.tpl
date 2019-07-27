-- KILL SESSION
-- Namierzanie sesji
select * from v$session where v.status = 'ACTIVE' and v.username = 'ACACIA';

-- Szukanie procesu do ubicie
select 
s.username,
p.PID,
s.SID,
s.SERIAL#,
p.SPID -- on UNIX ps -afe | grep ora_* kill -9 SPID on the unix
from v$process p, v$session s
where p.addr = s.paddr
and s.sid = 0; -- SID z 1 zapytania

-- on UNIX 
-- ps -afe | grep ora_* 
-- kill -9 SPID 
