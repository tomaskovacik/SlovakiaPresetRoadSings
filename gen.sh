#!/bin/bash
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<roadsignpreset country=\"SK\">";
 
#subor zo zoznamom znaciek
subor_znaciek=znacky3.csv;
subor_tagy=tags.csv
subor_dodatkovych_tabuliek=supplementary.csv
 
# nacitame riadok zo suboru_znaciek
# ak existuje zaznam v sobore tagov a
# subore dodatkovych tabuliek nacitame aj tie
 
#subor znaciek loop
while IFS=, read icona id nazov popis dodatkova
do
	popis=`echo ${popis}|sed 's/::coma::/,/g'`
	echo -n "<sign icon=\""${icona}"\" id=\""${id}"\"  ref=\"SK:"${nazov}"\" ";
	 
	if [ "${dodatkova}" == "yes" ]  
	then
		echo -n "supplementary=\""${dodatkova}"\" "
	fi
	echo "name=\""${popis}"\" sk.name=\""${popis}"\">";
	 
	#subor tagy loop
	if grep -q '^'$nazov',' $subor_tagy
	then
		while IFS=, read foo tag value input field_width suffix default note
		do
			if [ "${note}" ]
			then
				echo "<!-- "${note}" -->"
			fi
			 
			echo -n "       <tag key=\""$tag"\" "
			 
			if [ "${value}" == "::val::" ]
			then
				echo -n "value=\"\$val\"/>
				       <parameter ident=\"val\" input=\""${input}"\" ";
				       if [ "${suffix}" ]
				       then
					       echo -n "suffix=\""${suffix}"\" ";
				       fi
				        
				       echo "default=\""${default}"\" field_width=\""${field_width}"\"/>";
			       else
				       echo "value=\""${value}"\"/>"
			       fi
			        
			       unset foo tag value input field_width suffix default note
		       done < <(grep '^'$nazov',' $subor_tagy)
	       fi
	       #end subor tagy loop
	        
	       #subor dodatkovych tabuliek
	       if grep -q '^'$nazov',' $subor_dodatkovych_tabuliek
	       then
		       while IFS=, read foo suptag
		       do
			       #ziskame popis aby sa v xml lahsie orientovalo
			       supnote=`grep ','${suptag}',' $subor_znaciek|cut -d, -f4`
			       echo "  	 <supplementary id=\""${suptag}"\"/> <!-- "${supnote}" -->";
		       done < <(grep '^'${nazov}',' ${subor_dodatkovych_tabuliek})
	       fi
	       #end subor dodatkovych tabuliek
	        
	       unset icona nazov popis dodatkova
	       echo "</sign>";
       done < $subor_znaciek
       #end subor znaciek loop
        
       echo "</roadsignpreset>";
