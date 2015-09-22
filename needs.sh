#!/bin/bash
#
# Taskwarrior Needs Hierarchy
# a.k.a.Mazlow Mode
TASK=task
TASKRC=
INSTALL_DIR="$HOME/.task/hooks/tw-needs-hook"
NEEDS_TMP="$HOME/.task/rc.tmp"
#NEEDS_TMP=$INSTALL_DIR/needs.tmp
TMP_HEADER="# NEEDS TEMP FILE -- GENERATED BY needs.sh -- DO NOT EDIT"
#echo $TMP_HEADER > $NEEDS_TMP
NEED_RC="$INSTALL_DIR/needs.rc"
NEED_LEV=`task _get rc.needlevel`
  if [[ "$NEED_LEV" == "" ]]; then
	echo "needlevel config not set.. set it now?"
      # TODO if yes, 'task config needlevel 0'
        STATUS="nok"
  fi
NEED_DEFAULT="4"
STATUS="ok"
USAGE="needs [0-6]|[aA]|h[elp]"
REPORTS="ls,ready"
REPORT_1="ready"
REPORT_2="ls"

declare -a fields=( field_base field_needs field_tod )
declare -A field_base=( [value]="" [name]=base [pattern]="" [source]="" )
declare -A field_needs=( [value]="" [name]=needs [pattern]="\(\(\sneed[ .:a-zA_Z0-9\(\)][^_]+" [source]=rc.needlevel )
declare -A field_tod=( [value]="" [name]=tod [pattern]="" [source]="" )

declare -a reports=( report_ready report_ls )
declare -A report_ready=( [name]=ready [prefix]=report.ready.filter )
declare -A report_ls=( [name]=ls [prefix]=report.ls.filter )

(base need tod)



report

# SET PATTERNS
NEEDS_FILTER_PATTERN="\(\(\sneed[ .:a-zA_Z0-9\(\)][^_]+"
RPT_ANY_PATTERN="^report[.a-z]+filter="
SED_RM_RPT_PATTERN="s/^report[.a-z]+filter=//"
SED_RM_NEEDS_PATTERN="s/\(\(\sneed[ .:a-zA-Z0-9\(\)][^_]+//"
FILTER_A_PATTERN="^report\.${REPORT_1}\.filter="
FILTER_B_PATTERN="^report\.${REPORT_2}\.filter="
SEPARATOR_PATTERN="[_]+"
NEEDS_FILTER=`egrep -o "$NEEDS_FILTER_PATTERN" $NEEDS_TMP`
echo "$LINENO: NEEDS_FILTER = $NEEDS_FILTER"  #tmp
echo "$LINENO: SEPARATOR_PATTERN = $SEPARATOR_PATTERN"  #tmp
echo "$LINENO: RC_OTHER	= $RC_OTHER"  #tmp

# TODO test for $NEEDS_TMP file readable/ writable
# test for any report.*.filter in rc.tmp
# TODO figure out boolean

# if NEEDS_TMP exists; then

if [ -f $NEEDS_TMP ]; then
# if NEEDS_TMP has any RC_OTHER
	RC_OTHER=`egrep -v "^$|^#+|^uda.need.default=|^report." $NEEDS_TMP`
	echo "$LINENO: RC_OTHER	= $RC_OTHER"  #tmp
	cp $NEEDS_TMP $INSTALL_DIR/tmp.tmp
	echo "$TMP_HEADER" > $NEEDS_TMP
	BASE_A=`task _get rc.report.${REPORT_1}.filter`
        BASE_B=`task _get rc.report.${REPORT_2}.filter`
	mv $INSTALL_DIR/tmp.tmp $NEEDS_TMP


