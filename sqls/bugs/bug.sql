#github issue #599
drop table if exists a_two
CREATE TABLE a_two (id int(11) NOT NULL,c_flag char(255) DEFAULT NULL,c_decimal decimal(16,4) DEFAULT NULL,PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8
SELECT a.id, sum(a.c_decimal) AS c_decimal FROM a_two a GROUP BY a.id HAVING sum(a.c_decimal) != 0
#github issue #600
drop table if exists test1
drop table if exists test2
CREATE TABLE test1 (id bigint(11) NOT NULL,c_char char(255) DEFAULT NULL,PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8
CREATE TABLE test2 (id bigint(11) NOT NULL,c_char char(255) DEFAULT NULL,PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8
insert into test1 values(1,'1')
insert into test1(id) values(2)
insert into test2 values(1,'1')
insert into test2(id) values(2)
select * from test1 a inner join test2 b on a.c_char =b.c_char order by a.id
select * from test1 a right join test2 b on a.c_char =b.c_char order by a.id
select * from test1 a left join test2 b on a.c_char =b.c_char order by a.id
#case from gonghang
drop table if exists a_test
drop table if exists a_order
create table a_test(id int, trancode varchar(20), RETCODE char(2), OAPP varchar(20))
create table a_order(id int, trancode varchar(20), RETCODE char(2), OAPP varchar(20))
#!multiline
SELECT COUNT(*) FROM (
     select test1.*
     from mytest.a_test test1
     where test1.trancode = 'ATS000010CHGEBUSSPTBNK'
     AND test1.RETCODE = '0'
     AND test1.OAPP != 'F-CLMS'

     UNION

     SELECT test2.*
     FROM mytest.a_order test2
     WHERE test2.trancode = 'ATS000008QRYBUSSPTGIFTLIST'
     AND test2.RETCODE = '0'
     AND test2.OAPP != 'F-CLMS'
     ) t3
#end multiline
#github issue 581
drop table if exists a_test
drop table if exists a_order
drop table if exists a_manager
drop table if exists test_global
create table a_test(id int primary key,name varchar(10))
create table a_order(id int primary key,name varchar(10))
create table a_manager(id int primary key,name varchar(10))
create table test_global(id int primary key,name varchar(10))
insert into a_test values(1,'actiontech')
insert into a_order values(1,'actiontech')
insert into a_manager values(1,'actiontech')
insert into test_global values(1,'actiontech')
select a.id,a.name from a_test a join a_order b where a.id=b.id union  select id,name from a_manager
select id,concat(id,'_',name)from a_test union all select id,concat(id,'_',name)from a_test
select a.id,concat(a.id,'_',a.name) from a_test a join a_order b where a.id=b.id union  select id,concat(id,'_',name)from a_manager
select 1 union select id from a_test
select id from a_test union select 1
select 1 union select id from test_global
select id from test_global union SELECT 1
#github issue 537
drop table if exists test_shard
create table test_shard (id int(11) primary key,R_REGIONKEY float,R_NAME varchar(50),R_COMMENT varchar(50))
insert into test_shard (id,R_REGIONKEY,R_NAME,R_COMMENT) values (1,1, 'a string','test001'),(3,3, 'another string','test003'),(2,2, 'a\nstring','test002'),(4,4, '中','test004'),(5,5, 'a\'string\'','test005'),(6,6, 'a\""string\""','test006'),(7,7, 'a\bstring','test007'),(8,8, 'a\nstring','test008'),(9,9, 'a\rstring','test009'),(10,10, 'a\tstring','test010'),(11,11, 'a\zstring','test011'),(12,12, 'a\\string','test012'),(13,13, 'a\%string','test013'),(14,14, 'a\_string','test014'),(15,15, 'MySQL','test015'),(16,16, 'binary','test016'),(65,16, 'binary','test016'),(17,12345678901234567890123.4567890,17,17),(18,18, 'A','test018'),(19,19, '','test019')
explain(select 1 from test_shard)union(select 2)/*allow_diff*/
explain (select 1 from test_shard)union(select 2)/*allow_diff*/