#!/bin/sh
menu_choice=""
record_file="bookRecords.ldb"
LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
LIGHT_CYAN='\033[1;36m'
LIGHT_PURPLE='\033[1;35m'
ORANGE='\033[0;33m'
#RED='\033[0;31m'
YELLOW='\033[1;33m'
temp_file=/tmp/ldb.$$
trap 'rm -f $temp_file' EXIT

options(){
clear
printf "${LIGHT_BLUE}Mini Library Management"
printf '\n'
printf "${LIGHT_GREEN}\ta) Add new Book records\n"
printf "\tb) Find Books\n"
printf "\tc) Edit Books\n"
printf "\td) Remove Books\n"
printf "\te) View Books\n"
printf "\tf) Quit\n"
printf 'Please enter the choice then press return\n'
read menu_choice

rm -f $temp_file
if [!-f $record_file];then
touch $record_file
fi

clear
printf '\n\n\n'
printf "${LIGHT_PURPLE}Mini library Management\n\n\n"
sleep 1

quit="n"
while [ "$quit" != "y" ];
do
case $menu_choice in
a)add_books;;
b)find_books;;
c)edit_books;;
d)remove_file;;
e)view_books;;
f)if get_confirm
then 
quit=y
else
get_return
fi
;;
*) printf "${YELLOW}Sorry, choice not recognized\n\n"
sleep 2
clear
options;;
esac
done
# Tidy up and leave
 
rm -f $temp_file
echo "Finished"
exit 0
return
}

add_books(){
 
#prompt for information
printf "${YELLOW}Please enter!\n"
printf "a) To add book\n"
printf "b) To go back to main menu\n"
read opt
case $opt in
a)
printf "${LIGHT_BLUE}Enter Books category:-"
read tmp
liCatNum=${tmp%%,*}
 
printf 'Enter Books title:-'
read tmp
liTitleNum=${tmp%%,*}
 
printf 'Enter Author Name:-'
read tmp
liAutherNum=${tmp%%,*}

#calculate accession number
accession_number


#Check that they want to enter the information
printf "${LIGHT_BLUE}\nAbout to add new entry\n"
printf "$liAccNum\t$liCatNum\t$liTitleNum\t$liAutherNum\n"
 
#If confirmed then append it to the record file
if get_confirm;then
   insert_record $liAccNum,$liCatNum,$liTitleNum,$liAutherNum
   echo "${YELLOW}Record added successfully\n"
   echo "Add another entry?"
   if get_confirm;then
    add_books
    else
   get_return
    fi
fi
;;
b)options;;
*)echo "Invalid choice\n\n"
add_books;;
esac
return
}

insert_record(){
echo $* >>$record_file
return
}

find_books(){
printf "${YELLOW}Please enter!\n"
printf "a) To find book\n"
printf "b) To go back to main menu\n"
read opt
case $opt in
a)
printf "${YELLOW}Enter a book title\n"
read srchbook

 if [ "$srchbook" = "" ]
 then
	printf "${YELLOW}Nothing entered"
	find_books
  else    
    grep $srchbook $record_file > $temp_file
	set $(wc -l $temp_file)
  linesfound=$1
 
  case "$linesfound" in
  0)    echo "${YELLOW}Sorry, nothing found"
        get_return
        return 0
        ;;
  *)    echo "${LIGHT_GREEN}Found the following"
	printf "${ORANGE}"
        cat $temp_file | column -t -s ','
	echo "\nFind another book?"
	if get_confirm;then
	find_books
	else
        get_return
	fi
        return 0
  esac
 fi
;;
b)options;;
*)echo "Invalid Choice\n\n"
find_books;;
esac
return
}

edit_books(){
printf "${YELLOW}Please enter!\n"
printf "a) To edit book\n"
printf "b) To return to main menu\n"
read opt
case $opt in
a)
printf "${LIGHT_BLUE}List of books are\n"
printf "${YELLOW}"
cat $record_file | column -t -s ','
printf "${LIGHT_GREEN}\nType in the title of the book you want to edit\n"
read searchstr
  if [ "$searchstr" = "" ]
  then
	printf "${YELLOW}Please enter a book title!\n"
        return 0
  else 
  grep "$searchstr" $record_file > $temp_file
  echo "Found the following"
  printf "${ORANGE}"
  cat $temp_file | column -t -s ','
  echo -e "\n"
  fi
edit
exit 0;;
b)options;;
*)echo "Invalid Choice\n\n"
esac
return
}

