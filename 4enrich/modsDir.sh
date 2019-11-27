#2019-07-09 
#功能：创建模块对应的文件夹，并将模块数据移入对应文件夹中
#初始状体：module_set_list.RData与所有mod.RData在同一个文件夹下


ls | grep -E '*RData' | awk -F. '{print $1}' > mods.txt


while read line
do
if [ ! -d "$line" ] ;then
	mkdir $line;
fi
	data=${line}".RData";
	mv $data $line/$data;
done < mods.txt



#注：
#	删除反选文件夹：ls | grep -v '.*' | xargs rm -rf
