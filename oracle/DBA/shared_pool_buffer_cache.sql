-- shared_pool / buffer_cache
alter system flush shared_pool;
alter system flush buffer_cache;

select a.file_name, b.PHYRDS, b.PHYBLKRD
  from sys.dba_data_files a, v$filestat b
 where a.file_id = b.FILE#
 order by a.file_id;

select round(v.BYTES / 1024/1024,2) "MB", v.*
from v$sgastat v
where v.NAME = 'free memory'
 and pool = 'shared pool';
 
 
select
 v.COMPONENT,
 round(v.CURRENT_SIZE /1024/2014,2) "MB" ,
 round(v.MAX_SIZE /1024/2014,2) "MAX_MB",
 round(v.MIN_SIZE /1024/2014,2) "MIN_MB",
 v.LAST_OPER_TYPE,
 v.LAST_OPER_MODE,
 v.LAST_OPER_TIME
from v$sga_dynamic_components v; 

select round(CURRENT_SIZE /1024/1024,2) "MB" from v$sga_dynamic_free_memory;

select count(1)
from v$sqlarea
order by disk_reads;

select v.EXECUTIONS, v.BUFFER_GETS, v.DISK_READS, v.FIRST_LOAD_TIME, v.SQL_TEXT
from v$sqlarea v
order by v.disk_reads;

select (p1.VALUE + p2.VALUE - p3.VALUE), (p1.VALUE + p2.VALUE), (p1.VALUE + p2.VALUE - p3.VALUE) / (p1.VALUE + p2.VALUE)
from v$sysstat p1, v$sysstat p2, v$sysstat p3
where p1.NAME = 'db block gets'
and p2.NAME = 'consistent gets'
and p3.NAME = 'physical reads';

select *
from v$parameter v
where v.name in
('shared_pool_size','buffer_pool_keep','buffer_pool_recycle');