edit(){
printf "${LIGHT_BLUE}What do you want to edit:\n 1.Category\n 2.Title\n 3.Author\n Enter your choice\n"
read choice
case $choice in
1)echo "Enter new category\n"
read newcate
echo "${LIGHT_CYAN}Original Record:"
cat $temp_file | column -t -s ','
oldtitle=$( echo "$line2" |cut -d, -f3 $temp_file)
oldauthor=$( echo "$line3" |cut -d, -f4 $temp_file)
oldcat=$( echo "$line1" |cut -d, -f2 $temp_file)
oldaccno=$( echo "$line1" |cut -d, -f1 $temp_file)
grep -v "${searchstr}" $record_file > $temp_file
mv $temp_file $record_file
insert_record $oldaccno,$newcate,$oldtitle,$oldauthor
echo "\nNew Record:"
printf "$oldaccno\t$newcate\t$oldtitle\t$oldauthor\n\n"
printf "${YELLOW}Record modified successfully!"
sleep 2
options
;;
2)echo "Enter new Title\n"
read newtitle
echo "${LIGHT_CYAN}Original Record:"
cat $temp_file | column -t -s ','
oldtitle=$( echo "$line22" |cut -d, -f3 $temp_file)
oldauthor=$( echo "$line33" |cut -d, -f4 $temp_file)
oldcat=$( echo "$line11" |cut -d, -f2 $temp_file)
oldaccno=$( echo "$line1" |cut -d, -f1 $temp_file)
grep -v "${searchstr}" $record_file > $temp_file
mv $temp_file $record_file
insert_record $oldaccno,$oldcat,$newtitle,$oldauthor
echo "\nNew Record:"
printf "$oldaccno\t$oldcat\t$newtitle\t$oldauthor\n\n"
printf "${YELLOW}Record modified successfully!"
sleep 2
options
;;
3)echo "enter new Author\n"
read newauthor
echo "${LIGHT_CYAN}Original Record:"
cat $temp_file | column -t -s ','
oldtitle=$( echo "$line22" |cut -d, -f3 $temp_file)
oldauthor=$( echo "$line33" |cut -d, -f4 $temp_file)
oldcat=$( echo "$line11" |cut -d, -f2 $temp_file)
oldaccno=$( echo "$line1" |cut -d, -f1 $temp_file)
grep -v "${searchstr}" $record_file > $temp_file
mv $temp_file $record_file
insert_record $oldaccno,$oldcat,$oldtitle,$newauthor
echo "\nNew Record:"
printf "$oldaccno\t$oldcat\t$oldtitle\t$newauthor\n\n"
printf "${YELLOW}Record modified successfully!"
sleep 2
options
;;
*)echo "Invalid Choice\n"
edit;;
esac
return
}

remove_file(){
printf "${YELLOW}Please enter!!\n"
printf "a) To delete\n"
printf "b) To go back to main menu\n"
read opt
case $opt in
a)
printf "${LIGHT_BLUE}Type the books title which you want to delete\n"
 read searchstr
if [ "$searchstr" = "" ] 
then
	printf "${YELLOW}Sorry! nothing entered...."
	get_return
	return 0
else
grep "$searchstr" $record_file > $temp_file

set $(wc -l $temp_file)
   linesfound=$1
 
   case "$linesfound" in
   0)    echo "${YELLOW}Sorry, nothing found\n"
        get_return
        return 0
        ;;
*) echo "${LIGHT_GREEN}Found the following\n"
printf "${ORANGE}"
         cat $temp_file | column -t -s ',' ;;
        esac
	if get_confirm 
	then
(echo "g/${searchstr}/d"; echo 'wq') | ex -s $record_file
      printf "Book has been removed\n"
		echo "Remove another book?"
		if get_confirm;then
		remove_file
		else
		get_return
		fi
      else
	get_return
	fi
   fi
;;
b)options;;
*)echo "Ivalid choice\n"
remove_file;;
esac
return
 
}

view_books(){
printf "${YELLOW}Please enter!!\n"
printf "a) To view books\n"
printf "b) To go back to main menu\n"
read opt
case $opt in
a)
printf "${LIGHT_GREEN}CATALOGUE\n\n"
printf "${LIGHT_BLUE}"
 
cat $record_file | column -t -s ','
get_return
;;
b)options;;
*)echo "Invalid choice\n\n"
view_books;;
esac
return
}
accession_number()
{
oldAccnum=$(echo "$linetail" | tail -n1 $record_file | cut -d, -f1)
liAccNum=`expr $oldAccnum + 1`
}

get_return(){
printf "${YELLOW}\tPress enter to return\n"
read x
options
return
}

get_confirm(){
printf "${YELLOW}\tAre you sure?\n"
while true
do
  read x
  case "$x" in
      y|yes|Y|Yes|YES)
          return 0;;
      n|no|N|No|NO)
          printf '\Cancelled\n'
          return 1;;
      *) printf 'Please enter yes or no';;
  esac
done
}
options
