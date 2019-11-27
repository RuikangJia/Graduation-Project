#1.获取指定数据类型
read -p "data type:" data_type;


#2.获得目的压缩包所在目录，路径名，文件名
file_path=$(find ./stddata__2016_07_15/ -name "*.Level_3*.gz");
file_base=$(basename $file_path);
file_dir=$(dirname $file_path);


#3.根据压缩包文件名获得解压文件名
file_path=${file_path%.tar.gz};
if [ ! -d "$file_path" ];then
	find ./stddata__2016_07_15/ -name "*.Level_3*.gz" -exec tar -zxvkf {} -C $file_dir \;
fi


#4.复制移动目的数据
if [ ! -d $data_type ];then
	mkdir $data_type;
fi
find ./stddata__2016_07_15/ -name "*uncv*$data_type*.txt" -exec cp {} ./$data_type \;
