#!/bin/bash
# This is a script used to simulate a simple crud operations on database engine
__Author__="Islam Youssief"

#/******************** Creating the main dir of all dbs *********************************/
if [[ ! -d "DBs" ]]; then	
	mkdir "DBs";
fi

#/************************ Seperator between any taken actions **************************/
function seperator {
	echo "--------------------------------------------------------------"
}

#/***************************** Main Gui Of the script *********************************/
function  getMainMenu {
  seperator;
  echo -e "\n+~~~~~~~~~~Main Menu~~~~~~~~~~~~+"
  echo "| 1. Create New Database        |"
  echo "| 2. Use A Database             |"
  echo "| 3. Rename A Database          |"
  echo "| 4. Drop A Database            |"
  echo "| 5. Show All Database          |"
  echo "| 6. Exit                       |"
  echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+"
  echo -e "  Enter Your Choice: \c"
  read choice
  case $choice in
    1)  createDB 
		getMainMenu;
		;;


    2)  listAllDBs;
		useDB;
		;;


    3)  #listAllDBs;
		renameDB
		getMainMenu;
    	;;

    4)  seperator;
		dropDB;
		getMainMenu;
		;;

    5)  listAllDBs;
    	getMainMenu;
     	;;

    6)  exit ;;
    
    *)  echo " This Is Not A Valid Choice " ; 
		getMainMenu;
  esac
}

#/***************************** Creating a Database *********************************/
function createDB {
	path="DBs";
	printf 'Enter Your Database Name : '
	IFS= read -r name rest
	case $name in
	  	([[:alpha:]][[:alpha:]][[:alpha:]]*)

		if [[ ! -d $path/$name ]]; then	
			mkdir $path/$name;
			if [[ $? -eq 0 ]]; then
				echo $name "Was Created Successfully" ;
			else
				echo "Error While Creating $name Database" ;
			fi
		else	
			echo "Sorry But This Database is already Exists";
		fi
	  ;;
	  ([[:alpha:]]*) echo "DB Must start with at least 3 Characters !";;
	  ([[:digit:]]*) echo "DB can't start with a decimal digit !";;
	  ("") echo "Make sure to put a valid db name !";;
	  (*) echo "Special Characters are not allowed in db name !";;
	esac
	
}

#/***************************** list all Databases *********************************/
function listAllDBs {
	path="DBs";
	dbItem=1;
	if [[ `ls $path` = "" ]];then	
		echo "There Is No Database In Your DMBS !";
		getMainMenu;
		return 0;
	fi
	
	# putting all the dbs in the dblist
	for DBName in `ls $path`
	do
		DBList[$dbItem]=$DBName;
		let dbItem=dbItem+1;
	done
	
	# listing all the dbs stored in dblist
	echo "These Are All The Available Databases : ";
	dbItem=1;
	for DBName in `ls $path`
	do
		DBList[$dbItem]=$DBName;
		echo $dbItem") "$DBName;
		let dbItem=dbItem+1;
	done
	
}

#/***************************** Rename DataBase *********************************/
function renameDB {
	path="DBs";
	isExist="false";

	if [[ `ls $path` = "" ]]; then
			echo "There Is No Database To Be Renamed";	
	else
		echo -e "  Enter Database Name You want to change : \c"
		read currentDB
		for DB in `ls $path`
		do
			if [[ $currentDB == $DB ]]; then
				echo -e "  Enter New Database Name: \c"
				IFS= read -r newDB rest
				case $newDB in
					  	([[:alpha:]][[:alpha:]][[:alpha:]]*)
						if [[ ! -d $path/$newDB ]]; then	
							mv ./$path/$currentDB ./$path/$newDB
							if [[ $? -eq 0 ]]; then
								echo "Database Renamed Successfully with :"{ $newDB }
							else
								echo "Error While renaming $newDB Database" ;
							fi
						else	
							echo "Sorry But There Is Already A Database With The Same Name !";
						fi
					  ;;
					  ([[:alpha:]]*) echo "DB Must start with at least 3 Characters !";;
					  ([[:digit:]]*) echo "DB can't start with a decimal digit !";;
					  ("") echo "Make sure to put a valid db name !";;
					  (*) echo "DB can't start with a  Special Characters !";;
				esac
			fi
		done
	fi
}

