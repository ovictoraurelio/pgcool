#!/bin/bash
# ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥
# ♥
# ♥					A script made in shell to manage version and backups of my Database PostgreSQL
# ♥
# ♥					@author ovictoraurelio
# ♥					@github http://github.com/ovictoraurelio
# ♥					@website http://victoraurelio.com
# ♥
# ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ 

function head {
    clear;        
    printf "${wht}\n\n\t---------------------  SYNC OF POSTGRES DB ---------------------- ";    
    printf "\n\n\n\t\t\t\t\t\t made by @ovictoraurelio\n\t\t\t\t\t\t\t  type H to help";    
}
function subHead {
    printf "\n\n\n\tDB: ${blu}$DATABASE ${wht}| User: ${blu}$USER ${wht}| Password: ${blu}$PASS${wht}"
    printf "\n\tDB Folder at directory: ${yel}$DIR${wht}"
}
function inputU {
    printf "\t${wht}$1: ${blu}" 
}
function p {
    printf "\n\t${wht}$1$2$3"
}
function doing {
    printf "\n\t${blu}$1$2$3${yel}"
}
function finished {
    printf "\n\n\t${gre}$1$2$3${yel}"
}
function warn {
    printf "\n\t${yel}$1$2$3"
}
function error {
    printf "\n\n\t${red}$1$2$3${wht}"
}
function showMenu {
    head;
    subHead;    
    printf "\n\n\n\t1) Update my Database "
    printf "\n\t2) Update structure of my database"
    printf "\n\t3) Update script to sync "
    printf "\n\t4) Create a backup all data "
    printf "\n\t5) Create a backup of structure "    
    printf "\n\t6) Restore to my last backup"
    printf "\n\t7) Change settings"   
    printf "\n\t8) Create data"
    printf "\n\t9) Update data"
    printf "\n\t10) Drop database and create new"
    printf "\n\tQ) Quit"
    printf "\n\n\tOption: "
}
function loadSettings {
    doing "Loading settings"
    DATABASE="$(sed -n '1p' < ~/.settings_pgcool)";
    USER="$(sed -n '2p' < ~/.settings_pgcool)";
    PASS="$(sed -n '3p' < ~/.settings_pgcool)";
    finished "Settings loaded"
}
function editSettings {        
    inputU "\n\n\tDatabase name"
    read DATABASE
    inputU "User"
    read USER
    inputU "Password"    
    read PASS
    #storing variables
    if [ ! -d $DIR/backups ]; then  
        doing "Creating backup folder at: $DIR/backups\n\t${wht}"
        mkdir $DIR/backups
    fi
    doing "Saving settings..."        
    touch ~/.settings_pgcool
    #with just one > to clean content if exist.
    echo $DATABASE > ~/.settings_pgcool
    echo $USER >> ~/.settings_pgcool
    echo $PASS >> ~/.settings_pgcool    
    finished "Settings saved with success! "
   
    loadSettings
}
function settings {    

    if [ ! -f ~/.settings_pgcool ]; then       
        #settings found
        head;
        p "\n\n\tIt's your first time using the script in this computer let's configure at all. "
                
        editSettings
        
        warn "Please verify that you running this shell script as: "
        doing "$ source script.sh "
        warn "Instead of "
        doing "$ bash script.sh "
        warn "To alias work to you"
        doing "Creating alias: pgcool"
        alias pgcool='bash $DIR/postgre.sh'        
        finished "Now you just call: pgcool in terminal."
        warn "if you don't execute as source script.sh execute: alias pgcool='bash $DIR/postgre.sh'"

        read t -p  
    else
        #reading settings        
        loadSettings;
    fi
}
function help {
    head
    p "\n\t******* Help center \n"    
    error "*Permissions to execute postgres calls"
    p " If can't you execute: psql -U $USER "
    doing "\t$ locate pg_hba.conf"
    p "\tat the line: "
    p "\tlocal         all             postgres            peer"
    p "\tinstead peer you use: md5;"
    p "\tAfter this restart postegrsql"
    doing "\t$ sudo service postgresql restar"    
}

