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
    printf "\n\t2) Update script to sync "
    printf "\n\t3) Create a backup "
    printf "\n\t4) Restore to my last backup"
    printf "\n\t5) Change settings"   
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
        doing "Creating alias: dbcool"        
        finished "Now you just call: dbcool in terminal."
        warn "if you don't execute as source script.sh execute: alias dbcool='bash $DIR/postgre.sh'"

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


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
DATABASE=defaultDatabase
USER=defaultUser
PASS=defaultPass

clear
echo "\n\n";
echo "\t---------------------  SYNC OF POSTGRES DB ---------------------- ";
echo "\n\n";
echo "\t\t\t\t\t\t made by @ovictoraurelio";
echo "\n\n";
echo "\tDB: $DATABASE | User: $USER | Password: $PASS";
echo "\tDB Folder at directory: $DIR";
echo " ";
echo "\t1) Update my Database ";
echo "\t2) Update script to sync ";
echo "\t3) Create a backup ";
echo "\t4) Restore to my last backup";        
echo "\t5) --upComing*Change settings\n\t";
read NUM
case $NUM in
	1)         
        echo "\t Creating backup... ";    
        CUR_DATE="$(date +"%Y%m%d%H%M")";    
        pg_dump -U $USER $DATABASE > $DIR/backups/bckp_$DATABASE_$CURDATE.sql ;
        echo "\t Drop current database... ";
        dropdb -U $USER  $DATABASE
        echo "\t Creating new database... ";
        createdb -U $USER  $DATABASE
        echo "\t Installing new database... ";
        psql -U $USER  -d $DATABASE -f $DIR/$DATABASE.sql ;
    ;;
    2)         
        pg_dump -U $USER  $DATABASE > $DIR/$DATABASE.sql ;
        echo "\t Script successfuly updated! ";
    ;;
    3)            
        echo "\t Creating backup... ";        
        CURDATE="$(date +"%Y%m%d%H%M")";
        pg_dump -U $USER  $DATABASE > $DIR/backups/bckp_$DATABASE_$CURDATE.sql ;
        echo "\t Backup successfuly created."
    ;;
    4) 

        if ls $DIR/backups/*.sql 1> /dev/null 2>&1; then
            FILE="$(ls -t $DIR/backups/*.sql |head -n1)"        
            echo "\t The most recent backup founded is: " $FILE;
            echo "\t Drop current database... ";
            dropdb -U postgres $DATABASE;
            if [ $? -eq 0 ]; then
                echo "\t Creating new database... ";
                createdb -U $USER  $DATABASE
                echo "\t Restoring database... ";
                psql -U $USER  -d $DATABASE -f $FILE ;
            else    
                echo "\n\n\t Please close POSTICO haha.";
            fi
        else
            echo "\t Doesn't exist any backup file.";
        fi        
    ;;
    4)
        echo "Type new user: ";
        read USER;
        echo "Type new password: ";
        read PASS
    ;;
  *) echo " Invalid option ";

esac
