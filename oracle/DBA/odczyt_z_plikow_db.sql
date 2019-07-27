-- ~ 3-4% => OK, > 10% WRN, > 30% ERR!!
select      NAME,
     PHYRDS "Physical Reads",
     round((PHYRDS / PD.PHYS_READS)*100,2) "Read %",
     PHYWRTS "Physical Writes",
     round(PHYWRTS * 100 / PD.PHYS_WRTS,2) "Write %",
     fs.PHYBLKRD+FS.PHYBLKWRT "Total Block I/O's"
from (
     select      sum(PHYRDS) PHYS_READS,
          sum(PHYWRTS) PHYS_WRTS
     from      v$filestat
     ) pd,
     v$datafile df,
     v$filestat fs
where      df.FILE# = fs.FILE#
order      by fs.PHYBLKRD+fs.PHYBLKWRT desc;