#/***************************** Drop DataBase *********************************/
function dropDB {
	path="DBs";
	listAllDBs;
	read -p "  Enter a choice of which db to drop : " choise ;
	is_in ${DBList[$choise]} "${DBList[@]}";
	if [[  "$?" == "1" ]]; then
		read -p "Sure You want to Drop ${DBList[$choise]} [Y/N] " response;
		case $response in 
			[yY][eE][sS]|[yY]) 
	        	rm -r $path/${DBList[$choise]};
	        	echo "${DBList[$choise]} db was removed Successfully.."
				DBList[$choise]="";
				;;

	    	*)
				seperator;
				getMainMenu;
			;;
		esac	
	else
	{
		seperator;
		echo "Please enter a valid choice !";
		listAllDBs;
	}

	fi
}

# Check existance of value in a list
function is_in {
	local value
    for value in "${@:2}"
    do 
        if [[ "$value" == "$1" ]]
            then 
                return 1;
        fi 
    done
    # value is not in the list
    return 0
}
#/***************************** After Selecting A Database  *********************************/
#/**************************** Creating New Table *********************************/
function createTable {
	read -p "     Enter Table Name : " tableName ;
	DBPATH="DBs"
	if [[ ! -e $DBPATH/${DBList[$dbChoice]}/$tableName.tbl ]] && [[ $tableName != "" ]]
		then	
			touch $DBPATH/${DBList[$dbChoice]}/$tableName;
			chmod +x $DBPATH/${DBList[$dbChoice]}/$tableName;
			if [[ $? -eq 0 ]]; then
				echo -e "~~~~~~~~~~~~~~~~~ ~> $tableName Structure <~ ~~~~~~~~~~~" > $DBPATH/${DBList[$dbChoice]}/$tableName;
			    read -p "Enter Columns Number : " tableCol;
			    if [[ $tableCol -eq 0 ]]
					then
					echo -e "You must enter the column number !"
					rm $DBPATH/${DBList[$dbChoice]}/$tableName
					createTable;
					return $dbChoice;
				fi


			    echo "Number Of Columns ~> : $tableCol" >> $DBPATH/${DBList[$dbChoice]}/$tableName;
			   # echo -e "~~~~~~~~~~~~~~~~~ $tableName Columns ~~~~~~~~~~" 
			    for (( i = 1; i <= tableCol ; i++ )); do
			    	read -p "Enter name for column $i : " ColName ;

			    	if  [[ -n $ColName ]]
						then
							echo " "
						else
							echo -e "\nPlease enter a valid column name"
							rm $DBPATH/${DBList[$dbChoice]}/$tableName
							createTable;
							return $Cho;
						fi
			    	colArr[$i]=$ColName ; 
      				echo  -n "$ColName" >> $DBPATH/${DBList[$dbChoice]}/$tableName ;
      				PS3="  Enter Column Type : ";
      				select colType in Number String
      				do
      					case $colType in
      						"Number")
								echo -e ":Number" >> $DBPATH/${DBList[$dbChoice]}/$tableName;
      							break ;
      							;;
      						"String")
								echo -e ":String" >> $DBPATH/${DBList[$dbChoice]}/$tableName;
      							break ;
      							;;
      						*)
								echo "Please Choose One Of The Available Types !"
      					esac
      				done
			    done

			    while true; do
			    	i=1;
				    for col in "${colArr[@]}"; do
					    echo $i")"$col;
					    i=$((i+1)) ;
				    done
				    echo "Primarykey is necessary in any table So :"
			    	read -p "Choose A Primarykey Column : " Primarykey;
			    	if [ $Primarykey -le $tableCol -a $Primarykey -gt 0 ]
		        	then 
		            	echo $Primarykey >> $DBPATH/${DBList[$dbChoice]}/$tableName;
		            	break ;
			        else
			        	echo "You Have To Choose A Primarykey For Table $tableName ";
			         	continue ;
			       	fi 	
			    done
			    colArrIndex=1 
		        while [ $colArrIndex -le $tableCol ]
		        do
		        	if [ $colArrIndex -eq $tableCol ]  
			        	then echo -e "${colArr[colArrIndex]}" >> $DBPATH/${DBList[$dbChoice]}/$tableName; 
		         	else 
		         		echo -n "${colArr[colArrIndex]}:" >> $DBPATH/${DBList[$dbChoice]}/$tableName;
		         	fi 
		         	colArrIndex=$((colArrIndex+1));
		        done
		       	echo "-----------------------------------------" >> $DBPATH/${DBList[$dbChoice]}/$tableName;  
		        seperator;
		        clear;
				echo "Table was created successfully..";
			else	
				echo "There was an Error While Creating the Table" ;
			fi
	else	
		echo "Sorry But This Table Is Already Existed !";
	fi
	return $dbChoice;
}
#/**************************** List All Tables *********************************/
function listAllTables {
	i=1;
	DBPATH="DBs";
	if [[ `ls $DBPATH/${DBList[$dbChoice]}/` = "" ]];then
			echo "There Is No Table In This DB !";
			useDB $dbChoice;
			return 0;
	fi
	
	# Pushing all the tables into table list
	for TB in `ls $DBPATH/${DBList[$dbChoice]}/`
	do
		tableList[$i]=$TB;
		let i=i+1;
	done

	# Showing all the tables in this db
	echo "These are All The Available Tables : ";
	i=1;
	for TB in `ls $DBPATH/${DBList[$dbChoice]}/`
	do
		tableList[$i]=$TB;
		echo $i") "$TB;
		let i=i+1;
	done
}