# if NEEDS_TMP has report.*.filter
	ANY_REPORT_FILTER=`egrep -o "$RPT_ANY_PATTERN" $NEEDS_TMP`
	echo "$LINENO: ANY_REPORT_FILTER = $ANY_REPORT_FILTER"  #tmp
	if [[ "$ANY_REPORT_FILTER" != "" ]]; then  # no filters set in rc.tmp
		#FILTER_A=`task _get rc.report.${REPORT_1}.filter |sed -r 's/^report[.a-z]+filter=//' |sed -r 's/\(\(\sneed[ .:a-zA-Z0-9\(\)]+//' |sed -r 's/[ _]+//'`
		#FILTER_B=`task _get rc.report.${REPORT_2}.filter |sed -r 's/^report[.a-z]+filter=//' |sed -r 's/\(\(\sneed[ .:a-zA-Z0-9\(\)]+//' |sed -r 's/[ _]+//'`
		#echo "$LINENO FILTER_A = $FIELD_3A"  #tmp
		#echo "$LINENO FILTER_B = $FIELD_3B"  #tmp


	# if filter has VANY_SEPARATOR
		ANY_SEPARATOR=`egrep "$RPT_ANY_PATTERN" $NEEDS_TMP |egrep -c "$SEPARATOR_PATTERN"`
		echo "$LINENO any separator = $ANY_SEPARATOR"  #tmp
		if [[ "$ANY_SEPARATOR" != "" ]]; then  # it HAS separators, so from multiple tw-ext sources

FIELD_3A=`egrep "^report\.$REPORT_1\.filter=" $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN | cut -d'_' -f3`
FIELD_3B=`egrep "^report\.$REPORT_2\.filter=" $NEEDS_TMP |sed -r sSED_RM_RPT_PATTERN | cut -d'_' -f3`
		
echo "$LINENO filter 3a = $FIELD_3A"
echo "$LINENO filter 3b = $FIELD_3B"
		fi

#================================================			
#			TEST_FIELD_1=`egrep "$FIELD_3A_PATTERN" $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN |cut -d'_' -f1`
#			TEST_FIELD_1A=`egrep -o "$NEEDS_FILTER_PATTERN" $NEEDS_TMP`
#			TEST_FIELD_2=`egrep "$FIELD_3A_PATTERN" $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN |cut -d'_' -f2`
#			TEST_FIELD_2A=`egrep -o "$NEEDS_FILTER_PATTERN" $NEEDS_TMP`
#			echo "$LINENO: No needs-filter-patterns detected"
#		# if NEEDS_FILTER_PATTERN is in field1 (FILTER_OTHER = -f2-)
#			if [[ $TEST_FIELD_1 == $TEST_FIELD_1A ]]; then  # pattern -f1 is a needs-filter
#				FILTER_A="`egrep $FIELD_3A_PATTERN $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN |cut -d'_' -f2-` _ "
#				FILTER_B="`egrep $FIELD_3B_PATTERN $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN |cut -d'_' -f2-` _ "
#				echo "$LINENO: need in field 1 FILTER_A = $FIELD_3A"  #tmp
#				echo "$LINENO: need in field 2 FILTER_B = $FIELD_3B"  #tmp
#		# if NEEDS_FILTER_PATTERN is in field2 (FILTER_OTHER = --complement -s -f2))
#			elif [[ $TEST_FIELD_2 == $TEST_FIELD_2A ]]; then  # pattern -f2 is a needs-filter
#				FILTER_A="`egrep $FIELD_3A_PATTERN $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN |cut -d'_' --complement -s -f2` _ "
#				FILTER_B="`egrep $FIELD_3B_PATTERN $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN |cut -d'_' --complement -s -f2` _ "
#				echo "$LINENO: need in field 2 FILTER_A = $FIELD_3A"  #tmp
#				echo "$LINENO: need in field 2 FILTER_B = $FIELD_3B"  #tmp
#			fi
#		else
#				FILTER_A="`egrep $FIELD_3A_PATTERN $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN` _ "
#				FILTER_B="`egrep $FIELD_3B_PATTERN $NEEDS_TMP |sed -r $SED_RM_RPT_PATTERN` _ "
#				echo "$LINENO: FILTER_A = $FIELD_3A"  #tmp
#				echo "$LINENO: FILTER_B = $FIELD_3B"  #tmp
#		fi
#================================================================
	else
		# incorporate the original report defaults
		#FILTER_A=`task _get rc.report.${REPORT_1}.filter`
		#FILTER_B=`task _get rc.report.${REPORT_2}.filter`

