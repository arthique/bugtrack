CREATE SCHEMA bugtrack;

CREATE TABLE bugtrack.bt_project_status ( 
	project_status_id    integer  NOT NULL,
	project_status_name  varchar(10)  NOT NULL,
	CONSTRAINT pk_bt_project_status PRIMARY KEY ( project_status_id )
 );

CREATE TABLE bugtrack.bt_projects ( 
	project_id           integer  NOT NULL,
	project_title        varchar(100)  NOT NULL,
	project_description  varchar(1000)  NOT NULL,
	project_members      integer  NOT NULL,
	project_status       integer  NOT NULL,
	project_create_date  date  NOT NULL,
	project_changed_date date  ,
	project_close_date   date  ,
	CONSTRAINT pk_bt_projects PRIMARY KEY ( project_id ),
	CONSTRAINT pk_bt_projects_0 UNIQUE ( project_status ) 
 );

CREATE TABLE bugtrack.bt_issues ( 
	issue_id             integer  NOT NULL,
	issue_in_project     integer  NOT NULL,
	issue_create_date    date  NOT NULL,
	issue_title          varchar(100)  NOT NULL,
	issue_description    varchar(1000)  NOT NULL,
	issue_creator        integer  NOT NULL,
	issue_executor       integer  ,
	issue_status         integer DEFAULT 0 NOT NULL,
	issue_priority       integer DEFAULT 0 NOT NULL,
	issue_state          integer DEFAULT 0 NOT NULL,
	CONSTRAINT pk_bt_issues PRIMARY KEY ( issue_id ),
	CONSTRAINT pk_bt_issues_0 UNIQUE ( issue_creator ) ,
	CONSTRAINT pk_bt_issues_1 UNIQUE ( issue_executor ) ,
	CONSTRAINT pk_bt_issues_2 UNIQUE ( issue_status ) ,
	CONSTRAINT pk_bt_issues_3 UNIQUE ( issue_priority ) ,
	CONSTRAINT pk_bt_issues_4 UNIQUE ( issue_state ) 
 );

CREATE INDEX idx_bt_issues ON bugtrack.bt_issues ( issue_in_project );

CREATE TABLE bugtrack.bt_issue_priority ( 
	issue_priority_id    integer  NOT NULL,
	issue_priority_name  varchar(20)  NOT NULL,
	CONSTRAINT pk_bt_issue_priority PRIMARY KEY ( issue_priority_id )
 );

CREATE TABLE bugtrack.bt_issue_state ( 
	issue_state_id       integer  NOT NULL,
	issue_state_name     varchar(20)  NOT NULL,
	CONSTRAINT pk_bt_issue_state PRIMARY KEY ( issue_state_id )
 );

CREATE TABLE bugtrack.bt_issue_status_history ( 
	status_history_id    integer  NOT NULL,
	issue_id             integer  ,
	status_history_action integer  NOT NULL,
	status_history_date  date  NOT NULL,
	status_history_author integer  NOT NULL,
	status_history_comment varchar(500)  NOT NULL,
	CONSTRAINT pk_bt_issue_status_history PRIMARY KEY ( status_history_id ),
	CONSTRAINT pk_bt_issue_status_history_0 UNIQUE ( issue_id ) ,
	CONSTRAINT pk_bt_issue_status_history_1 UNIQUE ( status_history_author ) ,
	CONSTRAINT idx_bt_issue_status_history UNIQUE ( status_history_action ) 
 );

CREATE TABLE bugtrack.bt_users ( 
	user_id              integer  NOT NULL,
	user_login           varchar(20)  NOT NULL,
	user_firstname       varchar(100)  NOT NULL,
	user_lastname        varchar(100)  NOT NULL,
	user_password        varchar(20)  ,
	user_email           varchar(100)  NOT NULL,
	CONSTRAINT pk_bt_users PRIMARY KEY ( user_id )
 );

CREATE TABLE bugtrack.bt_issue_status ( 
	issue_status_id      integer  NOT NULL,
	issue_status_name    varchar(100)  NOT NULL,
	CONSTRAINT pk_bt_issue_status PRIMARY KEY ( issue_status_id )
 );

ALTER TABLE bugtrack.bt_issue_priority ADD CONSTRAINT fk_bt_issue_priority FOREIGN KEY ( issue_priority_id ) REFERENCES bugtrack.bt_issues( issue_priority );

COMMENT ON CONSTRAINT fk_bt_issue_priority ON bugtrack.bt_issue_priority IS '';

ALTER TABLE bugtrack.bt_issue_state ADD CONSTRAINT fk_bt_issue_state FOREIGN KEY ( issue_state_id ) REFERENCES bugtrack.bt_issues( issue_state );

COMMENT ON CONSTRAINT fk_bt_issue_state ON bugtrack.bt_issue_state IS '';

ALTER TABLE bugtrack.bt_issue_status ADD CONSTRAINT fk_bt_issue_status FOREIGN KEY ( issue_status_id ) REFERENCES bugtrack.bt_issue_status_history( status_history_action );

COMMENT ON CONSTRAINT fk_bt_issue_status ON bugtrack.bt_issue_status IS '';

ALTER TABLE bugtrack.bt_issue_status_history ADD CONSTRAINT fk_bt_issue_status_history FOREIGN KEY ( issue_id ) REFERENCES bugtrack.bt_issues( issue_id );

COMMENT ON CONSTRAINT fk_bt_issue_status_history ON bugtrack.bt_issue_status_history IS '';

ALTER TABLE bugtrack.bt_issues ADD CONSTRAINT fk_bt_issues FOREIGN KEY ( issue_in_project ) REFERENCES bugtrack.bt_projects( project_id );

COMMENT ON CONSTRAINT fk_bt_issues ON bugtrack.bt_issues IS '';

ALTER TABLE bugtrack.bt_projects ADD CONSTRAINT fk_bt_projects_0 FOREIGN KEY ( project_status ) REFERENCES bugtrack.bt_project_status( project_status_id );

COMMENT ON CONSTRAINT fk_bt_projects_0 ON bugtrack.bt_projects IS '';

ALTER TABLE bugtrack.bt_users ADD CONSTRAINT fk_bt_users_1 FOREIGN KEY ( user_id ) REFERENCES bugtrack.bt_issue_status_history( status_history_author );

COMMENT ON CONSTRAINT fk_bt_users_1 ON bugtrack.bt_users IS '';

ALTER TABLE bugtrack.bt_users ADD CONSTRAINT fk_bt_users FOREIGN KEY ( user_id ) REFERENCES bugtrack.bt_issues( issue_creator );

COMMENT ON CONSTRAINT fk_bt_users ON bugtrack.bt_users IS '';

ALTER TABLE bugtrack.bt_users ADD CONSTRAINT fk_bt_users_0 FOREIGN KEY ( user_id ) REFERENCES bugtrack.bt_issues( issue_executor );

COMMENT ON CONSTRAINT fk_bt_users_0 ON bugtrack.bt_users IS '';