#/**************************** Drop Table *********************************/
function dropTable {
	DBPATH="DBs"
	read -p "Choose Which Table To Drop : " choosenTable ;
	is_in ${tableList[$choosenTable]} "${tableList[@]}";
	if [[  "$?" == "1" ]]; then
		read -p "Are You Sure Droping ${tableList[$choosenTable]} Table (Y/N) " response;
		case $response in 
			[yY][eE][sS]|[yY]) 
	        	rm  $DBPATH/${DBList[$dbChoice]}/${tableList[$choosenTable]};
	        	echo "Table Removed Successfully.."
	    	;;

	    	*)
				seperator;
				useDB $dbChoice;
			;;
		esac	
	else
		{
			seperator;
			echo "Please Enter A Valid Choice !";
			listAllTables;
		}

	fi
	return $dbChoice;
}

#/****************** Table Operations****************************
function TableOperations {
	temp=$1;
	if [[  "$1" == "" ]]; then
	read -p "Choose Your Table : " tableChoice ;
	else 
		let tableChoice=temp;
	fi
	seperator;
	is_in ${tableList[$tableChoice]} "${tableList[@]}";
	if [[  $? == 1 ]]; then	
	  echo -e "You Are Using ${tableList[$tableChoice]} Table\n";
	  echo -e "\n+ ~~~Table Operations Menu  ~~~~+"
	  echo "| 1. Insert Row                 |"
	  echo "| 2. Update Row                 |"
	  echo "| 3. Display Table Details      |"
	  echo "| 4. Display Specific Record    |"
	  echo "| 5. Delete  Specific Record    |"
	  echo "| 6. Back To Main GUI           |"
	  echo "| 7. Exit                       |"
	  echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+"
	  echo -e "  Enter Your Choice: \c"
	  read choice
	  case $choice in
	    
	    1)  seperator;
			displayTB
			seperator;
			insertNewRow;
			TableOperations $?;
			getMainMenu;
			;;

	    2)  seperator;
			displayTB;
			updateSpecificRow;
			TableOperations $?;
			getMainMenu;
			;;

	    3)  seperator;
			displayTB;
			TableOperations $?;
			;;

	    4)	seperator;
			displayTB;
			displaySpecificRow;
			TableOperations $?;
			;;

	    5)  seperator;
			displayTB;
			deleteSpecificRow;
			TableOperations $?;
			;;

		6) getMainMenu;
			;;

	    7)  exit -1 ;
			;;
	    
	    *)  echo " This Is Not A Valid Choice " ; 
			getMainMenu;
	  esac
	fi
}