#		FILTER_A=""
#		FILTER_B=""
		echo "$LINENO FILTER_A = $FIELD_3A"  #tmp
		echo "$LINENO FILTER_B = $FIELD_3B"  #tmp
	fi
else
	echo "No temp file found! this isn't going to work!"
	exit 0
fi





# test for separators



# Functions
function pause(){
  read -p "$*"
  }


# COUNT TASKS
# TODO FUNCTION: count_tasks
CONFIG="rc.verbose= rc.confirmation= rc.context= +PENDING"
NUM_TOTAL=`task $CONFIG count`
NUM_0=`task $CONFIG need.none: count`
NUM_1=`task $CONFIG need:1 count`
NUM_2=`task $CONFIG need:2 count`
NUM_3=`task $CONFIG need:3 count`
NUM_4=`task $CONFIG need:4 count`
NUM_5=`task $CONFIG need:5 count`
NUM_6=`task $CONFIG need:6 count`

# NEED FILTERS
ALLOW_DATES=" or need.none: or due:today or scheduled:today or until:tomorrow"
N1="(( need.under:0 and need.over:2 )$ALLOW_DATES )"
N2="(( need.under:0 and need.over:3 )$ALLOW_DATES )"
N3="(( need.under:0 and need.over:4 )$ALLOW_DATES )"
N4="(( need.under:0 and need.over:5 )$ALLOW_DATES )"
N5="(( need.under:2 and need.over:6 )$ALLOW_DATES )"
N6="(( need:4 or need:5 or need:6 )$ALLOW_DATES )"

# NEEDS-AUTO-LEVEL SELECTION
# TODO FUNCTION: needs_auto_level
   if [[ "$NUM_6" != "0" ]]; then
     AUTO_LEV="6"
     AUTO_N=$N6
   fi
   if [[ "$NUM_5" != "0" ]]; then
     AUTO_LEV="5"
     AUTO_N=$N5
   fi
   if [[ "$NUM_4" != "0" ]]; then
     AUTO_LEV="4"
     AUTO_N=$N4
   fi
   if [[ "$NUM_3" != "0" ]]; then
     AUTO_LEV="3"
     AUTO_N=$N3
   fi
   if [[ "$NUM_2" != "0" ]]; then
     AUTO_LEV="2"
     AUTO_N=$N2
   fi
   if [[ "$NUM_1" != "0" ]]; then
     AUTO_LEV="1"
     AUTO_N=$N1
   fi

   echo "$LINENO: AUTO_N = $AUTO_N"
   echo "$LINENO: AUTO_LEV = $AUTO_LEV"









if [[ "$1" == "" ]]; then

# COLORS
# TODO FUNCTION: set_colors
# TODO COLORS="gray,bold red,yellow,green,bold blue,cyan,magenta"
GRAY="[38;5;242m"
C1="[1;31m"		# bold red
CB1=$C1
  if [[ "$NUM_1" -lt "1" ]]
    then
      CB1=$GRAY
  fi
C2="[33m"		# yellow
CB2=$C2
  if [[ "$NEED_LEV" =~ [156]+ ]] || [[ "$NUM_2" -lt "1" ]]
    then
      CB2=$GRAY
  fi
C3="[32m"		# green
CB3=$C3
  if [[ "$NEED_LEV" =~ [126]+ ]] || [[ "$NUM_3" = "1" ]]
    then
      CB3=$GRAY
  fi
