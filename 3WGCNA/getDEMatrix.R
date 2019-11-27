#2019-07-13 
#功能：根据差异基因构建表达矩阵


#1.数据导入
load("stageIExpr.RData")
allData = stageIExpr
load("de_gene.RData")


#2.差异基因表达矩阵构建
#	差异基因拆分获得ID
de_temp = strsplit(de_gene, split = ".", fixed = T)
deID = c()
for(i in 1:length(de_temp)){
	deID[i] = de_temp[[i]][length(de_temp[[i]])]
}
#	全部基因拆分获得ID
all_temp = strsplit(colnames(allData), split = "|", fixed = T)
allID = c()
for(i in 1:length(all_temp)){
	allID[i] = all_temp[[i]][length(all_temp[[i]])]
}
#	提取差异基因矩阵
deMatrix = allData[,match(deID,allID)]

#3.保存数据
deMatrix = data
save(deMatrix, file = "deMatrix.RData")
