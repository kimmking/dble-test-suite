#!default_db:schema1
##case1::Functions Used with Global Transaction IDs
SELECT GTID_SUBSET('3E11FA47-71CA-11E1-9E33-C80AA9429562:23','3E11FA47-71CA-11E1-9E33-C80AA9429562:21-57')
SELECT GTID_SUBTRACT('3E11FA47-71CA-11E1-9E33-C80AA9429562:21-57','3E11FA47-71CA-11E1-9E33-C80AA9429562:21')
##case2::Miscellaneous Functions
SELECT GET_LOCK('lock1',10)
SELECT RELEASE_LOCK('lock2') 
SELECT INET_ATON('10.0.5.9') 
SELECT INET_NTOA(167773449) 
SELECT HEX(INET6_ATON(INET_NTOA(167773449))) 
select IS_FREE_LOCK('abc')
SELECT IS_IPV4('10.0.5.9'), IS_IPV4('10.0.5.256') 
SELECT IS_IPV4_COMPAT(INET6_ATON('::10.0.5.9')) 
SELECT HEX(INET6_ATON('192.168.0.1')) 
select IS_IPV4_COMPAT(INET6_ATON('::192.168.0.1')) 
SELECT IS_IPV4_MAPPED(INET6_ATON('::10.0.5.9')) 
SELECT IS_IPV6('10.0.5.9'), IS_IPV6('::1') 
select IS_USED_LOCK('abc') 
SELECT NAME_CONST('myname', 14)
#RELEASE_ALL_LOCKS sent to default node if exists
SELECT RELEASE_ALL_LOCKS()/*allow_diff*/
SELECT SLEEP(1) 
SELECT /*+ MAX_EXECUTION_TIME(1) */ SLEEP(1000) 
SELECT UUID() 
SELECT UUID_SHORT()