C4="[1;34m"		# bold blue
CB4=$C4
  if [[ "${NEED_LEV}" =~ [1-3]+ ]] || [[ "$NUM_4" -lt "1" ]]
    then
      CB4=$GRAY
  fi
C5="[36m"		# cyan
CB5=$C5
  if [[ "$NEED_LEV" =~ [1-4]+ ]] || [[ "$NUM_5" -lt "1" ]]
    then
      CB5=$GRAY
  fi
C6="[35m"		# magenta
CB6=$C6
  if [[ "$NEED_LEV" =~ [1-5]+ ]] || [[ "$NUM_6" -lt "1" ]]
    then
      CB6=$GRAY
  fi
Cx="[0m"		# end color

# BAR GRAPH (50 bars across)
# TODO FUNCTION: bar_graph
# if count=1, assign 1 bar, to be non-zero on graph
B_FACTOR=`echo "50 $NUM_TOTAL" |awk '{printf "%.8f \n", $1/$2}'`
B_MIN="1"
B0=`echo "$NUM_0 $B_FACTOR" |awk '{printf "%.f \n", $1*$2}'`
  if [[ "$NUM_0" == "$B_MIN" ]] 
     then B0="1"
  fi
B1=`echo "$NUM_1 $B_FACTOR" |awk '{printf "%.f \n", $1*$2}'`
  if [[ "$NUM_1" == "$B_MIN" ]] 
     then B1="1"
  fi
B2=`echo "$NUM_2 $B_FACTOR" |awk '{printf "%.f \n", $1*$2}'`
  if [[ "$NUM_2" == "$B_MIN" ]] 
     then B2="1"
  fi
B3=`echo "$NUM_3 $B_FACTOR" |awk '{printf "%.f \n", $1*$2}'`
  if [[ "$NUM_3" == "$B_MIN" ]] 
     then B3="1"
  fi
B4=`echo "$NUM_4 $B_FACTOR" |awk '{printf "%.f \n", $1*$2}'`
  if [[ "$NUM_4" == "$B_MIN" ]] 
     then B4="1"
  fi
B5=`echo "$NUM_5 $B_FACTOR" |awk '{printf "%.f \n", $1*$2}'`
  if [[ "$NUM_5" == "$B_MIN" ]] 
     then B5="1"
  fi
B6=`echo "$NUM_6 $B_FACTOR" |awk '{printf "%.f \n", $1*$2}'`
  if [[ "$NUM_6" == "$B_MIN" ]]
     then B6="1"

# FIND THE LARGEST GROUP TO USE FOR LEVELLING
# TODO FUNCTION: level_graph
  fi
BIG_B='0'
  if [[ "$B0" -gt "$BIG_B" ]] 
    then
    BIG_B=$B0
    BIG_L=0
  fi
  if [[ "$B1" -gt "$BIG_B" ]] 
    then
    BIG_B=$B1
    BIG_L=1
  fi
  if [[ "$B2" -gt "$BIG_B" ]]
    then
    BIG_B=$B2
    BIG_L=2
  fi
  if [[ "$B3" -gt "$BIG_B" ]]
    then
    BIG_B=$B3
    BIG_L=3
  fi
  if [[ "$B4" -gt "$BIG_B" ]] 
    then
    BIG_B=$B4
    BIG_L=4
  fi
  if [[ "$B5" -gt "$BIG_B" ]]
    then
    BIG_B=$B5
    BIG_L=5
  fi
  if [[ "$B6" -gt "$BIG_B" ]]
    then
    BIG_B=$B6
    BIG_L=6
  fi
B_TOT=$((B0 + B1 + B2 + B3 + B4 + B5 + B6 ))

if [[ "$B_TOT" -gt "50" ]]
  then
echo "B4 = $B4" #TMP
  B_TRIM=$((B_TOT - 50 ))
  B_LEV=B${BIG_L}
