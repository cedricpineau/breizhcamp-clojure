#!/bin/sh

# vars
content=content
slidekey=slides
directory=/home/sc/Documents/Breizhcamp/Clojure_Kisses
outputfile=$directory/index.html
tmpfile=/tmp/index-$$.html
step=80
xpos=0

#nbprocess=`ps aux | grep build.sh | grep -v grep | wc -l`
#if [ $nbprocess -gt 2 ] ; then
#  exit 0;
#fi

cd $directory
rm -f $tmpfile
for file in `find $content -name "*.html" | sort`
do
  if [ "${file#*$slidekey}" != "$file" ] ; then
    write=false
    while IFS= read -r line  
    do  
     if [ "${line#*<!--/}" != "$line" ] ; then
       echo "        </div>\n" >> $tmpfile
       write=false
       continue
     elif [ "${line#*<!--#}" != "$line" ] ; then
       title=`echo $line | cut -c6- | cut -f1 -d"#"`
       echo "        <div id=\"$title\" class=\"step slide\" data-x=\"$xpos\" data-y=\"-100\">" >> $tmpfile
       xpos=`expr $xpos + $step` 
       write=true
       continue
     fi
     if [ $write = 'true' ] ; then
       echo -n "            " >> $tmpfile
       echo "$line" >> $tmpfile 
     fi
    done < "$file"
  else
    cat $file >> $tmpfile
  fi
done

mv $tmpfile $outputfile

