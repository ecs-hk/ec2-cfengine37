# CFEngine 3.7 promises for Amazon Linux

## Synopsis

Baseline promises for managing AWS EC2 instances running Amazon Linux. Designed to configure and watch key services, logging, filesystem space, and package security updates.

Tested with:
* `cfengine-community-3.7.1-1.x86_64.rpm` on Amazon Linux AMI release 2015.09

Official CFEngine packages:
https://cfengine.com/product/community/

## Deploy to CFEngine hub

### One-time install and setup

On the hub system, install the CFEngine package and clone this git repository. Then:

```
# cp -r ./ec2-cfengine37/masterfiles/* /var/cfengine/masterfiles

# cp -r /var/cfengine/masterfiles/* /var/cfengine/inputs

# service cfengine3 restart
```

### Customize for your environment

Edit vars.acl in `/var/cfengine/masterfiles/def.json` to include subnets you wish to allow in.

Always, **always** validate your JSON after editing it, or else CFEngine will silently ignore it.

```
# python -m json.tool < def.json
```

You will also need to add a rule to your AWS Security Group to allow in TCP 5308 from CFEngine agents to the CFEngine hub.

### Bootstrap to yourself

This bootstrapping step will put the hub under CFEngine management, just like all managed agents.

```
# cf-agent --bootstrap 172.31.21.122
```

Use the IP address of your CFEngine hub instead of the above.

## Deploy to CFEngine agent

### One-time install, then bootstrap to the hub

On each agent system, install the CFEngine package. Then:

```
# cf-agent --bootstrap 172.31.21.122
```

Use the IP address of your CFEngine hub instead of the above.
