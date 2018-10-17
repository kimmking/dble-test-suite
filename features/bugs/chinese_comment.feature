# Created by zhaohongjie at 2018/9/20
Feature: verify issue http://10.186.18.21/universe/ushard/issues/92 #Enter feature name here
  # todo: the issue only occur under ushard ha env

  Scenario: #1 Enter scenario name here
    Given update file content "/opt/dble/conf/wrapper.conf" in "dble-1"

    """
    /additional.5/d
    /additional.4/a wrapper.java.additional.5=-Dfile.encoding=GBK
    """
    Given add xml segment to node with attribute "{'tag':'root'}" in "server.xml"
    """
    <system>
        <property name="charset">utf8mb4</property>
    </system>
    """
    Given add xml segment to node with attribute "{'tag':'schema','kv_map':{'name':'mytest'}}" in "schema.xml"
    """
        <table name="test_table" dataNode="dn1,dn2,dn3,dn4" primaryKey="id" rule="hash-four" />
    """
    Given Restart dble in "dble-1"
    Then execute sql in "dble-1" in "user" mode
        | user | passwd | conn   | toClose  | sql                             | expect       | db     |
        | test | 111111 | conn_0 | False    | drop table if exists test_table | success      | mytest |
        | test | 111111 | conn_0 | False    | create table test_table(`series` bigint(20) NOT NULL DEFAULT '1' COMMENT '行号',PRIMARY KEY (`series`)) DEFAULT CHARSET=utf8; | success  | mytest |
        | test | 111111 | conn_0 | True     | drop table test_table           | success       | mytest |