# TODO fix this leveller
TRIM=$(echo "B${BIG_L}")
B4=$((BIG_B - B_TRIM)) #TMP
#set \$$TRIM=$((BIG_B - B_TRIM))
#$(echo $B_LEV)=$((BIG_B - B_TRIM))
echo "TRIM=$TRIM" #TMP
echo "B4 = $B4" #TMP

 # $(`echo "$B_LEV"`)=$((BIG_B - B_TRIM))
# DIAGNOSTIC
#echo "$NUM_TOTAL"
#echo "$B_FACTOR"
#echo "1 $B1"
#echo "2 $B2"
#echo "3 $B3"
#echo "4 $B4"
#echo "5 $B5"
#echo "6 $B6"
#echo "BIG_B $BIG_B"
#echo "BIG_L $BIG_L"
#echo "B_TOT $B_TOT"
#echo "B_LEV $B_LEV"
#echo "B_TRIM $B_TRIM"
fi

# CONVERT PERCENTAGE TO NUMBER OF "_"s
# TODO fix "printf: 0 : invalid number"
G0=`printf '%*s' "$B0" | tr ' ' "x"`
G1=`printf '%*s' "$B1" | tr ' ' "_"`
G2=`printf '%*s' "$B2" | tr ' ' "_"`
G3=`printf '%*s' "$B3" | tr ' ' "_"`
G4=`printf '%*s' "$B4" | tr ' ' "_"`
G5=`printf '%*s' "$B5" | tr ' ' "_"`
G6=`printf '%*s' "$B6" | tr ' ' "_"`
echo "$G0 $G1 $G2 $G3 $G4 $G5 $G6"
echo "$B0 $B1 $B2 $B3 $B4 $B5 $B6"
# LEVEL INDICATOR (first column)
# AND, AT THE SAME TIME, CALCULATED TASKS SUB-TOTAL
# TODO FUNCTION: draw_report_indicator
# TODO FUNCTION: calc_report_subtotals
SPC="    "
ACT=" -->"
AUTO="A-->"
SUB_TOT="0"
I6=$SPC
  if [[ "$NEED_LEV" == "6" ]]
    then
      I6="$ACT"
      SUB_TOT=$((NUM_6 + NUM_5 + NUM_4))
  fi
I5=$SPC
  if [[ "$NEED_LEV" == "5" ]]
    then
      I5="$ACT"
      SUB_TOT=$((NUM_5 + NUM_4 + NUM_3))
  fi
I4=$SPC
  if [[ "$NEED_LEV" == "4" ]]
    then
      I4="$ACT"
      SUB_TOT=$((NUM_4 + NUM_3 + NUM_2 + NUM_1))
  fi
I3=$SPC
  if [[ "$NEED_LEV" == "3" ]]
    then
      I3="$ACT"
      SUB_TOT=$((NUM_3 + NUM_2 + NUM_1))
  fi
I2=$SPC
  if [[ "$NEED_LEV" == "2" ]]
    then
      I2="$ACT"
      SUB_TOT=$((NUM_2 + NUM_1))
  fi
I1=$SPC
  if [[ "$NEED_LEV" == "1" ]]
    then
      I1="$ACT"
      SUB_TOT=$NUM_1
  fi
I0="-"
  if [[ "$NEED_LEV" =~ "0" ]]
    then
      SUB_TOT=$NUM_TOTAL
  fi


