#!/bin/bash

for i in "$@"
do
case $i in
    --volume-wp=*)
    VOLUME_ID_WP=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    --stack-name=*)
    STACK_NAME=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
    echo "Unknown option ${i}"
    ;;
esac
done

if [ -d "$STACK_NAME" ]; then
   echo "Dicretory $STACK_NAME already exists"
   exit 1
fi

mkdir $STACK_NAME

echo $VOLUME_ID_WP
echo $STACK_NAME

arr_files=( $(ls templates) )

for i in ${arr_files[@]}
do 
    temp_arr=( $(echo $i | tr "." "\n") )
    name=${temp_arr[0]}
    echo $name
    sed 's/%STACK_NAME%/'$STACK_NAME'-'$name'/g' templates/$i > $STACK_NAME/$i
    #sed 's/%VOLUME_ID_WP%/'${VOLUME_ID_WP}'/g' $STACK_NAME/$i > $STACK_NAME/$i
done

#arr_full=( templates/* )
#arr_file=( )
#for i in ${arr[@]}
#do 
#  echo $i
#  echo "res"
#done
#sed 's/%VOLUME_ID_WP%/'${VOLUME_ID_WP}'/g' templates/wordpress.yml.tpl > $STACK_NAME/wordpress.yml

