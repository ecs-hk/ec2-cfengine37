CREATE DATABASE CFEdata;

USE CFEdata;

-- SystemEvents is used by rsyslog module ommysql
CREATE TABLE SystemEvents
(
        ID int unsigned not null auto_increment primary key,
        CustomerID bigint,
        ReceivedAt datetime NULL,
        DeviceReportedTime datetime NULL,
        Facility smallint NULL,
        Priority smallint NULL,
        FromHost varchar(60) NULL,
        Message text,
        NTSeverity int NULL,
        Importance int NULL,
        EventSource varchar(60),
        EventUser varchar(60) NULL,
        EventCategory int NULL,
        EventID int NULL,
        EventBinaryData text NULL,
        MaxAvailable int NULL,
        CurrUsage int NULL,
        MinUsage int NULL,
        MaxUsage int NULL,
        InfoUnitID int NULL ,
        SysLogTag varchar(60),
        EventLogType varchar(60),
        GenericFileName VarChar(60),
        SystemID int NULL
);

-- SystemEventsProperties is used by rsyslog module ommysql
CREATE TABLE SystemEventsProperties
(
        ID int unsigned not null auto_increment primary key,
        SystemEventID int NULL ,
        ParamName varchar(255) NULL ,
        ParamValue text NULL
);

-- ServerInfo is used by a CFE info-gathering cronjob
CREATE TABLE ServerInfo
(
        InstID varchar(30) not null primary key,
        Hostname varchar(80) NULL,
        PublicHostname varchar(80) NULL,
	Uptime varchar(15) NULL,
	LoadAverage float NULL,
	CPUCount smallint NULL,
	CFEPercent smallint NULL,
	OS varchar(50) NULL,
        LastUpdated datetime NULL
);
