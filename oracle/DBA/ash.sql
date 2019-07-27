
 
select to_char(v.SAMPLE_TIME, 'HH24 mi'), count(1) -- EXTRACT (HOUR FROM v.SAMPLE_TIME ), EXTRACT (MINUTE FROM v.SAMPLE_TIME )
from v$active_session_history v     
where trunc(v.SAMPLE_TIME) = to_date('2014-07-17','yyyy-mm-dd')
--and s.MODULE like 'C.%'
group by to_char(v.SAMPLE_TIME, 'HH24 mi')
order by to_char(v.SAMPLE_TIME, 'HH24 mi') desc;


select to_char(v.SAMPLE_TIME, 'yyyy-mm-dd HH24 mi'), v.* 
from v$active_session_history v
where v.program like 'oracle%' 
and v.P1 = 28 and v.P1TEXT = 'file number'
where  to_char(v.SAMPLE_TIME, 'yyyy-mm-dd HH24:mi') = '2014-07-15 21:27';

/*Returns most active SQL in the past minute */
SELECT sql_id, COUNT(*), round(COUNT(*) / SUM(COUNT(*)) over(), 2) pctload
  FROM v$active_session_history
 WHERE sample_time > SYSDATE - 1 / 24 / 60
       AND session_type <> 'background'
 GROUP BY sql_id
 ORDER BY COUNT(*) DESC;

/*
Returns SQL spending most time doing I/Osy Similarly, can do 
Top Sessions, Top Files, Top Objects
*/

SELECT ash.sql_id, COUNT(*)
  FROM v$active_session_history ash, v$event_name evt
 WHERE ash.sample_time > SYSDATE - 1 --/ 24 / 60
       AND ash.session_state = 'WAITING'
       AND ash.event_id = evt.event_id
       AND evt.wait_class = 'USER I/O'
 GROUP BY sql_id
 ORDER BY COUNT(*) DESC;


--Top CPU consuming Session in last 5 minutes? 

SELECT session_id, COUNT(*)
  FROM v$active_session_history
 WHERE session_state = 'ON CPU'
       AND sample_time > SYSDATE  - 1-- (5 / (24 * 60))
 GROUP BY session_id
 ORDER BY COUNT(*) DESC;

-- Top Waiting Session  in last 5 minutes
SELECT session_id, COUNT(*)
  FROM v$active_session_history
 WHERE session_state = 'WAITING'
       AND sample_time > SYSDATE - (5 / (24 * 60))
 GROUP BY session_id
 ORDER BY COUNT(*) DESC;


-- Top SQL by CPU usage, wait time and IO time
select
     ash.SQL_ID ,
     sum(decode(ash.session_state,'ON CPU',1,0))     "CPU",
     sum(decode(ash.session_state,'WAITING',1,0))    -
     sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    "WAIT" ,
     sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    "IO" ,
     sum(decode(ash.session_state,'ON CPU',1,1))     "TOTAL"
from v$active_session_history ash,
         v$event_name en
where SQL_ID is not NULL  and en.event#=ash.event#
group by sql_id
order by sum(decode(session_state,'ON CPU',1,1))   desc;


-- Top SESSION by CPU usage, wait time and IO time
select
     ash.session_id,
     ash.session_serial#,
     ash.user_id,
     ash.program,
     sum(decode(ash.session_state,'ON CPU',1,0))     "CPU",
     sum(decode(ash.session_state,'WAITING',1,0))    -
     sum(decode(ash.session_state,'WAITING',
        decode(en.wait_class,'User I/O',1, 0 ), 0))    "WAITING" ,
     sum(decode(ash.session_state,'WAITING',
        decode(en.wait_class,'User I/O',1, 0 ), 0))    "IO" ,
     sum(decode(session_state,'ON CPU',1,1))     "TOTAL"
from v$active_session_history ash,
        v$event_name en
where en.event# = ash.event#
group by session_id,user_id,session_serial#,program
order by sum(decode(session_state,'ON CPU',1,1));