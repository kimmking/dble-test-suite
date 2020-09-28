# Copyright (C) 2016-2020 ActionTech.
# License: https://www.mozilla.org/en-US/MPL/2.0 MPL version 2 or higher.
# update by quexiuping at 2020/8/26

Feature:  dble_status test
   Scenario:  dble_status table #1
  #case desc dble_status
   Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_1"
      | conn   | toClose | sql                 | db               |
      | conn_0 | False   | desc dble_status    | dble_information |
   Then check resultset "dble_status_1" has lines with following column values
      | Field-0        | Type-1       | Null-2 | Key-3 | Default-4 | Extra-5 |
      | variable_name  | varchar(24)  | NO     | PRI   | None      |         |
      | variable_value | varchar(20)  | NO     |       | None      |         |
      | comment        | varchar(200) | YES    |       | None      |         |
   #case select * from dble_status
   Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_2"
      | conn   | toClose | sql                       | db                |
      | conn_0 | False   | select * from dble_status | dble_information  |
   Then check resultset "dble_status_2" has lines with following column values
      | variable_name-0         | comment-2                                                                                                          |
      | uptime                  | length of time to start dble                                                                                       |
      | current_timestamp       | the current time of the dble system                                                                                |
      | startup_timestamp       | dble system startup time                                                                                           |
      | config_reload_timestamp | last config load time                                                                                              |
      | heap_memory_max         | the maximum amount of memory that the virtual machine will attempt to use, measured in bytes                       |
      | heap_memory_used        | heap memory usage, measured in bytes                                                                               |
      | heap_memory_total       | the total of heap memory, measured in bytes                                                                        |
      | direct_memory_max       | max direct memory, measured in bytes                                                                               |
      | direct_memory_pool_size | size of the memory pool, is equal to the product of BufferPoolPagesize and BufferPoolPagenumber, measured in bytes |
      | direct_memory_pool_used | directmemory memory in the memory pool that has been used, measured in bytes                                       |
      | questions               | number of requests                                                                                                 |
      | transactions            | number of transactions                                                                                             |

   Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_3"
      | conn   | toClose | sql                                                                             | db               |
      | conn_0 | False   | select variable_value from dble_status where variable_name ='startup_timestamp' |dble_information  |
   Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_4"
      | conn   | toClose | sql                   | db               |
      | conn_0 | False   |show @@time.startup    | dble_information |
   Then check resultsets "dble_status_3" and "dble_status_4" are same in following columns
      |column          | column_index |
      |variable_value  | 0            |

   #case select limit/order by/where like
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                    | expect                                                                 |
      | conn_0 | False   | use dble_information                                                                   | success                                                                |
      | conn_0 | False   | select * from dble_status limit 5                                                      | length{(5)}                                                            |
      | conn_0 | False   | select * from dble_status order by variable_name desc limit 6                          | length{(6)}                                                            |
      | conn_0 | False   | select * from dble_status where comment in (select common from dble_status )           | get error call manager command Correlated Sub Queries is not supported |
      | conn_0 | False   | select * from dble_status where comment > any (select variable_name from dble_status ) | length{(12)}                                                           |
      | conn_0 | False   | select * from dble_status where comment like '%of%'                                    | length{(7)}                                                            |
      | conn_0 | False   | select comment from dble_status                                                        | length{(12)}                                                           |
  #case select max/min from
      | conn_0 | False   | select max(variable_name) from dble_status                                             | has{('uptime')}                                                        |
      | conn_0 | False   | select min(variable_name) from dble_status                                             | has{('config_reload_timestamp')}                                       |
  #case select field from
      | conn_0 | False   | select variable_name from dble_status where variable_value = '0'                       | has{(('questions',), ('transactions',))}                                    |
  #case update/delete
      | conn_0 | False   | delete from dble_status where variable_name='questions'                                | Access denied for table 'dble_status'   |
      | conn_0 | False   | update dble_status set comment='number of requests' where variable_value='0'           | Access denied for table 'dble_status'   |
      | conn_0 | False   | insert into dble_status values ('a','b','c')                                           | Access denied for table 'dble_status'   |

