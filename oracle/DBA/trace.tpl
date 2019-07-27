-- namierzenie sesji w
select * from v$session;

-- uruchimienie trace
begin dbms_monitor.session_trace_enable(#sid, #serial_number)  end;

-- sprawdzenie nazwy naszego trace'a
select * from v$diag_info;
-- lub
select u_dump.value || '/' || db_name.value || 'ora' || v$process.spid ||
       nvl2(v$process.traceid, '_' || v$process.traceid, null) || '.trc' "Trace File"
  from v$parameter u_dump
 cross join v$parameter db_name
 cross join v$process
  join v$session
    on v$process.addr = v$session.paddr
 where u_dump.name = 'user_dump_dest'
   and db_name.name = 'db_name'
   and v$session.audsid = sys_context('userenv', 'sessionid');

-- Kopiowanie tracow z serwera, admini lub samemu do katalogu gdzie ma sie dostep
declare
   file1 utl_file.file_type;
begin
 file1 := utl_file.fopen('DIR_TRC_SOURCE','&nazwa_trace.trc','a');
 utl_file.fclose(file1);
 utl_file.fcopy('DIR_TRC_SOURCE','&nazwa_trace.trc','DIR_TRC_DEST','&nazwa_trace.trc');
end;

-- Obrobka tkprof'em, przy robieniu trace mozna zapytani otagowac a plik wyjsciowy trc nazwa po swojemu [TK-EOBD]
tkprof nazwa_tace.trc plik_wyjsciowy explain=acacia/acacia#acacia
-- mozna posortowac exeela, fchela czy inne

-- Obrobka ORASRP

-- Przeglac traca wyjsciowego

