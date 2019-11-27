#时间：2018-10-09 
#功能：将TCGA表达数据文件整理为表达矩阵形式
#操作目录：数据txt文件所在目录

#1.获取数据文件名
#（变动部分）
files = "BRCA.uncv2.mRNAseq_raw_counts.txt"


#2.载入数据
mydata = read.table(files,sep = '\t',header = T)
#数据整理
rownames(mydata) = mydata[,1]
mydata = mydata[,-1]
colnames(mydata) = toupper(gsub('\\.','-',colnames(mydata)))


#3.R数据形式保存数据对象
#（变动部分）
raw_counts = mydata
save(raw_counts,file = 'raw_counts.RData')

