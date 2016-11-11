# CFEngine 3.7 promises for Amazon EC2


## Synopsis

Baseline cfengine-community-3.7.* promises for managing AWS EC2 instances. Performs sshd, ntpd, and rsyslog configuration, keeps important services running, watches filesystem space, and checks for package security updates.

(Also see "Optional features" section below. Promises can optionally back up filesystems to S3 and send syslog to RDS.)

Supported OSes:
* Amazon Linux AMI releases 2015.09, 2016.03
* Debian 8
* RHEL 6, RHEL 7


## Quick note on JSON configuration files

Always, **always** validate your JSON after editing it, or else CFEngine promises will break on and/or ignore invalid JSON. This promise ruleset installs a simple utility for doing so.

```
# json-valid my-conf.json
```


## Deploy to CFEngine hub

To get started on a new hub system, install the [CFEngine package](https://cfengine.com/product/community/) and clone this git repository.

Next, perform the following steps:

```
# cp -r ./ec2-cfengine37/masterfiles/* /var/cfengine/masterfiles
# cp -r /var/cfengine/masterfiles/* /var/cfengine/inputs
# service cfengine3 restart
# cf-agent --bootstrap 172.31.15.0
```

* Replace 172.31.15.0 with your hub's VPC internal IP address (i.e. bootstrap to yourself).
* Remember to add a rule to your EC2 Security Group to allow in TCP 5308 from your VPC.



## Deploy to CFEngine agent

As you launch new EC2 instances, use the following in Configure Instance Details -> Advanced Details -> User Data.

For EL-based systems (Amazon Linux, RHEL):

```
#!/bin/bash
yum -y install https://s3-us-xyz.amazonaws.com/my.org.packages/cfengine-community-3.7.3-1.x86_64.rpm
/var/cfengine/bin/cf-agent --bootstrap 172.31.15.0
```

For Debian systems:

```
#!/bin/bash
wget -O cfe.deb https://s3-us-xyz.amazonaws.com/my.org.packages/cfengine-community_3.7.3-1_amd64.deb
dpkg -i cfe.deb
/var/cfengine/bin/cf-agent --bootstrap 172.31.15.0
```

* Replace the https URI with the URI for a cfengine-community-3.7 package. (Be polite and copy a package to your own `my.org.packages` S3 bucket, then refer to it in EC2 User Data.)
* Replace 172.31.15.0 with your hub's VPC internal IP address


---


# Optional features


## Filesystem backups and other promise behavior tweaks

Configurable per-agent (per-EC2 instance) features are managed in the `/usr/local/etc/cfengine.json` configuration file. The default that's installed if none exists contains:

```
{
    "backup": "disable",
    "backupDirectories": [
        "/root",
        "/etc",
        "/usr/local/etc"
    ],
    "backupS3Bucket": "my.org.changethis.bkups",
    "securityUpdates": "disable",
    "sshdPasswordAuth": "disable"
}
```

* backup: controls whether backups run ("enable"|"disable")
* backupDirectories: local directories that will be pushed to S3
* backupS3Bucket: name of S3 bucket to push backups to
* securityUpdates: controls whether `yum --security` packages are automatically installed ("enable"|"disable")
* sshdPasswordAuth: controls whether password authentication is enabled in `sshd_config` ("enable"|"disable")


## Push encrypted backups (tarballs) to AWS S3

Automatic (encrypted) backups can be activated by completing the following steps.


### One-time AWS setup

1. Using AWS S3, create a bucket for backups. Note that [S3 bucket names must be globally-unique](http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html) (across all customer accounts!), so utilize a consistent prefix or suffix to help ensure uniqueness, e.g. `s3://my.org.encbkups/`
2. Using AWS IAM, create a service account via IAM with permissions to write to the S3 bucket.
3. On the CFEngine hub, create the file `masterfiles/services/autorun/z01_secrets/bkup-to-s3-creds.json` using the new IAM service account credentials.
4. On the CFEngine hub, create the file `masterfiles/services/autorun/z01_secrets/bkup-to-s3.key.txt` - and put a **strong** file encryption key inside it. This key will be used to AES-encrypt (and decrypt, if/when needed) your backup tarballs.
5. On each CFEngine agent system, modify "backup*" values in `/usr/local/etc/cfengine.json` as needed.


## Send logs and EC2 instance info to AWS RDS (MariaDB, MySQL)


### DB setup

Run the SQL in this project's `sql` directory. (Update the SQL to use strong service account passwords before running it.)

```
$ _host='db.xyzxyz.us-southwest-88.rds.amazonaws.com'
$ mysql -u root -h "${_host}" -p < sql/setup-dbs.sql 
$ mysql -u root -h "${_host}" -p < sql/setup-service-accounts.sql 
```


### CFEngine configuration

On the CFEngine hub, update a special JSON file with your newly-created table and service account info.

```
# cd /cfe-master/z01_secrets
# cp mysql-creds.json.EXAMPLE mysql-creds.json
# vi mysql-creds.json

```

Once this JSON file is populated, CFEngine will automatically deploy the changes to push certain syslog messages and EC2 instance info to RDS. Check out [simple-ommysql-viewer](https://github.com/ecs-hk/simple-ommysql-viewer) to view the end result.