echo -e "            $G0$C1$G1$Cx$CB2$G2$Cx$CB3$G3$Cx$CB4$G4$Cx$CB5$G5$Cx$CB6$G6$Cx
$I6${C6}6${Cx}${CB6}      /                  Higher goals                    \      ${Cx}(${CB6}$NUM_6${Cx})
$I5${C5}5${Cx}${CB5}     /                Self actualization                  \     ${Cx}(${CB5}$NUM_5${Cx})
$I4${C4}4${Cx}${CB4}    /            Esteem, respect & recognition             \    ${Cx}(${CB4}$NUM_4${Cx})
$I3${C3}3${Cx}${CB3}   /           Love & belonging, friends & family           \   ${Cx}(${CB3}$NUM_3${Cx})
$I2${C2}2${Cx}${CB2}  /       Personal safety, security, health, financial       \  ${Cx}(${CB2}$NUM_2${Cx})
$I1${C1}1${Cx}${CB1} /     Physiological; air, water, food, shelter & medical     \ ${Cx}(${CB1}$NUM_1${Cx})"
# IF ANY TASKS ARE MISSING A NEED VALUE
  if [[ $NUM_0 != '0' ]]
    then
      echo "     |--------------------------------------------------------------|"
      echo "    x|  Warning: $NUM_0/$NUM_TOTAL pending tasks missing need-level! see: help  |"
  fi

  if [[ $NUM_TOTAL/$NUM_0 < '10' ]]
    then
      echo "     |  For tw-needs-hook to work, most (if not all) have need:1-6  |"
  fi



echo "     \--------------------------------------------------------------/
      \_ needlevel:$NEED_LEV $GRAY-- enter 0-6,a,help or any other key to quit${Cx} _/ ($SUB_TOT)"


# NEED FILTERED REPORTS
	# reset auto level from [aA] to ${NEED_LEV}A, if needed
