-- Change "somepassword" below to strong password values, then uncomment
-- the two CREATE USER statments before executing.

--CREATE USER 'cfewriter'@'%' IDENTIFIED BY 'somepassword';
--CREATE USER 'cfereader'@'%' IDENTIFIED BY 'somepassword';

GRANT SELECT, INSERT, DELETE ON CFEdata.SystemEvents TO 'cfewriter'@'%';
GRANT SELECT, INSERT, DELETE ON CFEdata.SystemEventsProperties TO 'cfewriter'@'%';
GRANT SELECT, INSERT, DELETE ON CFEdata.ServerInfo TO 'cfewriter'@'%';

GRANT SELECT ON CFEdata.SystemEvents TO 'cfereader'@'%';
GRANT SELECT ON CFEdata.SystemEventsProperties TO 'cfereader'@'%';
GRANT SELECT ON CFEdata.ServerInfo TO 'cfereader'@'%';

FLUSH PRIVILEGES;