function createBackup {
    doing "Creating backup... "
    CURDATE="$(date +"%Y%m%d%H%M")"
    PGPASSWORD="$PASS" pg_dump -U $USER  $DATABASE > $DIR/backups/bckp_$DATABASE_$CURDATE.sql 
    finished "Backup successfully created."
}

function createStructureBackup {
    doing "Creating backup only structure... "    
    CURDATE="$(date +"%Y%m%d%H%M")"
    PGPASSWORD="$PASS" pg_dump --schema-only  -U $USER  $DATABASE > $DIR/structure_$DATABASE.sql
    finished "Backup successfully created."
}

function createDataBackup {
    doing "Creating backup only data... "    
    CURDATE="$(date +"%Y%m%d%H%M")"
    PGPASSWORD="$PASS" pg_dump  --column-inserts --data-only  -U $USER  $DATABASE > $DIR/data_$DATABASE.sql
    finished "Backup successfully created."   
}

function dropCreate {
    createBackup
    doing "Drop current database...";    
    PGPASSWORD="$PASS" dropdb -U $USER  $DATABASE
    if [ $? -eq 0 ]; then
        doing "Creating new database...";
        PGPASSWORD="$PASS" createdb -U $USER  $DATABASE;
    else 
        error "Please close POSTICO haha.\n";
    fi
}

function updateStructure {
    doing "updating structure"
    CURDATE="$(date +"%Y%m%d%H%M")"
    PGPASSWORD="$PASS" psql -U $USER -d $DATABASE -f $DIR/structure_$DATABASE.sql
    finished "Structure successfully created."
}

function updateData {
    doing "updating structure"
    CURDATE="$(date +"%Y%m%d%H%M")"
    PGPASSWORD="$PASS" psql -U $USER -d $DATABASE -f $DIR/data_$DATABASE.sql
    finished "Structure successfully created."
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
wht=$(tput sgr0);red=$(tput setaf 1);gre=$(tput setaf 2);yel=$(tput setaf 3);blu=$(tput setaf 4);

while ((1))
do
    settings
    showMenu    
    read NUM
    case $NUM in
        1)         
            dropCreate
            doing "Importing new database...\n";
            PGPASSWORD="$PASS" psql -U $USER  -d $DATABASE -f $DIR/$DATABASE.sql ;
            finished "Database successfully updated!"
        ;;
        2)
            updateStructure
        ;;
        3)  
            doing "Updating $DATABASE.sql\n"       
            PGPASSWORD="$PASS" pg_dump -U $USER  $DATABASE > $DIR/$DATABASE.sql ;
            finished "Script successfully updated!";
        ;;
        4)            
            createBackup
        ;;
        5)
            createStructureBackup
        ;;
        6) 
            if ls $DIR/backups/*.sql 1> /dev/null 2>&1; then
                FILE="$(ls -t $DIR/backups/*.sql | head -n1)";
                #ls -t $DIR/backups/*.sql | head -n1 |awk '{printf("newest file: %s",$0)}'
                doing "The most recent backup founded is: " $FILE;                
                dropCreate;
                doing "Restoring database...\n";
                PGPASSWORD="$PASS" psql -U $USER -d $DATABASE -f $FILE ;
                finished "Database restored with success!"
            else
                error "Doesn't exist any backup file.";
            fi        
        ;;
        7)
            head;
            subHead;
            editSettings;
        ;;
        8)
            createDataBackup
        ;;
        9)
            updateData
        ;;
        10)
            dropCreate
        ;;
        H|h)
            help;
        ;;
        Q|q)
            printf "\n\tQuiting, bye bye\n"            
            break
        ;;
        *) 
            error "Invalid option !!! ";
        ;;        
    esac  
    read t -p  
done
