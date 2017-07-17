#!/usr/bin/env bash

printf "\E[44;37m"

topline=0
count=$topline
tput civis

robot="`cat << "EOF"                               

|@|@|@|@|           |@|@|@|@|
|@|@|@|@|   _____   |@|@|@|@|
|@|@|@|@| /\_T_T_/\ |@|@|@|@|
|@|@|@|@||/\ T T /\||@|@|@|@|
 ~/T~~T~||~\/~T~\/~||~T~~T\~
  \|__|_| \(-(O)-)/ |_|__|/
  _| _|    \\8_8//    |_ |_
|(@)]   /~~[_____]~~\   [(@)|
  ~    (  |       |  )    ~
      [~\` ]       [ '~]
      |~~|         |~~|
      |  |         |  |
     _<\/>_       _<\/>_
    /_====_\     /_====_\\




EOF`"



  

rows=`tput lines`
cols=`tput cols`


clear

# cat logo.txt
sleep 0.1
clear
#number of loops
for i in $(seq $topline $rows); do
    tput clear
    wait

    #number of empty lines during each loop
    tput cup $count $((count))
    wait

    while IFS= read -r line ; do
      if (( $((count*2)) > $rows )); then
               tput cuf $(($rows*2 - count*2)); echo "$line"
               wait
    
  else
          tput cuf $((count*2)); echo "$line"
          wait

  fi

# fi
    done <<< "$robot"
    
let count++
  

echo -n "
                     dMMMMMP .aMMMb  dMP dMP .aMMMb  dMMMMb         dMMMMMMMMb  dMMMMMP dMMMMb  dMP dMP dMMMMMP
                        dMP dMP\"dMP dMP.dMP dMP\"dMP dMP\"dMP        dMP\"dMP\"dMP dMP     dMP dMP dMP.dMP dMP
                       dMP dMMMMMP dMMMMK\" dMP dMP dMMMMK\"        dMP dMP dMP dMMMP   dMP dMP dMMMMK\" dMMMP
                  dK .dMP dMP dMP dMP\"AMF dMP.aMP dMP.aMF        dMP dMP dMP dMP     dMP dMP dMP\"AMF dMP
                  VMMMP\" dMP dMP dMP dMP  VMMMP\" dMMMMP\"        dMP dMP dMP dMMMMMP dMP dMP dMP dMP dMMMMMP\""
wait
sleep 0.02
done

clear
printf "\E[0m"
clear
ls -Alhf
tput cnorm