@skip

 Scenario:  check questions/transactions http://10.186.18.11/jira/browse/DBLE0REQ-67 #2
   Then execute sql in "dble-1" in "user" mode
      | conn   | toClose | sql                                                      |
      | conn_1 | False   | use schema1                                              |
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                     | expect                                             |
      | conn_0 | False   | use dble_information                                                                    | success                                            |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%' | has{(('questions', '1',), ('transactions', '1',))} |
  #case error sql
   Given prepare a thread execute sql "drop table if exist test" with "conn_1"
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '2',), ('transactions', '2',))}      |
  #case tx
   Then execute sql in "dble-1" in "user" mode
      | conn   | toClose | sql                                                      |
      | conn_1 | False   | drop table if exists test                                |
      | conn_1 | False   | create table test(id int,code int)                       |
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '4',), ('transactions', '4',))}      |
   Then execute sql in "dble-1" in "user" mode
      | conn   | toClose | sql                                                      |
      | conn_1 | False   | insert into test values (1,1),(2,2)                      |
      | conn_1 | False   | update test set code=3 where code=2                      |
      | conn_1 | False   | delete from test where code=3                            |
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '7',), ('transactions', '7',))}      |
  #case xa
#   Then execute sql in "dble-1" in "user" mode
#      | conn   | toClose | sql                                                      |
#      | conn_1 | False   | set autocommit=0                                         |
#      | conn_1 | False   | set xa=on                                                |
#   Then execute sql in "dble-1" in "admin" mode
#      | conn   | toClose | sql                                                                                       | expect                                                  |
#      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '9',), ('transactions', '9',))}      |
#   Then execute sql in "dble-1" in "user" mode
#      | conn   | toClose | sql                                                      |
#      | conn_1 | False   | insert into test values (2,2),(3,3)                      |
#      | conn_1 | False   | insert into test values (4,4),(5,5)                      |
#   Then execute sql in "dble-1" in "admin" mode
#      | conn   | toClose | sql                                                                                       | expect                                                  |
#      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '11',), ('transactions', '10',))}    |
#   Then execute sql in "dble-1" in "user" mode
#      | conn   | toClose | sql                                                      |
#      | conn_1 | False   | commit                                                   |
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '12',), ('transactions', '11',))}    |
   Then execute sql in "dble-1" in "user" mode
      | conn   | toClose | sql                                                      |
      | conn_1 | False   | insert into test values (6,6),(7,7)                      |
      | conn_1 | False   | delete from test where code>5                            |
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '14',), ('transactions', '12',))}    |
   Then execute sql in "dble-1" in "user" mode
      | conn   | toClose | sql                                                      |
      | conn_1 | False   | rollback                                                 |
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '15',), ('transactions', '13',))}    |
  #case reload
   Then execute admin cmd "reload @@config"
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '15',), ('transactions', '13',))}    |
   Then execute sql in "dble-1" in "user" mode
      | conn   | toClose | sql                                                      |
      | conn_1 | False   | set autocommit=1                                         |
      | conn_1 | False   | set xa=off                                               |
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '17',), ('transactions', '15',))}    |
  #case eixt
   Given prepare a thread execute sql "exit" with "conn_1"
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '18',), ('transactions', '16',))}    |
  #case different seesion
   Then execute sql in "dble-1" in "user" mode
      | conn   | toClose | sql                                                      |
      | conn_2 | False   | use schema1                                              |
   Then execute sql in "dble-1" in "admin" mode
      | conn   | toClose | sql                                                                                       | expect                                                  |
      | conn_0 | False   | select variable_name,variable_value from dble_status where variable_name like '%tions%'   | has{(('questions', '19',), ('transactions', '17',))}    |
   Given execute single sql in "dble-1" in "admin" mode and save resultset in "dble_status_5"
      | conn   | toClose | sql              | db                |
      | conn_0 | False   | show @@questions | dble_information  |
   Then check resultset "dble_status_5" has lines with following column values
      | Questions-0 | Transactions-1 |
      | 19          | 17             |
   Then execute sql in "dble-1" in "user" mode
      | conn   | toClose | sql                                                      |
      | conn_1 | False   | drop table if exists test                                |