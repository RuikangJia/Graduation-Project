#2019-03-26 
#功能：整理下载的临床数据
#操作目录：临床数据所在文件夹


#1.导入数据
mydata = read.table("BRCA.clin.merged.picked.csv",sep = "\t",header = F)


#2.格式整理
rownames(mydata) = mydata[,1]
mydata = mydata[,-1]
mydata = t(mydata)
rownames(mydata) = mydata[,1]
mydata = mydata[,-1]
mydata = data.frame(mydata)
rownames(mydata) = toupper(gsub('\\.','-',rownames(mydata)))


#3.相关缺失删除
mydata = mydata[!is.na(mydata$pathologic_stage),]
mydata = mydata[!mydata$pathologic_stage == "stage x",]
mydata = mydata[!mydata$pathology_T_stage == "tx",]
mydata = mydata[!mydata$pathology_N_stage == "nx",]
mydata = mydata[!mydata$pathology_M_stage == "mx",]


#4.保存数据
clin = mydata
save(clin,file = "clin.RData")

