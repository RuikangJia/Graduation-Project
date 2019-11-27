#1.获取指定数据信息
read -p "data type:" data_type;


#2.寻找并解压对应文件
file_path=$(find ./stddata__2016_07_15/ -name "*.Level_3*.gz");
file_base=$(basename $file_path);
file_dir=$(dirname $file_path);
file_path=${file_path%.tar.gz};
if [ ! -d "$file_path" ];then
	find ./stddata__2016_07_15/ -name "*.Level_3*.gz" -exec tar -zxvkf {} -C $file_dir \;
fi


#3.数据复制到指定目录
if [ ! -d $data_type ];then
	mkdir $data_type;
fi
find ./stddata__2016_07_15/ -name "*uncv*$data_type*.txt" -exec cp {} ./$data_type \;
