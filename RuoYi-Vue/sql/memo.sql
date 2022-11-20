DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
CREATE TABLE QRTZ_JOB_DETAILS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    job_name             VARCHAR(200)    NOT NULL            COMMENT '任务名称',
    job_group            VARCHAR(200)    NOT NULL            COMMENT '任务组名',
    description          VARCHAR(250)    NULL                COMMENT '相关介绍',
    job_class_name       VARCHAR(250)    NOT NULL            COMMENT '执行任务类名称',
    is_durable           VARCHAR(1)      NOT NULL            COMMENT '是否持久化',
    is_nonconcurrent     VARCHAR(1)      NOT NULL            COMMENT '是否并发',
    is_update_data       VARCHAR(1)      NOT NULL            COMMENT '是否更新数据',
    requests_recovery    VARCHAR(1)      NOT NULL            COMMENT '是否接受恢复执行',
    job_data             BLOB            NULL                COMMENT '存放持久化job对象',
    PRIMARY KEY (sched_name, job_name, job_group)
) ENGINE=INNODB COMMENT = '任务详细信息表';

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
CREATE TABLE QRTZ_TRIGGERS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    trigger_name         VARCHAR(200)    NOT NULL            COMMENT '触发器的名字',
    trigger_group        VARCHAR(200)    NOT NULL            COMMENT '触发器所属组的名字',
    job_name             VARCHAR(200)    NOT NULL            COMMENT 'qrtz_job_details表job_name的外键',
    job_group            VARCHAR(200)    NOT NULL            COMMENT 'qrtz_job_details表job_group的外键',
    description          VARCHAR(250)    NULL                COMMENT '相关介绍',
    next_fire_time       BIGINT(13)      NULL                COMMENT '上一次触发时间（毫秒）',
    prev_fire_time       BIGINT(13)      NULL                COMMENT '下一次触发时间（默认为-1表示不触发）',
    priority             INTEGER         NULL                COMMENT '优先级',
    trigger_state        VARCHAR(16)     NOT NULL            COMMENT '触发器状态',
    trigger_type         VARCHAR(8)      NOT NULL            COMMENT '触发器的类型',
    start_time           BIGINT(13)      NOT NULL            COMMENT '开始时间',
    end_time             BIGINT(13)      NULL                COMMENT '结束时间',
    calendar_name        VARCHAR(200)    NULL                COMMENT '日程表名称',
    misfire_instr        SMALLINT(2)     NULL                COMMENT '补偿执行的策略',
    job_data             BLOB            NULL                COMMENT '存放持久化job对象',
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, job_name, job_group) REFERENCES QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
) ENGINE=INNODB COMMENT = '触发器详细信息表';

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
CREATE TABLE QRTZ_SIMPLE_TRIGGERS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    trigger_name         VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_name的外键',
    trigger_group        VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_group的外键',
    repeat_count         BIGINT(7)       NOT NULL            COMMENT '重复的次数统计',
    repeat_interval      BIGINT(12)      NOT NULL            COMMENT '重复的间隔时间',
    times_triggered      BIGINT(10)      NOT NULL            COMMENT '已经触发的次数',
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) ENGINE=INNODB COMMENT = '简单触发器的信息表';

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ---------------------------- 
CREATE TABLE QRTZ_CRON_TRIGGERS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    trigger_name         VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_name的外键',
    trigger_group        VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_group的外键',
    cron_expression      VARCHAR(200)    NOT NULL            COMMENT 'cron表达式',
    time_zone_id         VARCHAR(80)                         COMMENT '时区',
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) ENGINE=INNODB COMMENT = 'Cron类型的触发器表';

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ---------------------------- 
CREATE TABLE QRTZ_BLOB_TRIGGERS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    trigger_name         VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_name的外键',
    trigger_group        VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_group的外键',
    blob_data            BLOB            NULL                COMMENT '存放持久化Trigger对象',
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) ENGINE=INNODB COMMENT = 'Blob类型的触发器表';

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ---------------------------- 
CREATE TABLE QRTZ_CALENDARS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    calendar_name        VARCHAR(200)    NOT NULL            COMMENT '日历名称',
    calendar             BLOB            NOT NULL            COMMENT '存放持久化calendar对象',
    PRIMARY KEY (sched_name, calendar_name)
) ENGINE=INNODB COMMENT = '日历信息表';

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ---------------------------- 
CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    trigger_group        VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_group的外键',
    PRIMARY KEY (sched_name, trigger_group)
) ENGINE=INNODB COMMENT = '暂停的触发器表';

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ---------------------------- 
CREATE TABLE QRTZ_FIRED_TRIGGERS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    entry_id             VARCHAR(95)     NOT NULL            COMMENT '调度器实例id',
    trigger_name         VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_name的外键',
    trigger_group        VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_group的外键',
    instance_name        VARCHAR(200)    NOT NULL            COMMENT '调度器实例名',
    fired_time           BIGINT(13)      NOT NULL            COMMENT '触发的时间',
    sched_time           BIGINT(13)      NOT NULL            COMMENT '定时器制定的时间',
    priority             INTEGER         NOT NULL            COMMENT '优先级',
    state                VARCHAR(16)     NOT NULL            COMMENT '状态',
    job_name             VARCHAR(200)    NULL                COMMENT '任务名称',
    job_group            VARCHAR(200)    NULL                COMMENT '任务组名',
    is_nonconcurrent     VARCHAR(1)      NULL                COMMENT '是否并发',
    requests_recovery    VARCHAR(1)      NULL                COMMENT '是否接受恢复执行',
    PRIMARY KEY (sched_name, entry_id)
) ENGINE=INNODB COMMENT = '已触发的触发器表';

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ---------------------------- 
CREATE TABLE QRTZ_SCHEDULER_STATE (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    instance_name        VARCHAR(200)    NOT NULL            COMMENT '实例名称',
    last_checkin_time    BIGINT(13)      NOT NULL            COMMENT '上次检查时间',
    checkin_interval     BIGINT(13)      NOT NULL            COMMENT '检查间隔时间',
    PRIMARY KEY (sched_name, instance_name)
) ENGINE=INNODB COMMENT = '调度器状态表';

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ---------------------------- 
CREATE TABLE QRTZ_LOCKS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    lock_name            VARCHAR(40)     NOT NULL            COMMENT '悲观锁名称',
    PRIMARY KEY (sched_name, lock_name)
) ENGINE=INNODB COMMENT = '存储的悲观锁信息表';

