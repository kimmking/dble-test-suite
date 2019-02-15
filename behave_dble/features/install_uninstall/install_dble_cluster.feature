# Created by yexiaoli at 2018/12/13
Feature: install_dble_cluster.feature:to config dble in zk cluster

  @skip_restart
  Scenario: install zk cluster
    Given stop dble cluster and zk service
    Given a clean environment in all dble nodes
    Given install dble in all dble nodes
    Given replace config files in all dbles with command line config
    Given config zookeeper cluster in all dble nodes
    Given reset dble registered nodes in zk
    Then start dble in order