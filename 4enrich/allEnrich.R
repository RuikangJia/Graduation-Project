#2019-07-11
#功能：对所有模块进行统一的比对kegg富集分析

#1.导入包
library(DOSE)
library(GO.db)
library(org.Hs.eg.db)
library(GSEABase)
library(clusterProfiler)


#2.导入数据
load(dir())


#3.富集分析
kegg = compareCluster(module_set_list, fun = "enrichKEGG")


#4.保存结果 
#	数据形式
save(kegg, file = "kegg.RData")
#	Excel形式
write.csv(kegg, file = "kegg.csv")
#	图片形式
png(file = "kegg.png", width=2000, height=1000)
dotplot(kegg)
dev.off()