-- ----------------------------
-- 11、 Quartz集群实现同步机制的行锁表
-- ---------------------------- 
CREATE TABLE QRTZ_SIMPROP_TRIGGERS (
    sched_name           VARCHAR(120)    NOT NULL            COMMENT '调度名称',
    trigger_name         VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_name的外键',
    trigger_group        VARCHAR(200)    NOT NULL            COMMENT 'qrtz_triggers表trigger_group的外键',
    str_prop_1           VARCHAR(512)    NULL                COMMENT 'String类型的trigger的第一个参数',
    str_prop_2           VARCHAR(512)    NULL                COMMENT 'String类型的trigger的第二个参数',
    str_prop_3           VARCHAR(512)    NULL                COMMENT 'String类型的trigger的第三个参数',
    int_prop_1           INT             NULL                COMMENT 'int类型的trigger的第一个参数',
    int_prop_2           INT             NULL                COMMENT 'int类型的trigger的第二个参数',
    long_prop_1          BIGINT          NULL                COMMENT 'long类型的trigger的第一个参数',
    long_prop_2          BIGINT          NULL                COMMENT 'long类型的trigger的第二个参数',
    dec_prop_1           NUMERIC(13,4)   NULL                COMMENT 'decimal类型的trigger的第一个参数',
    dec_prop_2           NUMERIC(13,4)   NULL                COMMENT 'decimal类型的trigger的第二个参数',
    bool_prop_1          VARCHAR(1)      NULL                COMMENT 'Boolean类型的trigger的第一个参数',
    bool_prop_2          VARCHAR(1)      NULL                COMMENT 'Boolean类型的trigger的第二个参数',
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) ENGINE=INNODB COMMENT = '同步机制的行锁表';

COMMIT;


