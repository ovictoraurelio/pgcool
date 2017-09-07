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
