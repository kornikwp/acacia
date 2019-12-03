select used.tablespace_name,
       round((reserv.maxbytes - used.bytes) * 100 / reserv.maxbytes,2) "Free space [%]",
       round(used.bytes / 1024 / 1024 / 1024,2) used_gb,
       round(reserv.maxbytes / 1024 / 1024 / 1024,2) max_gb,
       round((reserv.maxbytes - used.bytes) / 1024 / 1024 / 1024,2) "free_GB",
       reserv.datafiles
  from (select tablespace_name,
               count(1) datafiles,
               sum(greatest(maxbytes, bytes)) maxbytes,
               sum(bytes) bytes
          from dba_data_files
         group by tablespace_name) reserv,
       (select tablespace_name, sum(bytes) bytes
          from dba_segments
         group by tablespace_name) used
 where used.tablespace_name = reserv.tablespace_name
 order by 2
