---
title: Migrate Travis CI Enterprise Database to 3.x
layout: en_enterprise

---

This document describes the steps necessary for database migration from an existing Travis CI Enterprise 2.2.6+ version to Travis CI Enterprise 3.x (TCIE 3.x). The migration is not required for clean installations of Travis CI Enterprise 3.x (with an empty database).

## Overview

The TCIE 3.x runs over Postgresql v11 and features a slightly different database schema, synchronized with the Travis CI Hosted solution. Since TCIE 3.x is deployed as a Kubernetes cluster, PostgreSQL is now one of the pods (TCIE 2.x had every dependency embedded in one large Docker image).

The main schema differences are:
* In TCIE 3 databases for *logs* and *main* are now separated.
* The *_configs* schema in the new TCIE 3 *main* database is a bit different from the one in TCIE 2.2, and thus, this part will not be migrated during the following process; that means for builds done before the migration, the users won't have the `.travis.yml` contents relevant to these builds available in the Web User Interface.

## Migration Preparation

1. The first but optional step is removing unnecessary data to make your dump lighter. You can do it using [travis-backup gem](https://rubygems.org/gems/travis-backup). We recommend running the following commands after installing the gem:
    - to remove orphaned data: `travis_backup 'postgres://your_db_url' --remove_orphans`
    - to remove requests, builds, jobs, and logs older than 6 months: `travis_backup 'postgres://your_db_url' --threshold 6`
2. You will need to dump the existing TCIE 2.x (single docker image) PostgreSQL database into two files:
   1. main database, which should be a copy of the current existing DB from Travis CI Enterprise 2.2.x (TCI E 2.2.x - one docker solution)
   2. logs database, which should contain only two tables: logs and log_parts from the main database
3. For both aforementioned databases you need to have following credentials which will be used during Travis CI Enterprise 3.0.x (TCI E 3.0.x - k8s solution) installation process:
    - DB name
    - DB user
    - DB password
    - DB host
    - DB port
4. You will need an encryption key, which can be found in the current TCI E 2.2.x installation:
    - ssh to platform
    - call: 
    ```bash
    travis bash call: cat /usr/local/travis/etc/travis/config/travis.yml | grep -A 1 "encryption:"
    ```
    - note it down on a piece of paper or a different computer

> Before migrating the DB, we **strongly recommend** storing a DB snapshot or making an additional copy of the DB dump.

## Migration Example

The following section shows an example of a migration. 

### Dump the main database and logs as separate databases

Perform travis bash to the platform (inside the container) and run the following commands: 
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

> This is the last moment you can back up the dump files!

### Alter the Database Dumps

Assuming you have used the Travis CI Enterprise 2.2 internal database (one delivered with the 2.2 release in the master image), please perform the replacement of DB owner identifiers in the database dumps: 

```bash
sed -i '' 's/Owner: travis/Owner: postgres/g' TCI_E_2_0_db_schema_dump_main_tables_platform_docker_20200324.sql
sed -i '' 's/OWNER TO travis/OWNER TO postgres/g' TCI_E_2_0_db_schema_dump_main_tables_platform_docker_20200324.sql 
```

**PLEASE NOTE**: 
1. Please reconfirm the existing database owner name directly via PSQL query or command line tool. If required, unify/change it to a single user using psql tooling/queries before any further operation is executed.
1. If you use an external database (not from the Travis CI Enterprise 2.2 release) and wish to continue so you do not have to perform the above step. Just use the database owner credentials from Travis CI Enterprise 2.2 in Travis CI Enterprise 3.x configuration.
2. If you use an external database (not from the Travis CI Enterprise 2.2 release) and wish to cease to do so and use a database delivered as a pod in Travis CI Enterprise 3.3, in the above bash commands, change the following fragments

`Owner: travis` to `Owner: {your external tcie 2.2 database owner}`

`OWNER TO travis` to  `OWNER TO {your external tcie 2.2 database owner}`



### Enable the Altered Dumps

Make your dump files available under any `http` address visible for your target Enterprise 3.0 cluster. This serves the purpose of TCIE 3.x installer to be able to download them and migrate the data automatically.

### Install TCIE 3.x Providing the Dumps and Key

Make sure you have provided the encryption key from the existing TCIE 2.x installation in the TCIE 3.x GUI:

![TCIE 3.X Install GUI: Encryption key input](/images/tcie-3.x-input-for-encryption-key.png)

Once the GUI of the Enterprise 3.0 KOTS installer is visible, provide these addresses in:

SQL Schema from 2.2 -> set to yes ->
* Platform SQL Schema URL from 2.2
* Log SQL Schema URL from 2.2

![TCIE 3.X Install GUI: DB Dumps input](/images/tcie-3.x-input-for-db-dumps.png)

Once the installer completes the work, your database should be successfully migrated.

> Important!
Because TCIE 3.x uses original configs `raw_configs` (as in `.travis.yml`) and there is no way to restore such `raw_configs` from the old normalized versions from  `[request|build|job]_configs` - these will be not migrated. The drawback is that no historical configs are available for the end user in the travis-web app.

## Summary
- main DB from TCI E 2.X is split into two databases in TCIE 3.x: *main* and *logs*.
- old configs from logs, builds, and requests (column: `config`) are not migrated into new tables `[request|build|job]_configs`.
- old not used config columns from `[requests|builds|jobs]` are dropped.
- new tables are created for configs for future build runs: `[request|build|job]_configs`.
- new table for raw config is created for future build runs `request_raw_configs`.
