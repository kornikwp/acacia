-- create user    
CREATE USER acacia 
default tablespace ACACIA_DATA
temporary tablespace TEMP
IDENTIFIED BY acacia;

GRANT dba TO acacia WITH ADMIN OPTION;
