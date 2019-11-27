#时间：2018-10-09 
#功能：从下载的数据中提取目标文件
#操作路径：stddata数据文件夹所在目录

#获取用户指定数据信息
read -p "data type:" data_type;
#获得目的压缩包所在目录，路径名，文件名
file_path=$(find ./stddata__2016_07_15/ -name "*.Level_3*.gz");
file_base=$(basename $file_path);
file_dir=$(dirname $file_path);
#根据压缩包文件名获得解压文件名
file_path=${file_path%.tar.gz};
#判断是否已经解压过
if [ ! -d "$file_path" ];then
	#将其解压到所在目录
	find ./stddata__2016_07_15/ -name "*.Level_3*.gz" -exec tar -zxvkf {} -C $file_dir \;
fi
#创建目的数据存放目录
if [ ! -d $data_type ];then
	mkdir $data_type;
fi
#查找目的数据并复制到创建的目录
find ./stddata__2016_07_15/ -name "*uncv*$data_type*.txt" -exec cp {} ./$data_type \;
