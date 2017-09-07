Welcome to PG Cool!
===================


A tiny little program in shell to turn easy managment of a **PostgreSQL**  database

----------


Installation, folder and files
-------------

I created this application to use inside my project versioned by git, with her it's easy to manage backups and versions among database inside git.

For example, if I make changes in database I'll execute a command to update script, commit and push this change. So another person thats work in same project just need execute a git pull and a comand to update her database.

To setup PG Cool inside your project, just you download this file inside any folder you want.

In my project and example below, is installed inside a folder named database

> **After installed:**

> - Your script will be mantained inside a 'database' folder with this scope:
>       <i class="icon-file"></i> postgre.sh
>       <i class="icon-file"></i> mydatabase.sql (that can be versioned by git \o/ )
>       <i class="icon-folder-open"></i> backups 
>   |                  |        <i class="icon-file"></i> bckp_database123010231.sql

#### <i class="icon-refresh"></i> Update my Database

This option will be create a backup of the current database, delete the current database so create a new database and import the SQL,inside: mydatabase.sql at script folder;

#### <i class="icon-upload"></i> Update script to sync

Do you make changes on your DB and want to sync this in git? It's easy, select this option to create a SQL with a dump of your database 


#### <i class="icon-hdd"></i> Create a backup

Create a backup of you database inside folder backups

#### <i class="icon-hdd"></i> Restore my last backup

Easy way to restore the version to the last backup. Remember, all backups will be saved so you can select any backup to restore, but this function is unavaliable for now.

#### <i class="icon-pencil"></i> Change settings

In this option you can set the current database name, database user and password.

## Contributing

Pull requests and stars are always welcome. For bugs and feature requests, [please create an issue](https://github.com/ovictoraurelio/pgcool)

## Authors

[Victor Aurélio]

[Victor Aurélio]: <http://victoraurelio.com>