# PROMPT
	echo
	read -p "   Need>" prompt
	if [[ $prompt == $NEED_LEV ]]; then
		echo "Need level is already $NEED_LEV, no changes made"
		pause 'Press <CR> to continue...'
		$TASK needs
		exit 0

	elif [[ "$prompt" =~ [a|A] ]]; then
		if [[ "$NEED_LEV" != $AUTO_LEV ]]; then
			$TASK rc.verbose= rc.confirmation= config needlevel $AUTO_LEV
			NEED_LEV=`task _get rc.needlevel`
			echo -e "$TMP_HEADER" > $NEEDS_TMP
			echo -e "report.ready.filter=$BASE_A _ $AUTO_N _ $FIELD_3A _" >> $NEEDS_TMP
			echo -e "report.ls.filter=$BASE_B _ $AUTO_N _ $FIELD_3B _" >> $NEEDS_TMP
			echo -e "uda.need.default=$NEED_DEFAULT" >> $NEEDS_TMP
			echo "Need level set to $AUTO_LEV automatically" 
			pause 'Press <CR> to continue...'
			$TASK needs
			exit 0
		else	
			echo "Need auto-level is already $NEED_LEV, no changes made"
			pause 'Press <CR> to continue...'
			$TASK needs
			exit 0
		fi

	elif [[ "$prompt" == "0" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $prompt
		NEED_LEV=`task _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.${REPORT_1}.filter=$BASE_A _ _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.${REPORT_2}.filter=$BASE_B _ _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_DEFAULT" >> $NEEDS_TMP
		echo "Need level cleared to $NEED_LEV"
		pause 'Press <CR> to continue...'
		$TASK needs
		exit 0

	elif [[ "$prompt" = "1" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $prompt
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.${REPORT_1}.filter=$BASE_A _ $N1 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.${REPORT_2}.filter=$BASE_B _ $N1 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		pause 'Press <CR> to continue...'
		$TASK needs
		exit 0

	elif [[ "$prompt" = "2" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $prompt
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.${REPORT_1}.filter=$BASE_A _ $N2 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.${REPORT_2}.filter=$BASE_B _ $N2 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		pause 'Press <CR> to continue...'
		$TASK needs
		exit 0
		
	elif [[ "$prompt" = "3" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $prompt
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.${REPORT_1}.filter=$BASE_A _ $N3 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.${REPORT_2}.filter=$BASE_B _ $N3 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		pause 'Press <CR> to continue...'
		$TASK needs
		exit 0
		
	elif [[ "$prompt" = "4" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $prompt
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.${REPORT_1}.filter=$BASE_A _ $N4 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.${REPORT_2}.filter=$BASE_B _ $N4 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		pause 'Press <CR> to continue...'
		$TASK needs
		exit 0
		
	elif [[ "$prompt" = "5" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $prompt
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.${REPORT_1}.filter=$BASE_A _ $N5 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.${REPORT_2}.filter=$BASE_B _ $N5 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		pause 'Press <CR> to continue...'
		$TASK needs
		exit 0
		
	elif [[ "$prompt" = "6" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $prompt
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.${REPORT_1}.filter=$BASE_A _ $N6 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.${REPORT_2}.filter=$BASE_B _ $N6 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		pause 'Press <CR> to continue...'
		$TASK needs
		exit 0
		
	fi
# ERROR CHECKING

# WITH ARGS (CLI, non-interacrive)
elif [[ "$1" != "" ]]; then
	if [[ "$2" != "" ]]; then
		echo "That's too many arguments"
		echo "$USAGE"
		echo
		exit 1

	elif [[ "$1" == $NEED_LEV ]]; then
		echo "Need leve is already $NEED_LEV, no changes made"
		exit 1

	elif [[ "$1" =~ "h[elp]" ]]; then
		echo "No help for you (cat needs.txt)"
		exit 0
	
	elif [[ "$1" =~ a ]]; then
		if [[ "$1" != $AUTO_LEV ]]; then
			$TASK rc.verbose= rc.confirmation= config needlevel $AUTO_LEV
			NEED_LEV=`$TASK _get rc.needlevel`
			echo -e "$TMP_HEADER" > $NEEDS_TMP
			echo -e "$RC_OTHER" >> $NEEDS_TMP
			echo -e "report.ready.filter=$BASE_A _ $AUTO_N _ $FIELD_3A _" >> $NEEDS_TMP
			echo -e "report.ls.filter=$BASE_B _ $AUTO_N _ $FIELD_3B _" >> $NEEDS_TMP
			echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
			echo "Need-level has been automatically set to $NEED_LEV"
			exit 0
		else
			echo "Need level is already set to $NEED_LEV, no changes made"
			exit 0
		fi

	elif [[ "$1" == "1" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $1
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.ready.filter=$BASE_A _ $N1 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.ls.filter=$BASE_B _ $N1 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		exit 0

	elif [[ "$1" == "2" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $1
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.ready.filter=$BASE_A _ $N2 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.ls.filter=$BASE_B _ $N2 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		exit 0

	elif [[ "$1" == "3" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $1
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.ready.filter=$BASE_A _ $N3 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.ls.filter=$BASE_B _ $N3 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		exit 0

	elif [[ "$1" == "4" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $1
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.ready.filter=$BASE_A _ $N4 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.ls.filter=$BASE_B _ $N4 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		exit 0

	elif [[ "$1" == "5" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $1
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.ready.filter=$BASE_A _ $N5 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.ls.filter=$BASE_B _ $N5 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		exit 0

	elif [[ "$1" == "6" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $1
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.ready.filter=$BASE_A _ $N6 _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.ls.filter=$BASE_B _ $N6 _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_LEV" >> $NEEDS_TMP
		echo "Need level changed to $NEED_LEV"
		exit 0
	elif [[ "$1" == "0" ]]; then
		$TASK rc.verbose= rc.confirmation= config needlevel $1
		NEED_LEV=`$TASK _get rc.needlevel`
		echo -e "$TMP_HEADER" > $NEEDS_TMP
		echo -e "$RC_OTHER" >> $NEEDS_TMP
		echo -e "report.ready.filter=$BASE_A _  _ $FIELD_3A _" >> $NEEDS_TMP
		echo -e "report.ls.filter=$BASE_B _  _ $FIELD_3B _" >> $NEEDS_TMP
		echo -e "uda.need.default=$NEED_DEFAULT" >> $NEEDS_TMP
		echo "Need level reset to $NEED_LEV"
		exit 0
	fi

		echo "Invalid Argument(s)"
		echo $USAGE
		echo
		exit 1
fi	
	
