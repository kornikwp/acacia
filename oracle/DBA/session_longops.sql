select cast(round((lo.SOFAR / lo.totalwork) * 100, 2) as number(18, 3)) || ' %' as "Procent",
       case
         when lo.TIME_REMAINING < 60 then
          floor(lo.TIME_REMAINING / 3600) || ' h ' ||
          floor(mod(lo.TIME_REMAINING / 3600, 1) * 60) || ' m. ' ||
          lo.TIME_REMAINING || 's.'
         else
          floor(lo.TIME_REMAINING / 3600) || ' h ' ||
          floor(mod(lo.TIME_REMAINING / 3600, 1) * 60) || ' m. ' ||
          (lo.TIME_REMAINING -
           floor(mod(lo.TIME_REMAINING / 3600, 1) * 60) * 60) || 's.'
       end "Pozostalo czasu",
       lo.TARGET "Cel",
       lo.OPNAME "OpName",
       vs.USERNAME "User",
       lo.TOTALWORK - lo.SOFAR "Poz. bloki",
       lo.TOTALWORK "Praca",
       vs.EVENT "Event",
       vs.STATE "State",
       sq.SQL_FULLTEXT "SQL",
       lo.START_TIME "Start"
  from v$session_longops lo
  left join v$session vs
    on vs.sid = lo.sid
  left join v$sql sq
    on sq.sql_id = lo.SQL_ID
 where lo.TIME_REMAINING > 0
   and vs.STATUS = 'ACTIVE'
 order by lo.SID desc;