-- ----------------------------
-- 1、部门表
-- ----------------------------
DROP TABLE IF EXISTS sys_dept;
CREATE TABLE sys_dept (
  dept_id           BIGINT(20)      NOT NULL AUTO_INCREMENT    COMMENT '部门id',
  parent_id         BIGINT(20)      DEFAULT 0                  COMMENT '父部门id',
  ancestors         VARCHAR(50)     DEFAULT ''                 COMMENT '祖级列表',
  dept_name         VARCHAR(30)     DEFAULT ''                 COMMENT '部门名称',
  order_num         INT(4)          DEFAULT 0                  COMMENT '显示顺序',
  leader            VARCHAR(20)     DEFAULT NULL               COMMENT '负责人',
  phone             VARCHAR(11)     DEFAULT NULL               COMMENT '联系电话',
  email             VARCHAR(50)     DEFAULT NULL               COMMENT '邮箱',
  STATUS            CHAR(1)         DEFAULT '0'                COMMENT '部门状态（0正常 1停用）',
  del_flag          CHAR(1)         DEFAULT '0'                COMMENT '删除标志（0代表存在 2代表删除）',
  create_by         VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time 	    DATETIME                                   COMMENT '创建时间',
  update_by         VARCHAR(64)     DEFAULT ''                 COMMENT '更新者',
  update_time       DATETIME                                   COMMENT '更新时间',
  PRIMARY KEY (dept_id)
) ENGINE=INNODB AUTO_INCREMENT=200 COMMENT = '部门表';

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------
INSERT INTO sys_dept VALUES(100,  0,   '0',          'memo科技',   0, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(101,  100, '0,100',      '深圳总公司', 1, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(102,  100, '0,100',      '长沙分公司', 2, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(103,  101, '0,100,101',  '研发部门',   1, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(104,  101, '0,100,101',  '市场部门',   2, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(105,  101, '0,100,101',  '测试部门',   3, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(106,  101, '0,100,101',  '财务部门',   4, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(107,  101, '0,100,101',  '运维部门',   5, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(108,  102, '0,100,102',  '市场部门',   1, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);
INSERT INTO sys_dept VALUES(109,  102, '0,100,102',  '财务部门',   2, 'memo', '15888888888', 'ry@qq.com', '0', '0', 'admin', SYSDATE(), '', NULL);


-- ----------------------------
-- 2、用户信息表
-- ----------------------------
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
  user_id           BIGINT(20)      NOT NULL AUTO_INCREMENT    COMMENT '用户ID',
  dept_id           BIGINT(20)      DEFAULT NULL               COMMENT '部门ID',
  user_name         VARCHAR(30)     NOT NULL                   COMMENT '用户账号',
  nick_name         VARCHAR(30)     NOT NULL                   COMMENT '用户昵称',
  user_type         VARCHAR(2)      DEFAULT '00'               COMMENT '用户类型（00系统用户）',
  email             VARCHAR(50)     DEFAULT ''                 COMMENT '用户邮箱',
  phonenumber       VARCHAR(11)     DEFAULT ''                 COMMENT '手机号码',
  sex               CHAR(1)         DEFAULT '0'                COMMENT '用户性别（0男 1女 2未知）',
  avatar            VARCHAR(100)    DEFAULT ''                 COMMENT '头像地址',
  PASSWORD          VARCHAR(100)    DEFAULT ''                 COMMENT '密码',
  STATUS            CHAR(1)         DEFAULT '0'                COMMENT '帐号状态（0正常 1停用）',
  del_flag          CHAR(1)         DEFAULT '0'                COMMENT '删除标志（0代表存在 2代表删除）',
  login_ip          VARCHAR(128)    DEFAULT ''                 COMMENT '最后登录IP',
  login_date        DATETIME                                   COMMENT '最后登录时间',
  create_by         VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time       DATETIME                                   COMMENT '创建时间',
  update_by         VARCHAR(64)     DEFAULT ''                 COMMENT '更新者',
  update_time       DATETIME                                   COMMENT '更新时间',
  remark            VARCHAR(500)    DEFAULT NULL               COMMENT '备注',
  PRIMARY KEY (user_id)
) ENGINE=INNODB AUTO_INCREMENT=100 COMMENT = '用户信息表';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
INSERT INTO sys_user VALUES(1,  103, 'admin', 'memo', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', SYSDATE(), 'admin', SYSDATE(), '', NULL, '管理员');
INSERT INTO sys_user VALUES(2,  105, 'ry',    'memo', '00', 'ry@qq.com',  '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', SYSDATE(), 'admin', SYSDATE(), '', NULL, '测试员');


-- ----------------------------
-- 3、岗位信息表
-- ----------------------------
DROP TABLE IF EXISTS sys_post;
CREATE TABLE sys_post
(
  post_id       BIGINT(20)      NOT NULL AUTO_INCREMENT    COMMENT '岗位ID',
  post_code     VARCHAR(64)     NOT NULL                   COMMENT '岗位编码',
  post_name     VARCHAR(50)     NOT NULL                   COMMENT '岗位名称',
  post_sort     INT(4)          NOT NULL                   COMMENT '显示顺序',
  STATUS        CHAR(1)         NOT NULL                   COMMENT '状态（0正常 1停用）',
  create_by     VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time   DATETIME                                   COMMENT '创建时间',
  update_by     VARCHAR(64)     DEFAULT ''			       COMMENT '更新者',
  update_time   DATETIME                                   COMMENT '更新时间',
  remark        VARCHAR(500)    DEFAULT NULL               COMMENT '备注',
  PRIMARY KEY (post_id)
) ENGINE=INNODB COMMENT = '岗位信息表';

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------
INSERT INTO sys_post VALUES(1, 'ceo',  '董事长',    1, '0', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_post VALUES(2, 'se',   '项目经理',  2, '0', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_post VALUES(3, 'hr',   '人力资源',  3, '0', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_post VALUES(4, 'user', '普通员工',  4, '0', 'admin', SYSDATE(), '', NULL, '');


-- ----------------------------
-- 4、角色信息表
-- ----------------------------
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
  role_id              BIGINT(20)      NOT NULL AUTO_INCREMENT    COMMENT '角色ID',
  role_name            VARCHAR(30)     NOT NULL                   COMMENT '角色名称',
  role_key             VARCHAR(100)    NOT NULL                   COMMENT '角色权限字符串',
  role_sort            INT(4)          NOT NULL                   COMMENT '显示顺序',
  data_scope           CHAR(1)         DEFAULT '1'                COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  menu_check_strictly  TINYINT(1)      DEFAULT 1                  COMMENT '菜单树选择项是否关联显示',
  dept_check_strictly  TINYINT(1)      DEFAULT 1                  COMMENT '部门树选择项是否关联显示',
  STATUS               CHAR(1)         NOT NULL                   COMMENT '角色状态（0正常 1停用）',
  del_flag             CHAR(1)         DEFAULT '0'                COMMENT '删除标志（0代表存在 2代表删除）',
  create_by            VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time          DATETIME                                   COMMENT '创建时间',
  update_by            VARCHAR(64)     DEFAULT ''                 COMMENT '更新者',
  update_time          DATETIME                                   COMMENT '更新时间',
  remark               VARCHAR(500)    DEFAULT NULL               COMMENT '备注',
  PRIMARY KEY (role_id)
) ENGINE=INNODB AUTO_INCREMENT=100 COMMENT = '角色信息表';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
INSERT INTO sys_role VALUES('1', '超级管理员',  'admin',  1, 1, 1, 1, '0', '0', 'admin', SYSDATE(), '', NULL, '超级管理员');
INSERT INTO sys_role VALUES('2', '普通角色',    'common', 2, 2, 1, 1, '0', '0', 'admin', SYSDATE(), '', NULL, '普通角色');


-- ----------------------------
-- 5、菜单权限表
-- ----------------------------
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu (
  menu_id           BIGINT(20)      NOT NULL AUTO_INCREMENT    COMMENT '菜单ID',
  menu_name         VARCHAR(50)     NOT NULL                   COMMENT '菜单名称',
  parent_id         BIGINT(20)      DEFAULT 0                  COMMENT '父菜单ID',
  order_num         INT(4)          DEFAULT 0                  COMMENT '显示顺序',
  path              VARCHAR(200)    DEFAULT ''                 COMMENT '路由地址',
  component         VARCHAR(255)    DEFAULT NULL               COMMENT '组件路径',
  QUERY             VARCHAR(255)    DEFAULT NULL               COMMENT '路由参数',
  is_frame          INT(1)          DEFAULT 1                  COMMENT '是否为外链（0是 1否）',
  is_cache          INT(1)          DEFAULT 0                  COMMENT '是否缓存（0缓存 1不缓存）',
  menu_type         CHAR(1)         DEFAULT ''                 COMMENT '菜单类型（M目录 C菜单 F按钮）',
  visible           CHAR(1)         DEFAULT 0                  COMMENT '菜单状态（0显示 1隐藏）',
  STATUS            CHAR(1)         DEFAULT 0                  COMMENT '菜单状态（0正常 1停用）',
  perms             VARCHAR(100)    DEFAULT NULL               COMMENT '权限标识',
  icon              VARCHAR(100)    DEFAULT '#'                COMMENT '菜单图标',
  create_by         VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time       DATETIME                                   COMMENT '创建时间',
  update_by         VARCHAR(64)     DEFAULT ''                 COMMENT '更新者',
  update_time       DATETIME                                   COMMENT '更新时间',
  remark            VARCHAR(500)    DEFAULT ''                 COMMENT '备注',
  PRIMARY KEY (menu_id)
) ENGINE=INNODB AUTO_INCREMENT=2000 COMMENT = '菜单权限表';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
-- 一级菜单
INSERT INTO sys_menu VALUES('1', '系统管理', '0', '1', 'system',           NULL, '', 1, 0, 'M', '0', '0', '', 'system',   'admin', SYSDATE(), '', NULL, '系统管理目录');

-- 二级菜单
INSERT INTO sys_menu VALUES('100',  '用户管理', '1',   '1', 'user',       'system/user/index',        '', 1, 0, 'C', '0', '0', 'system:user:list',        'user',          'admin', SYSDATE(), '', NULL, '用户管理菜单');
INSERT INTO sys_menu VALUES('101',  '角色管理', '1',   '2', 'role',       'system/role/index',        '', 1, 0, 'C', '0', '0', 'system:role:list',        'peoples',       'admin', SYSDATE(), '', NULL, '角色管理菜单');
INSERT INTO sys_menu VALUES('102',  '菜单管理', '1',   '3', 'menu',       'system/menu/index',        '', 1, 0, 'C', '0', '0', 'system:menu:list',        'tree-table',    'admin', SYSDATE(), '', NULL, '菜单管理菜单');
INSERT INTO sys_menu VALUES('103',  '部门管理', '1',   '4', 'dept',       'system/dept/index',        '', 1, 0, 'C', '0', '0', 'system:dept:list',        'tree',          'admin', SYSDATE(), '', NULL, '部门管理菜单');
INSERT INTO sys_menu VALUES('104',  '岗位管理', '1',   '5', 'post',       'system/post/index',        '', 1, 0, 'C', '0', '0', 'system:post:list',        'post',          'admin', SYSDATE(), '', NULL, '岗位管理菜单');
INSERT INTO sys_menu VALUES('105',  '字典管理', '1',   '6', 'dict',       'system/dict/index',        '', 1, 0, 'C', '0', '0', 'system:dict:list',        'dict',          'admin', SYSDATE(), '', NULL, '字典管理菜单');
INSERT INTO sys_menu VALUES('106',  '参数设置', '1',   '7', 'config',     'system/config/index',      '', 1, 0, 'C', '0', '0', 'system:config:list',      'edit',          'admin', SYSDATE(), '', NULL, '参数设置菜单');
INSERT INTO sys_menu VALUES('107',  '通知公告', '1',   '8', 'notice',     'system/notice/index',      '', 1, 0, 'C', '0', '0', 'system:notice:list',      'message',       'admin', SYSDATE(), '', NULL, '通知公告菜单');
INSERT INTO sys_menu VALUES('108',  '日志管理', '1',   '9', 'log',        '',                         '', 1, 0, 'M', '0', '0', '',                        'log',           'admin', SYSDATE(), '', NULL, '日志管理菜单');

-- 三级菜单
INSERT INTO sys_menu VALUES('500',  '操作日志', '108', '1', 'operlog',    'monitor/operlog/index',    '', 1, 0, 'C', '0', '0', 'monitor:operlog:list',    'form',          'admin', SYSDATE(), '', NULL, '操作日志菜单');
INSERT INTO sys_menu VALUES('501',  '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor',    'admin', SYSDATE(), '', NULL, '登录日志菜单');
-- 用户管理按钮
INSERT INTO sys_menu VALUES('1000', '用户查询', '100', '1',  '', '', '', 1, 0, 'F', '0', '0', 'system:user:query',          '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1001', '用户新增', '100', '2',  '', '', '', 1, 0, 'F', '0', '0', 'system:user:add',            '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1002', '用户修改', '100', '3',  '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit',           '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1003', '用户删除', '100', '4',  '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove',         '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1004', '用户导出', '100', '5',  '', '', '', 1, 0, 'F', '0', '0', 'system:user:export',         '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1005', '用户导入', '100', '6',  '', '', '', 1, 0, 'F', '0', '0', 'system:user:import',         '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1006', '重置密码', '100', '7',  '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd',       '#', 'admin', SYSDATE(), '', NULL, '');
-- 角色管理按钮
INSERT INTO sys_menu VALUES('1007', '角色查询', '101', '1',  '', '', '', 1, 0, 'F', '0', '0', 'system:role:query',          '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1008', '角色新增', '101', '2',  '', '', '', 1, 0, 'F', '0', '0', 'system:role:add',            '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1009', '角色修改', '101', '3',  '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit',           '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1010', '角色删除', '101', '4',  '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove',         '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1011', '角色导出', '101', '5',  '', '', '', 1, 0, 'F', '0', '0', 'system:role:export',         '#', 'admin', SYSDATE(), '', NULL, '');
-- 菜单管理按钮
INSERT INTO sys_menu VALUES('1012', '菜单查询', '102', '1',  '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query',          '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1013', '菜单新增', '102', '2',  '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add',            '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1014', '菜单修改', '102', '3',  '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit',           '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1015', '菜单删除', '102', '4',  '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove',         '#', 'admin', SYSDATE(), '', NULL, '');
-- 部门管理按钮
INSERT INTO sys_menu VALUES('1016', '部门查询', '103', '1',  '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query',          '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1017', '部门新增', '103', '2',  '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add',            '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1018', '部门修改', '103', '3',  '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit',           '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1019', '部门删除', '103', '4',  '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove',         '#', 'admin', SYSDATE(), '', NULL, '');
-- 岗位管理按钮
INSERT INTO sys_menu VALUES('1020', '岗位查询', '104', '1',  '', '', '', 1, 0, 'F', '0', '0', 'system:post:query',          '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1021', '岗位新增', '104', '2',  '', '', '', 1, 0, 'F', '0', '0', 'system:post:add',            '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1022', '岗位修改', '104', '3',  '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit',           '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1023', '岗位删除', '104', '4',  '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove',         '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1024', '岗位导出', '104', '5',  '', '', '', 1, 0, 'F', '0', '0', 'system:post:export',         '#', 'admin', SYSDATE(), '', NULL, '');
-- 字典管理按钮
INSERT INTO sys_menu VALUES('1025', '字典查询', '105', '1', '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query',          '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1026', '字典新增', '105', '2', '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add',            '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1027', '字典修改', '105', '3', '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit',           '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1028', '字典删除', '105', '4', '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove',         '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1029', '字典导出', '105', '5', '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export',         '#', 'admin', SYSDATE(), '', NULL, '');
-- 参数设置按钮
INSERT INTO sys_menu VALUES('1030', '参数查询', '106', '1', '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query',        '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1031', '参数新增', '106', '2', '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add',          '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1032', '参数修改', '106', '3', '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit',         '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1033', '参数删除', '106', '4', '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove',       '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1034', '参数导出', '106', '5', '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export',       '#', 'admin', SYSDATE(), '', NULL, '');
-- 通知公告按钮
INSERT INTO sys_menu VALUES('1035', '公告查询', '107', '1', '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query',        '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1036', '公告新增', '107', '2', '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add',          '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1037', '公告修改', '107', '3', '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit',         '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1038', '公告删除', '107', '4', '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove',       '#', 'admin', SYSDATE(), '', NULL, '');
-- 操作日志按钮
INSERT INTO sys_menu VALUES('1039', '操作查询', '500', '1', '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query',      '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1040', '操作删除', '500', '2', '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove',     '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1041', '日志导出', '500', '3', '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export',     '#', 'admin', SYSDATE(), '', NULL, '');
-- 登录日志按钮
INSERT INTO sys_menu VALUES('1042', '登录查询', '501', '1', '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query',   '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1043', '登录删除', '501', '2', '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove',  '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1044', '日志导出', '501', '3', '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export',  '#', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('1045', '账户解锁', '501', '4', '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock',  '#', 'admin', SYSDATE(), '', NULL, '');

-- memo category
INSERT INTO sys_menu VALUES('2001', 'memo', '0', '4', 'memo', '', '', 1, 0, 'M', '0', '0', '',  'form', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_menu VALUES('2002', 'memo_info', '2001', '1', 'memo', 'memo/memo/index', '', 1, 0, 'C', '0', '0', 'memo:memo:list',  'form', 'admin', SYSDATE(), 'admin', SYSDATE(), 'memo_info category');



-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role (
  user_id   BIGINT(20) NOT NULL COMMENT '用户ID',
  role_id   BIGINT(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY(user_id, role_id)
) ENGINE=INNODB COMMENT = '用户和角色关联表';

-- ----------------------------
-- 初始化-用户和角色关联表数据
-- ----------------------------
INSERT INTO sys_user_role VALUES ('1', '1');
INSERT INTO sys_user_role VALUES ('2', '2');


-- ----------------------------
-- 7、角色和菜单关联表  角色1-N菜单
-- ----------------------------
DROP TABLE IF EXISTS sys_role_menu;
CREATE TABLE sys_role_menu (
  role_id   BIGINT(20) NOT NULL COMMENT '角色ID',
  menu_id   BIGINT(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY(role_id, menu_id)
) ENGINE=INNODB COMMENT = '角色和菜单关联表';

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------
INSERT INTO sys_role_menu VALUES ('2', '1');
INSERT INTO sys_role_menu VALUES ('2', '2');
INSERT INTO sys_role_menu VALUES ('2', '3');
INSERT INTO sys_role_menu VALUES ('2', '4');
INSERT INTO sys_role_menu VALUES ('2', '100');
INSERT INTO sys_role_menu VALUES ('2', '101');
INSERT INTO sys_role_menu VALUES ('2', '102');
INSERT INTO sys_role_menu VALUES ('2', '103');
INSERT INTO sys_role_menu VALUES ('2', '104');
INSERT INTO sys_role_menu VALUES ('2', '105');
INSERT INTO sys_role_menu VALUES ('2', '106');
INSERT INTO sys_role_menu VALUES ('2', '107');
INSERT INTO sys_role_menu VALUES ('2', '108');
INSERT INTO sys_role_menu VALUES ('2', '109');
INSERT INTO sys_role_menu VALUES ('2', '110');
INSERT INTO sys_role_menu VALUES ('2', '111');
INSERT INTO sys_role_menu VALUES ('2', '112');
INSERT INTO sys_role_menu VALUES ('2', '113');
INSERT INTO sys_role_menu VALUES ('2', '114');
INSERT INTO sys_role_menu VALUES ('2', '115');
INSERT INTO sys_role_menu VALUES ('2', '116');
INSERT INTO sys_role_menu VALUES ('2', '117');
INSERT INTO sys_role_menu VALUES ('2', '500');
INSERT INTO sys_role_menu VALUES ('2', '501');
INSERT INTO sys_role_menu VALUES ('2', '1000');
INSERT INTO sys_role_menu VALUES ('2', '1001');
INSERT INTO sys_role_menu VALUES ('2', '1002');
INSERT INTO sys_role_menu VALUES ('2', '1003');
INSERT INTO sys_role_menu VALUES ('2', '1004');
INSERT INTO sys_role_menu VALUES ('2', '1005');
INSERT INTO sys_role_menu VALUES ('2', '1006');
INSERT INTO sys_role_menu VALUES ('2', '1007');
INSERT INTO sys_role_menu VALUES ('2', '1008');
INSERT INTO sys_role_menu VALUES ('2', '1009');
INSERT INTO sys_role_menu VALUES ('2', '1010');
INSERT INTO sys_role_menu VALUES ('2', '1011');
INSERT INTO sys_role_menu VALUES ('2', '1012');
INSERT INTO sys_role_menu VALUES ('2', '1013');
INSERT INTO sys_role_menu VALUES ('2', '1014');
INSERT INTO sys_role_menu VALUES ('2', '1015');
INSERT INTO sys_role_menu VALUES ('2', '1016');
INSERT INTO sys_role_menu VALUES ('2', '1017');
INSERT INTO sys_role_menu VALUES ('2', '1018');
INSERT INTO sys_role_menu VALUES ('2', '1019');
INSERT INTO sys_role_menu VALUES ('2', '1020');
INSERT INTO sys_role_menu VALUES ('2', '1021');
INSERT INTO sys_role_menu VALUES ('2', '1022');
INSERT INTO sys_role_menu VALUES ('2', '1023');
INSERT INTO sys_role_menu VALUES ('2', '1024');
INSERT INTO sys_role_menu VALUES ('2', '1025');
INSERT INTO sys_role_menu VALUES ('2', '1026');
INSERT INTO sys_role_menu VALUES ('2', '1027');
INSERT INTO sys_role_menu VALUES ('2', '1028');
INSERT INTO sys_role_menu VALUES ('2', '1029');
INSERT INTO sys_role_menu VALUES ('2', '1030');
INSERT INTO sys_role_menu VALUES ('2', '1031');
INSERT INTO sys_role_menu VALUES ('2', '1032');
INSERT INTO sys_role_menu VALUES ('2', '1033');
INSERT INTO sys_role_menu VALUES ('2', '1034');
INSERT INTO sys_role_menu VALUES ('2', '1035');
INSERT INTO sys_role_menu VALUES ('2', '1036');
INSERT INTO sys_role_menu VALUES ('2', '1037');
INSERT INTO sys_role_menu VALUES ('2', '1038');
INSERT INTO sys_role_menu VALUES ('2', '1039');
INSERT INTO sys_role_menu VALUES ('2', '1040');
INSERT INTO sys_role_menu VALUES ('2', '1041');
INSERT INTO sys_role_menu VALUES ('2', '1042');
INSERT INTO sys_role_menu VALUES ('2', '1043');
INSERT INTO sys_role_menu VALUES ('2', '1044');
INSERT INTO sys_role_menu VALUES ('2', '1045');
INSERT INTO sys_role_menu VALUES ('2', '1046');
INSERT INTO sys_role_menu VALUES ('2', '1047');
INSERT INTO sys_role_menu VALUES ('2', '1048');
INSERT INTO sys_role_menu VALUES ('2', '1049');
INSERT INTO sys_role_menu VALUES ('2', '1050');
INSERT INTO sys_role_menu VALUES ('2', '1051');
INSERT INTO sys_role_menu VALUES ('2', '1052');
INSERT INTO sys_role_menu VALUES ('2', '1053');
INSERT INTO sys_role_menu VALUES ('2', '1054');


-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
DROP TABLE IF EXISTS sys_role_dept;
CREATE TABLE sys_role_dept (
  role_id   BIGINT(20) NOT NULL COMMENT '角色ID',
  dept_id   BIGINT(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY(role_id, dept_id)
) ENGINE=INNODB COMMENT = '角色和部门关联表';

-- ----------------------------
-- 初始化-角色和部门关联表数据
-- ----------------------------
INSERT INTO sys_role_dept VALUES ('2', '100');
INSERT INTO sys_role_dept VALUES ('2', '101');
INSERT INTO sys_role_dept VALUES ('2', '105');


-- ----------------------------
-- 9、用户与岗位关联表  用户1-N岗位
-- ----------------------------
DROP TABLE IF EXISTS sys_user_post;
CREATE TABLE sys_user_post
(
  user_id   BIGINT(20) NOT NULL COMMENT '用户ID',
  post_id   BIGINT(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (user_id, post_id)
) ENGINE=INNODB COMMENT = '用户与岗位关联表';

-- ----------------------------
-- 初始化-用户与岗位关联表数据
-- ----------------------------
INSERT INTO sys_user_post VALUES ('1', '1');
INSERT INTO sys_user_post VALUES ('2', '2');


-- ----------------------------
-- 10、操作日志记录
-- ----------------------------
DROP TABLE IF EXISTS sys_oper_log;
CREATE TABLE sys_oper_log (
  oper_id           BIGINT(20)      NOT NULL AUTO_INCREMENT    COMMENT '日志主键',
  title             VARCHAR(50)     DEFAULT ''                 COMMENT '模块标题',
  business_type     INT(2)          DEFAULT 0                  COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  method            VARCHAR(100)    DEFAULT ''                 COMMENT '方法名称',
  request_method    VARCHAR(10)     DEFAULT ''                 COMMENT '请求方式',
  operator_type     INT(1)          DEFAULT 0                  COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  oper_name         VARCHAR(50)     DEFAULT ''                 COMMENT '操作人员',
  dept_name         VARCHAR(50)     DEFAULT ''                 COMMENT '部门名称',
  oper_url          VARCHAR(255)    DEFAULT ''                 COMMENT '请求URL',
  oper_ip           VARCHAR(128)    DEFAULT ''                 COMMENT '主机地址',
  oper_location     VARCHAR(255)    DEFAULT ''                 COMMENT '操作地点',
  oper_param        VARCHAR(2000)   DEFAULT ''                 COMMENT '请求参数',
  json_result       VARCHAR(2000)   DEFAULT ''                 COMMENT '返回参数',
  STATUS            INT(1)          DEFAULT 0                  COMMENT '操作状态（0正常 1异常）',
  error_msg         VARCHAR(2000)   DEFAULT ''                 COMMENT '错误消息',
  oper_time         DATETIME                                   COMMENT '操作时间',
  PRIMARY KEY (oper_id)
) ENGINE=INNODB AUTO_INCREMENT=100 COMMENT = '操作日志记录';


-- ----------------------------
-- 11、字典类型表
-- ----------------------------
DROP TABLE IF EXISTS sys_dict_type;
CREATE TABLE sys_dict_type
(
  dict_id          BIGINT(20)      NOT NULL AUTO_INCREMENT    COMMENT '字典主键',
  dict_name        VARCHAR(100)    DEFAULT ''                 COMMENT '字典名称',
  dict_type        VARCHAR(100)    DEFAULT ''                 COMMENT '字典类型',
  STATUS           CHAR(1)         DEFAULT '0'                COMMENT '状态（0正常 1停用）',
  create_by        VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time      DATETIME                                   COMMENT '创建时间',
  update_by        VARCHAR(64)     DEFAULT ''                 COMMENT '更新者',
  update_time      DATETIME                                   COMMENT '更新时间',
  remark           VARCHAR(500)    DEFAULT NULL               COMMENT '备注',
  PRIMARY KEY (dict_id),
  UNIQUE (dict_type)
) ENGINE=INNODB AUTO_INCREMENT=100 COMMENT = '字典类型表';

INSERT INTO sys_dict_type VALUES(1,  '用户性别', 'sys_user_sex',        '0', 'admin', SYSDATE(), '', NULL, '用户性别列表');
INSERT INTO sys_dict_type VALUES(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', SYSDATE(), '', NULL, '菜单状态列表');
INSERT INTO sys_dict_type VALUES(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', SYSDATE(), '', NULL, '系统开关列表');
INSERT INTO sys_dict_type VALUES(4,  '任务状态', 'sys_job_status',      '0', 'admin', SYSDATE(), '', NULL, '任务状态列表');
INSERT INTO sys_dict_type VALUES(5,  '任务分组', 'sys_job_group',       '0', 'admin', SYSDATE(), '', NULL, '任务分组列表');
INSERT INTO sys_dict_type VALUES(6,  '系统是否', 'sys_yes_no',          '0', 'admin', SYSDATE(), '', NULL, '系统是否列表');
INSERT INTO sys_dict_type VALUES(7,  '通知类型', 'sys_notice_type',     '0', 'admin', SYSDATE(), '', NULL, '通知类型列表');
INSERT INTO sys_dict_type VALUES(8,  '通知状态', 'sys_notice_status',   '0', 'admin', SYSDATE(), '', NULL, '通知状态列表');
INSERT INTO sys_dict_type VALUES(9,  '操作类型', 'sys_oper_type',       '0', 'admin', SYSDATE(), '', NULL, '操作类型列表');
INSERT INTO sys_dict_type VALUES(10, '系统状态', 'sys_common_status',   '0', 'admin', SYSDATE(), '', NULL, '登录状态列表');

INSERT INTO sys_dict_type VALUES(100, 'memo_type', 'memo_type',   '0', 'admin', SYSDATE(), '', NULL, 'memo type');
INSERT INTO sys_dict_type VALUES(101, 'status', 'status',   '0', 'admin', SYSDATE(), '', NULL, 'status');


-- ----------------------------
-- 12、字典数据表
-- ----------------------------
DROP TABLE IF EXISTS sys_dict_data;
CREATE TABLE sys_dict_data
(
  dict_code        BIGINT(20)      NOT NULL AUTO_INCREMENT    COMMENT '字典编码',
  dict_sort        INT(4)          DEFAULT 0                  COMMENT '字典排序',
  dict_label       VARCHAR(100)    DEFAULT ''                 COMMENT '字典标签',
  dict_value       VARCHAR(100)    DEFAULT ''                 COMMENT '字典键值',
  dict_type        VARCHAR(100)    DEFAULT ''                 COMMENT '字典类型',
  css_class        VARCHAR(100)    DEFAULT NULL               COMMENT '样式属性（其他样式扩展）',
  list_class       VARCHAR(100)    DEFAULT NULL               COMMENT '表格回显样式',
  is_default       CHAR(1)         DEFAULT 'N'                COMMENT '是否默认（Y是 N否）',
  STATUS           CHAR(1)         DEFAULT '0'                COMMENT '状态（0正常 1停用）',
  create_by        VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time      DATETIME                                   COMMENT '创建时间',
  update_by        VARCHAR(64)     DEFAULT ''                 COMMENT '更新者',
  update_time      DATETIME                                   COMMENT '更新时间',
  remark           VARCHAR(500)    DEFAULT NULL               COMMENT '备注',
  PRIMARY KEY (dict_code)
) ENGINE=INNODB AUTO_INCREMENT=100 COMMENT = '字典数据表';

INSERT INTO sys_dict_data VALUES(1,  1,  '男',       '0',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', SYSDATE(), '', NULL, '性别男');
INSERT INTO sys_dict_data VALUES(2,  2,  '女',       '1',       'sys_user_sex',        '',   '',        'N', '0', 'admin', SYSDATE(), '', NULL, '性别女');
INSERT INTO sys_dict_data VALUES(3,  3,  '未知',     '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', SYSDATE(), '', NULL, '性别未知');
INSERT INTO sys_dict_data VALUES(4,  1,  '显示',     '0',       'sys_show_hide',       '',   'primary', 'Y', '0', 'admin', SYSDATE(), '', NULL, '显示菜单');
INSERT INTO sys_dict_data VALUES(5,  2,  '隐藏',     '1',       'sys_show_hide',       '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '隐藏菜单');
INSERT INTO sys_dict_data VALUES(6,  1,  '正常',     '0',       'sys_normal_disable',  '',   'primary', 'Y', '0', 'admin', SYSDATE(), '', NULL, '正常状态');
INSERT INTO sys_dict_data VALUES(7,  2,  '停用',     '1',       'sys_normal_disable',  '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '停用状态');
INSERT INTO sys_dict_data VALUES(8,  1,  '正常',     '0',       'sys_job_status',      '',   'primary', 'Y', '0', 'admin', SYSDATE(), '', NULL, '正常状态');
INSERT INTO sys_dict_data VALUES(9,  2,  '暂停',     '1',       'sys_job_status',      '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '停用状态');
INSERT INTO sys_dict_data VALUES(10, 1,  '默认',     'DEFAULT', 'sys_job_group',       '',   '',        'Y', '0', 'admin', SYSDATE(), '', NULL, '默认分组');
INSERT INTO sys_dict_data VALUES(11, 2,  '系统',     'SYSTEM',  'sys_job_group',       '',   '',        'N', '0', 'admin', SYSDATE(), '', NULL, '系统分组');
INSERT INTO sys_dict_data VALUES(12, 1,  '是',       'Y',       'sys_yes_no',          '',   'primary', 'Y', '0', 'admin', SYSDATE(), '', NULL, '系统默认是');
INSERT INTO sys_dict_data VALUES(13, 2,  '否',       'N',       'sys_yes_no',          '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '系统默认否');
INSERT INTO sys_dict_data VALUES(14, 1,  '通知',     '1',       'sys_notice_type',     '',   'warning', 'Y', '0', 'admin', SYSDATE(), '', NULL, '通知');
INSERT INTO sys_dict_data VALUES(15, 2,  '公告',     '2',       'sys_notice_type',     '',   'success', 'N', '0', 'admin', SYSDATE(), '', NULL, '公告');
INSERT INTO sys_dict_data VALUES(16, 1,  '正常',     '0',       'sys_notice_status',   '',   'primary', 'Y', '0', 'admin', SYSDATE(), '', NULL, '正常状态');
INSERT INTO sys_dict_data VALUES(17, 2,  '关闭',     '1',       'sys_notice_status',   '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '关闭状态');
INSERT INTO sys_dict_data VALUES(18, 99, '其他',     '0',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', SYSDATE(), '', NULL, '其他操作');
INSERT INTO sys_dict_data VALUES(19, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', SYSDATE(), '', NULL, '新增操作');
INSERT INTO sys_dict_data VALUES(20, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', SYSDATE(), '', NULL, '修改操作');
INSERT INTO sys_dict_data VALUES(21, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '删除操作');
INSERT INTO sys_dict_data VALUES(22, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', SYSDATE(), '', NULL, '授权操作');
INSERT INTO sys_dict_data VALUES(23, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', SYSDATE(), '', NULL, '导出操作');
INSERT INTO sys_dict_data VALUES(24, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', SYSDATE(), '', NULL, '导入操作');
INSERT INTO sys_dict_data VALUES(25, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '强退操作');
INSERT INTO sys_dict_data VALUES(27, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '清空操作');
INSERT INTO sys_dict_data VALUES(28, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', SYSDATE(), '', NULL, '正常状态');
INSERT INTO sys_dict_data VALUES(29, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', SYSDATE(), '', NULL, '停用状态');


-- ----------------------------
-- 13、参数配置表
-- ----------------------------
DROP TABLE IF EXISTS sys_config;
CREATE TABLE sys_config (
  config_id         INT(5)          NOT NULL AUTO_INCREMENT    COMMENT '参数主键',
  config_name       VARCHAR(100)    DEFAULT ''                 COMMENT '参数名称',
  config_key        VARCHAR(100)    DEFAULT ''                 COMMENT '参数键名',
  config_value      VARCHAR(500)    DEFAULT ''                 COMMENT '参数键值',
  config_type       CHAR(1)         DEFAULT 'N'                COMMENT '系统内置（Y是 N否）',
  create_by         VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time       DATETIME                                   COMMENT '创建时间',
  update_by         VARCHAR(64)     DEFAULT ''                 COMMENT '更新者',
  update_time       DATETIME                                   COMMENT '更新时间',
  remark            VARCHAR(500)    DEFAULT NULL               COMMENT '备注',
  PRIMARY KEY (config_id)
) ENGINE=INNODB AUTO_INCREMENT=100 COMMENT = '参数配置表';

INSERT INTO sys_config VALUES(1, '主框架页-默认皮肤样式名称',     'sys.index.skinName',            'skin-blue',     'Y', 'admin', SYSDATE(), '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow' );
INSERT INTO sys_config VALUES(2, '用户管理-账号初始密码',         'sys.user.initPassword',         '123456',        'Y', 'admin', SYSDATE(), '', NULL, '初始化密码 123456' );
INSERT INTO sys_config VALUES(3, '主框架页-侧边栏主题',           'sys.index.sideTheme',           'theme-dark',    'Y', 'admin', SYSDATE(), '', NULL, '深色主题theme-dark，浅色主题theme-light' );
INSERT INTO sys_config VALUES(4, '账号自助-验证码开关',           'sys.account.captchaEnabled',    'true',          'Y', 'admin', SYSDATE(), '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO sys_config VALUES(5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser',      'false',         'Y', 'admin', SYSDATE(), '', NULL, '是否开启注册用户功能（true开启，false关闭）');


-- ----------------------------
-- 14、系统访问记录
-- ----------------------------
DROP TABLE IF EXISTS sys_logininfor;
CREATE TABLE sys_logininfor (
  info_id        BIGINT(20)     NOT NULL AUTO_INCREMENT   COMMENT '访问ID',
  user_name      VARCHAR(50)    DEFAULT ''                COMMENT '用户账号',
  ipaddr         VARCHAR(128)   DEFAULT ''                COMMENT '登录IP地址',
  login_location VARCHAR(255)   DEFAULT ''                COMMENT '登录地点',
  browser        VARCHAR(50)    DEFAULT ''                COMMENT '浏览器类型',
  os             VARCHAR(50)    DEFAULT ''                COMMENT '操作系统',
  STATUS         CHAR(1)        DEFAULT '0'               COMMENT '登录状态（0成功 1失败）',
  msg            VARCHAR(255)   DEFAULT ''                COMMENT '提示消息',
  login_time     DATETIME                                 COMMENT '访问时间',
  PRIMARY KEY (info_id)
) ENGINE=INNODB AUTO_INCREMENT=100 COMMENT = '系统访问记录';


-- ----------------------------
-- 15、定时任务调度表
-- ----------------------------
DROP TABLE IF EXISTS sys_job;
CREATE TABLE sys_job (
  job_id              BIGINT(20)    NOT NULL AUTO_INCREMENT    COMMENT '任务ID',
  job_name            VARCHAR(64)   DEFAULT ''                 COMMENT '任务名称',
  job_group           VARCHAR(64)   DEFAULT 'DEFAULT'          COMMENT '任务组名',
  invoke_target       VARCHAR(500)  NOT NULL                   COMMENT '调用目标字符串',
  cron_expression     VARCHAR(255)  DEFAULT ''                 COMMENT 'cron执行表达式',
  misfire_policy      VARCHAR(20)   DEFAULT '3'                COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  CONCURRENT          CHAR(1)       DEFAULT '1'                COMMENT '是否并发执行（0允许 1禁止）',
  STATUS              CHAR(1)       DEFAULT '0'                COMMENT '状态（0正常 1暂停）',
  create_by           VARCHAR(64)   DEFAULT ''                 COMMENT '创建者',
  create_time         DATETIME                                 COMMENT '创建时间',
  update_by           VARCHAR(64)   DEFAULT ''                 COMMENT '更新者',
  update_time         DATETIME                                 COMMENT '更新时间',
  remark              VARCHAR(500)  DEFAULT ''                 COMMENT '备注信息',
  PRIMARY KEY (job_id, job_name, job_group)
) ENGINE=INNODB AUTO_INCREMENT=100 COMMENT = '定时任务调度表';

INSERT INTO sys_job VALUES(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams',        '0/10 * * * * ?', '3', '1', '1', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_job VALUES(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')',  '0/15 * * * * ?', '3', '1', '1', 'admin', SYSDATE(), '', NULL, '');
INSERT INTO sys_job VALUES(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', '1', '1', 'admin', SYSDATE(), '', NULL, '');


-- ----------------------------
-- 16、定时任务调度日志表
-- ----------------------------
DROP TABLE IF EXISTS sys_job_log;
CREATE TABLE sys_job_log (
  job_log_id          BIGINT(20)     NOT NULL AUTO_INCREMENT    COMMENT '任务日志ID',
  job_name            VARCHAR(64)    NOT NULL                   COMMENT '任务名称',
  job_group           VARCHAR(64)    NOT NULL                   COMMENT '任务组名',
  invoke_target       VARCHAR(500)   NOT NULL                   COMMENT '调用目标字符串',
  job_message         VARCHAR(500)                              COMMENT '日志信息',
  STATUS              CHAR(1)        DEFAULT '0'                COMMENT '执行状态（0正常 1失败）',
  exception_info      VARCHAR(2000)  DEFAULT ''                 COMMENT '异常信息',
  create_time         DATETIME                                  COMMENT '创建时间',
  PRIMARY KEY (job_log_id)
) ENGINE=INNODB COMMENT = '定时任务调度日志表';


-- ----------------------------
-- 17、通知公告表
-- ----------------------------
DROP TABLE IF EXISTS sys_notice;
CREATE TABLE sys_notice (
  notice_id         INT(4)          NOT NULL AUTO_INCREMENT    COMMENT '公告ID',
  notice_title      VARCHAR(50)     NOT NULL                   COMMENT '公告标题',
  notice_type       CHAR(1)         NOT NULL                   COMMENT '公告类型（1通知 2公告）',
  notice_content    LONGBLOB        DEFAULT NULL               COMMENT '公告内容',
  STATUS            CHAR(1)         DEFAULT '0'                COMMENT '公告状态（0正常 1关闭）',
  create_by         VARCHAR(64)     DEFAULT ''                 COMMENT '创建者',
  create_time       DATETIME                                   COMMENT '创建时间',
  update_by         VARCHAR(64)     DEFAULT ''                 COMMENT '更新者',
  update_time       DATETIME                                   COMMENT '更新时间',
  remark            VARCHAR(255)    DEFAULT NULL               COMMENT '备注',
  PRIMARY KEY (notice_id)
) ENGINE=INNODB AUTO_INCREMENT=10 COMMENT = '通知公告表';

-- ----------------------------
-- 初始化-公告信息表数据
-- ----------------------------
INSERT INTO sys_notice VALUES('1', '温馨提醒：2018-07-01 memo新版本发布啦', '2', '新版本内容', '0', 'admin', SYSDATE(), '', NULL, '管理员');
INSERT INTO sys_notice VALUES('2', '维护通知：2018-07-01 memo系统凌晨维护', '1', '维护内容',   '0', 'admin', SYSDATE(), '', NULL, '管理员');


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for todo_memo
-- ----------------------------
DROP TABLE IF EXISTS `todo_memo`;
CREATE TABLE `todo_memo` (
  `memo_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'id',

  `memo_name` VARCHAR(50) DEFAULT NULL COMMENT 'name',
  `description` VARCHAR(500) DEFAULT NULL COMMENT 'description',


  `contact` VARCHAR(30) DEFAULT NULL COMMENT 'contact',
  `phone` VARCHAR(30) DEFAULT NULL COMMENT 'phone',


  `memo_type` CHAR(1) DEFAULT NULL COMMENT 'type',
  `status` CHAR(1) DEFAULT NULL COMMENT 'status',
  `due_time` DATETIME DEFAULT NULL COMMENT 'due_time',

  `create_by` VARCHAR(50) DEFAULT NULL COMMENT '创建者',
  `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
  `update_by` VARCHAR(50) DEFAULT NULL COMMENT '更新者',
  `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`memo_id`)
) ENGINE=INNODB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8 COMMENT='memo_info';

-- ----------------------------
-- Records of todo_memo
-- ----------------------------
INSERT INTO `todo_memo` VALUES ('101', 'book1', 'this is an interesting book', 'admin', '852-65814105', '0', '1','2022-11-21 00:00:00', 'admin', '2022-11-17 16:03:29', NULL, NULL);
INSERT INTO `todo_memo` VALUES ('102', 'book2', 'this is a boring book', 'admin', '852-65814105', '1', '2','2022-11-18 00:00:00', 'admin', '2022-11-17 16:03:29', NULL, NULL);
INSERT INTO `todo_memo` VALUES ('103', 'music1', 'this is an interesting music', 'admin', '852-65814105', '2', '0','2022-11-21 00:00:00', 'admin', '2022-11-17 16:03:29', NULL, NULL);
INSERT INTO `todo_memo` VALUES ('104', 'music2', 'this is a boring music', 'admin', '852-65814105', '3', '0','2022-11-22 00:00:00', 'admin', '2022-11-17 16:03:29', NULL, NULL);





-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, STATUS, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES('memo_info查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'memo:memo:query',        '#', 'admin', SYSDATE(), '', NULL, '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, STATUS, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES('memo_info新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'memo:memo:add',          '#', 'admin', SYSDATE(), '', NULL, '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, STATUS, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES('memo_info修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'memo:memo:edit',         '#', 'admin', SYSDATE(), '', NULL, '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, STATUS, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES('memo_info删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'memo:memo:remove',       '#', 'admin', SYSDATE(), '', NULL, '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, STATUS, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES('memo_info导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'memo:memo:export',       '#', 'admin', SYSDATE(), '', NULL, '');
