<h1 id="welcome-to-pg-cool">Welcome to PG Cool!</h1>

<p>A tiny little program in shell to turn easy managment of a <strong>PostgreSQL</strong>  database</p>

<hr>



<h2 id="installation-folder-and-files">Installation, folder and files</h2>

<p>I created this application to use inside my project versioned by git, with her it’s easy to manage backups and versions among database inside git.</p>

<p>For example, if I make changes in database I’ll execute a command to update script, commit and push this change. So another person thats work in same project just need execute a git pull and a comand to update her database.</p>

<p>To setup PG Cool inside your project, just you download this file inside any folder you want.</p>

<p>In my project and example below, is installed inside a folder named database</p>

<blockquote>
  <p><strong>After installed:</strong></p>
  
  <ul>
  <li>Your script will be mantained inside a ‘database’ folder with this scope: <br>
    <i class="icon-file"></i> postgre.sh <br>
    <i class="icon-file"></i> mydatabase.sql (that can be versioned by git \o/ ) <br>
    <i class="icon-folder-open"></i> backups  <br>
  |                  |        <i class="icon-file"></i> bckp_database123010231.sql</li>
  </ul>
</blockquote>



<h4 id="update-my-database"><i class="icon-refresh"></i> Update my Database</h4>

<p>This option will be create a backup of the current database, delete the current database so create a new database and import the SQL,inside: mydatabase.sql at script folder;</p>



<h4 id="update-script-to-sync"><i class="icon-upload"></i> Update script to sync</h4>

<p>Do you make changes on your DB and want to sync this in git? It’s easy, select this option to create a SQL with a dump of your database </p>



<h4 id="create-a-backup"><i class="icon-hdd"></i> Create a backup</h4>

<p>Create a backup of you database inside folder backups</p>



<h4 id="restore-my-last-backup"><i class="icon-hdd"></i> Restore my last backup</h4>

<p>Easy way to restore the version to the last backup. Remember, all backups will be saved so you can select any backup to restore, but this function is unavaliable for now.</p>



<h4 id="change-settings"><i class="icon-pencil"></i> Change settings</h4>

<p>In this option you can set the current database name, database user and password.</p>



<h2 id="contributing">Contributing</h2>

<p>Pull requests and stars are always welcome. For bugs and feature requests, <a href="https://github.com/ovictoraurelio/pgcool">please create an issue</a></p>



<h2 id="authors">Authors</h2>

<p><a href="http://victoraurelio.com">Victor Aurélio</a></p>