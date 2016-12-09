I encountered a couple of problems when trying to do development and testing in Debian Linux 7.3 (aka Debian wheezy) and PostgreSQL 9.1

The first symptom was a complaint that a database could not be created because of a locale error. This can occur with `db:create` or `db:init` or `db:test:prepare`. Locale is what systems use to customize character set, sort order and date style to a particular culture. At LocalSupport, as of February 2014, our locale  is specified by the `encoding: unicode` line in [database.yml](https://github.com/AgileVentures/LocalSupport/blob/master/config/database.yml). An example of the error is:

````
bundle exec rake db:test:prepare
...          
PG::InvalidParameterValue: ERROR:  encoding UTF8 does not match locale en_GB
DETAIL:  The chosen LC_CTYPE setting requires encoding LATIN1.
: CREATE DATABASE "ls_test" ENCODING = 'unicode'
/home/david2/.rvm/gems/ruby-1.9.3-p448/gems/activerecord-3.2.14/lib/active_record/connection_adapters/postgresql_adapter.rb:650:in `exec'
...
````

When fixing this I came across user authentication errors like this:

````
$ bundle exec rake db:create
...
FATAL:  Peer authentication failed for user "postgres"
...
Couldn't create database for {"adapter"=>"postgresql", "encoding"=>"unicode", "database"=>"ls_develo
pment", "pool"=>5, "username"=>"postgres", "password"=>nil}
````

## Database user management in Debian ##

User authentication errors look something like this:

````
$ bundle exec rake db:create

            You no longer need to have jasmine.rake in your project, as it is now automatically loaded
           from the Jasmine gem. To silence this warning, set "USE_JASMINE_RAKE=true" in your environment
           or remove jasmine.rake.
          
FATAL:  Peer authentication failed for user "postgres"
/home/david2/.rvm/gems/ruby-1.9.3-p448/gems/activerecord-3.2.14/lib/active_record/connection_adapter
s/postgresql_adapter.rb:1222:in `initialize'
...
````

First, see [[Installation#peer authentication fails for user postgres]]

Another quick solution is to change the postgres cluster settings so that the your unix `postgres` user automatically authenticates to the cluster. Edit the first uncommented line of `/etc/postgresql/9.1/main/pg_hba.conf` so that it looks like this:

>` local   all             postgres                                trust`

(Usually you just have to swap `peer` for `trust`)

Then reload the configs

>` sudo -u postgres /etc/init.d/postgresql reload`

## Locale management in Debian ##

You need to set the locale of the `postgres` unix user to be en_US.UTF-8, before you create a database cluster. A cluster is the place in your machine that stores a group of databases. A development machine probably one has one cluster, called, by default `9.1 main`. However, Debian probably created this cluster for you when it installed. If the default locale in your machine is wrong, you will need to 

1. Set the locale for the `postgres` unix user.

    > `$ sudo su - postgres`

    If your locale looks like this, move on to the next step.

    ````
    postgres@methone:~$ locale
    LANG=en_US.UTF-8
    LC_CTYPE="en_US.UTF-8"
    LC_NUMERIC="en_US.UTF-8"
    LC_TIME="en_US.UTF-8"
    LC_COLLATE="en_US.UTF-8"
    LC_MONETARY="en_US.UTF-8"
    LC_MESSAGES="en_US.UTF-8"
    LC_PAPER="en_US.UTF-8"
    LC_NAME="en_US.UTF-8"
    LC_ADDRESS="en_US.UTF-8"
    LC_TELEPHONE="en_US.UTF-8"
    LC_MEASUREMENT="en_US.UTF-8"
    LC_IDENTIFICATION="en_US.UTF-8"
    LC_ALL=
    ````

    If not, consult Debian docs for solutions:
    * https://wiki.debian.org/Locale

2. Find out the name of your cluster

        $ pg_ls
        Version Cluster   Port Status Owner    Data directory                     Log file
        9.1     main      5432 down   postgres /var/lib/postgresql/9.1/main       /var/log/postgresql/postgresql-9.1-main.log

    This one is called `9.1 main`.
    _NOTE_ On Ubuntu, the command is 'pg_lsclusters'.

3. Drop the cluster

    !!! **WARNING** - the next command **deletes all the data**, tables, passwords and settings in all your PostgreSQL databases !!!

    >     $ pg_dropcluster --stop 9.1 main

4. Create a new cluster

    >     $ pg_createcluster 9.1 main

5. Create, migrate and seed your LocalSupport databases as described in the normal installation instructions.  You should get normal NOTICEs such as:

````
david2@methone:~/LocalSupport$ bundle exec rake db:test:prepare`

            You no longer need to have jasmine.rake in your project, as it is now automatically load
ed
            from the Jasmine gem. To silence this warning, set "USE_JASMINE_RAKE=true" in your envir
onment
            or remove jasmine.rake.
          
NOTICE:  CREATE TABLE will create implicit sequence "categories_id_seq" for serial column "categorie
s.id"
NOTICE:  CREATE TABLE / PRIMARY KEY will create implicit index "categories_pkey" for table "categori
es"
...
````

When the cluster is successfully created, your databases and templates should all have the same encoding, collate and Ctype, as in this example:

````
ls_development=# \l
                                    List of databases
      Name      |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
----------------+----------+----------+-------------+-------------+-----------------------
 ls_development | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 ls_test        | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres       | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
                |          |          |             |             | postgres=CTc/postgres
 template1      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
                |          |          |             |             | postgres=CTc/postgres
(5 rows)
````

You can use Postgres commands to create databases that override the defaults in your system, but then you lose some of the automated help you get when you manage your Rails server with `rake` tasks.

## Further reading ##

* Details on working with PostgreSQL on Debian are [on the Debian Wiki](https://wiki.debian.org/PostgreSql).
* Postgres commands to create database with non-standard locales are [in Chapter 22 of the manual (Localization)](http://www.postgresql.org/docs/current/static/multibyte.html#AEN33765).
* http://stackoverflow.com/questions/6579621/lc-collate-and-lc-ctype-suport-for-utf-8-in-postgresql
* https://code.google.com/p/winelocale/wiki/AddLocalesToDebian
* http://programming.aiham.net/2011/07/26/changing-locale-of-postgresql-db-cluster/
* https://wiki.debian.org/Locale