#/*********************************Display All Coumns **********************
function displayAllCols()
{
   declare -a colList
   choosenTable=$1;
   colArrIndex=1;
   noCols=`awk -F: '{if (NR == 2) print $2 }' $choosenTable`;
   ColName=$((noCols+4));
   pkVal=`cut -f1 -d: $choosenTable | head -$((noCols+3))  | tail -1 `
   pkCol=$((pkVal+2))
   pkColName=`cut -f1 -d: $choosenTable | head -$pkCol  | tail -1 `
   echo "These are All The Table Columns : "
   while [ $colArrIndex -le $noCols ]
    do
		tempColName=`cut -f$colArrIndex -d: $choosenTable | head -$ColName  | tail -1 `
		colList[$colArrIndex]=$tempColName  
		echo  " $((colArrIndex)). $tempColName" 
		colArrIndex=$((colArrIndex+1)) 
    done  
		echo "Primary Key : $pkColName "
   seperator;
}

#/****************************** primary key functions *******************
function getPKNum()
{
  TblName=$1;
  rowToDisplay=$2;
  noCols=`awk -F: '{if (NR == 3) print $2 }' $TblName`;
  ignoredLines=$(($noCols+7));
  ignoredLines=$((`cat $TblName | wc -l `-ignoredLines));
  pkVal=$((noCols+5));
  pkVal=`cut -f1 -d: $TblName | head -$pkVal  | tail -1 `;
  pkFndLine=`tail -$ignoredLines $TblName | grep -wn $rowToDisplay | cut -f1 -d: `;
  pkFndLine=$(($pkFndLine+$noCols+7));
  echo $pkFndLine;
}

function checkPrimaryKey()
{
	sendPkVal=$1 
    noCols=`awk -F: '{if (NR == 2) print $2 }' $TblName`
	ignoredLines=$(($noCols+5))
	ignoredLines=$((`cat $TblName | wc -l `-ignoredLines))
	pkVal=$((noCols+3)) 
	pkVal=`cut -f1 -d: $TblName | head -$pkVal  | tail -1 ` 
	tstFound=` tail -$ignoredLines $TblName | cut -f$pkVal -d: | grep -w $sendPkVal ` 
	  [ $tstFound ] && echo 1 || echo 0
}

# /*****************Check Column DataType*****************************
function checkColumnType()
{
   ColVal=$1;
   ColValType=${ColVal//[^0-9]/} 
   if [[ $ColVal == $ColValType ]]  
   	  then 
      echo 1;
   else
      echo 0;   
   fi    
}
function getColumnType()
{
  curNoCols=$1 
  noCols=$((`awk -F: '{if (NR == 2) print $2 }' $TblName`))
  curCellDataType=` cut -f2 -d: $TblName | head -$((noCols+2))  | tail -$noCols | head -$curNoCols | tail -1 `
  if [ $curCellDataType = "Number" ] 
		then 
		echo 1;
  else
		echo 0;
  fi  
}

# /************************** Insert A new Row TO specific Table *********************************
function insertNewRow {
	  DBPATH="DBs";
	  noCols=$((`awk -F: '{if (NR == 2) print $2 }' $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]}`));
      ignoredLines=$(($noCols+5))
	  ignoredLines=$((`cat $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]} | wc -l `-ignoredLines))
	  pkVal=$((noCols+5)) 
	  pkVal=`cut -f1 -d: $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]} | head -$pkVal  | tail -1 `
		curNoCols=1;
		echo "Insert Your Row : ";
		displayAllCols $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]}          
		while [ $curNoCols -le $noCols ]
		do
	  	while true 
	  	do 
			read -p "Enter Value For Record Num.$curNoCols : " cellValu
			curCellDataType=$(getColumnType $curNoCols )
			curColDataType=$(checkColumnType $cellValu )
			if [[ $cellValu ]] && [[ $curCellDataType -eq $curColDataType ]] && [[ $curCellDataType -eq 1 ]]
				then break 
			elif [[ $cellValu ]] && [[ $curCellDataType -eq $curColDataType ]] && [[ $curCellDataType -eq 0 ]]
					then break 
			else
				echo "Make Sure OF Your DataType of This Column";  
			fi  
			done
	  if [ $curNoCols -eq $pkVal ]
	  then 
	    {
				chkPkRtrn=$(checkPrimaryKey $cellValu)
				if [ $chkPkRtrn -eq 1 ]
					then
					{
						echo -e "\tSorry This row is already existed with this primary key";
	               		echo "\tplease choose different one !";
						break             
					}
				fi
			}  
		fi
		if [ $curNoCols -eq $noCols ]
			then echo -e "$cellValu" >> $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]}
		else
			echo -n "$cellValu:" >> $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]}  
		fi
	  	curNoCols=$((curNoCols+1))
		done
		echo -e "\t Your new row was inserted successfully..";
		return $tChoice;
}

