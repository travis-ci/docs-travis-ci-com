---
title: Migrating Travis CI Enterprise Database from 2.2.6+ to 3.x
layout: en_enterprise

---

This document describes steps necessary for database migration from existing Travis CI Enterprise 2.2.6+ version to Travis CI Enterprise 3.x (TCIE 3.x). The migration is not required for clean installations of Travis CI Enterprise 3.x (with an empty database).

## Overview

The TCIE 3.x runs over Postgresql v11 and features a bit different database schema, synchronized with Travis CI Hosted solution. Since TCIE 3.x is deployed as Kubernetes cluster, PostgreSQL is now one of the pods (TCIE 2.x had every dependency embedded in one large Docker image).

The main schema differences are:
* databases for *logs* and *main* are now separated
* the *_configs* schema in new *main* database is a bit different and thus this part will be not migrated during the following process; that means for builds done before the migration the users won't have the `.travis.yml` contents relevant to these builds available in the web User Interface

## Preparing to the Migration

1. You will need to dump existing TCIE 2.x (single docker image) PostgreSQL database into two files:
   1. main database which should be a copy of current existing DB from Travis CI Enterprise 2.2.x (TCI E 2.2.x - one docker solution)
   2. logs database which should contain only two tables: logs and log_parts from the main database
2. For both aforementioned databases you need to have following credentials which will be used during Travis CI Enterprise 3.0.x (TCI E 3.0.x - k8s solution) installation process:
    - DB name
    - DB user
    - DB password
    - DB host
    - DB port
3. You will need encryption key which can be found in current TCI E 2.2.x installation:
    - ssh to platform
    - call: 
    ```bash
    travis bash call: cat /usr/local/travis/etc/travis/config/travis.yml | grep -A 1 "encryption:"
    ```
    - note it down on a piece of paper or at different computer

> Before migrating the DB, we **strongly recommend** to store a DB snapshot or make additional copy of DB dump.

## Example Migration 

### Dump main database and logs as 2 separate databases

Perform travis bash to the platform (inside the container) and run following commands: 
```bash
root@te-main:/# pg_dump -U travis -h 127.0.0.1 -p 5432 -C -t log_parts -t logs -d travis_production > TCI_E_2_0_db_schema_dump_logs_tables_platform_docker_20200324.sql
root@te-main:/# pg_dump -U travis -h 127.0.0.1 -p 5432 -C -d travis_production > TCI_E_2_0_db_schema_dump_main_tables_platform_docker_20200324.sql
```
The port number defaults to `5432`, or the value of the PGPORT environment variable (if set).

### Copy Database dumps to the container host

On the Enterprise 2.2 platform machine, copy dumps from container to host: 
```bash
sudo docker ps
sudo docker cp sleepy_dewdney:/TCI_E_2_0_db_schema_dump_main_tables_platform_docker_20200324.sql .
sudo docker cp sleepy_dewdney:/TCI_E_2_0_db_schema_dump_logs_tables_platform_docker_20200324.sql .
```

Optionally copy it to your local machine to perform further steps, e.g.: 
```bash
scp yourusername@travis-host.yourdomain.com:/TCI_E_2_0_db_schema_dump_main_tables_platform_docker_20200324.sql
scp yourusername@travis-host.yourdomain.com:/TCI_E_2_0_db_schema_dump_logs_tables_platform_docker_20200324.sql
```

As a result, you should have both database files available for further processing.

> This is the last moment you can make a backup of the dump files!

### Alter the Database Dumps

Perform replacement of DB owner identifiers in the database dumps: 
```bash
sed -i '' 's/Owner: travis/Owner: postgres/g' TCI_E_2_0_db_schema_dump_main_tables_platform_docker_20200324.sql
sed -i '' 's/OWNER TO travis/OWNER TO postgres/g' TCI_E_2_0_db_schema_dump_main_tables_platform_docker_20200324.sql 
```
### Make the Altered Dumps Available

Make your dump files available under any `http` address visible for your target Enterprise 3.0 cluster. This serves the purpose of TCIE 3.x installer to be able to download them and migrate the data automatically.

### Install TCIE 3.x Providing the Dumps and Key

Make sure you have provided the encryption key from existing TCIE 2.x installation in the TCIE 3.x GUI:

![TCIE 3.X Install GUI: Encryption key input](/images/tcie-3.x-input-for-encryption-key.png)

Once the GUI of Enterprise 3.0 KOTS installer is visible, provide these addresses in:

SQL Schema from 2.2 -> set to yes ->
* Platform SQL Schema URL from 2.2
* Log SQL Schema URL from 2.2

![TCIE 3.X Install GUI: DB Dumps input](/images/tcie-3.x-input-for-db-dumps.png)

Once the installer completes the work, your database should be succesfully migrated.

> Important!
Due to the fact that TCIE 3.x uses original configs `raw_configs` (as in `.travis.yml`) and there is no way to restore such `raw_configs` from the old normalised versions from  `[request|build|job]_configs` - these will be not migrated. The drawback is that no historical configs are available in the travis-web app for the end user.

## Summary
- main DB from TCI E 2.X is split into two databases in TCIE 3.x: *main* and *logs*
- old configs from logs, builds, requests (column: `config`) are not migrated into new tables `[request|build|job]_configs`
- old not used config columns from `[requests|builds|jobs]` are dropped
- new tables are created for configs for future build runs: `[request|build|job]_configs`
- new table for raw config is created for future build runs `request_raw_configs`