#/********************* Update Specific Row ********************
function updateSpecificRow
{
	DBPATH="DBs";
	TblName=$DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]}
	echo "update will be done later";
	echo -e "\t You have updated your record successfully.. ";
	
}
#/*********************************** Display Row **********************************
function displaySpecificRow()
{
  	DBPATH="DBs";
  	TblName=$DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]}
	noCols=$((`awk -F: '{if (NR == 2) print $2 }' $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]}`));
	ignoredLines=$(($noCols+5))
  	ignoredLines=$((`cat $TblName | wc -l `-ignoredLines))
	pkVal=$((noCols+3)) 
	pkVal=`cut -f1 -d: $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]} | head -$pkVal  | tail -1 `
    rowCounter=$(($noCols+6))
  while true 
  do 
   read -p "Enter your row : " rowToDisplay
    if [ $rowToDisplay ]
     then break
    fi 
  done
  
  if [ $(checkPrimaryKey $rowToDisplay) == 1 ]
  then 
   {
     seperator; 
     echo "Matched Rows : ";
     pkFndLine=`tail -$ignoredLines $TblName | grep -wn $rowToDisplay | cut -f1 -d: `;
     pkFndLine=$(($pkFndLine+$noCols+5));
     sed -n "${pkFndLine}p" $TblName  ;
     seperator;
   }
  else
    echo "Sorry There Is No Match !";
  fi     
  return $tableChoice
  
}
#/**************************** Delete Specific Row *********************
function deleteSpecificRow()
{
  echo "will be implemented later !"
  return $tableChoice;
}
			
#/**************************** Display Table Data *********************
function displayTB()
{
 DBPATH="DBs";	
 echo "${tableList[$tableChoice]}";
 TblName=$DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]};
 seperator;
 noCols=$((`awk -F: '{if (NR == 2) print $2 }' $DBPATH/${DBList[$dbChoice]}/${tableList[$tableChoice]}`));
 ignoredLines=$(($noCols+4))
 echo "~~ ~> This Is A Description Of Your Choosen Table <~ ~~~";
 tail -n +$ignoredLines $TblName
 return $tableChoice
}

#/***************************** Use Database ********************************/
function useDB {

	oldChoise=$1;
	if [[  "$1" == "" ]]; then
		read -p "   Choose Database To Use : " dbChoice ;
		else 
			let dbChoice=oldChoise;	
	fi
	seperator;
	is_in ${DBList[$dbChoice]} "${DBList[@]}";
	if [[ $? == 1 ]]; then	
		echo "     You Are Using ${DBList[$dbChoice]} Database";
	else
		echo "     Please Enter A valid Choice !"
	fi

	echo -e "\n+~~~~~~~~ Tables Menu ~~~~~~~~~~+"
	echo "| 1. Create New Table           |"
	echo "| 2. Do Operations on Table     |"
	echo "| 3. Rename A Table             |"
	echo "| 4. Drop A Table               |"
	echo "| 5. Show All Tables            |"
	echo "| 6. Get Back To DB Menu        |"
	echo "| 7. Exit                       |"
	echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+"
	echo -e "  Enter Your Choice: \c"
	read choice

	case $choice in
	1)  createTable;
		useDB $?;
		;;

	2)  seperator;
		listAllTables;
		TableOperations;
		;;

	3)  #rename table 
		getMainMenu;
		;;

	4)  seperator;
		listAllTables;
		dropTable;
		useDB $?;
		;;

	5)  seperator;
		listAllTables
		useDB $dbChoice;
	 	;;

	6)  getMainMenu;
		;;

	7)  exit ;;

	*)  echo " This Is Not A Valid Choice " ; 
		listAllDBs ;
		useDB;
	esac
}
#/****************************************************************************
# Starting the script
seperator;
echo -e "\t\t\tWelcome To ITI DB Engine";
getMainMenu;

