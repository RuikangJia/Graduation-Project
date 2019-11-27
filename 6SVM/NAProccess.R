#2019-07-15 
#功能：合并各个阶段的表达矩阵，用于支持向量机建模


#1.导入数据
load("./stageI/deOutlierExpr.RData")
stageI = deOutlierExpr
load("./stageII/deOutlierExpr.RData")
stageII = deOutlierExpr
load("./stageIII/deOutlierExpr.RData")
stageIII = deOutlierExpr
load("./stageIV/deOutlierExpr.RData")
stageIV = deOutlierExpr
load("./aipang/aipang.RData")


#2.导入基因
load("allResult.RData")
allResult = allResultDeDup

#3.挑选对应基因
#阶段I
#	获取ID
geneName = colnames(stageI)
temp = strsplit(geneName,split = "|",fixed = T)
allGeneID = c()
for(i in 1:length(temp)){
	allGeneID = c(allGeneID,temp[[i]][length(temp[[i]])])
}
#	提取
s1 = stageI[,match(allResult,allGeneID)]
s1 = data.frame(s1)
#阶段II
#	获取ID
geneName = colnames(stageII)
temp = strsplit(geneName,split = "|",fixed = T)
allGeneID = c()
for(i in 1:length(temp)){
	allGeneID = c(allGeneID,temp[[i]][length(temp[[i]])])
}
#	提取
s2 = stageII[,match(allResult,allGeneID)]
s2 = data.frame(s2)
#阶段III
#	获取ID
geneName = colnames(stageIII)
temp = strsplit(geneName,split = "|",fixed = T)
allGeneID = c()
for(i in 1:length(temp)){
	allGeneID = c(allGeneID,temp[[i]][length(temp[[i]])])
}
#	提取
s3 = stageIII[,match(allResult,allGeneID)]
s3 = data.frame(s3)
#阶段IV
#	获取ID
geneName = colnames(stageIV)
temp = strsplit(geneName,split = "|",fixed = T)
allGeneID = c()
for(i in 1:length(temp)){
	allGeneID = c(allGeneID,temp[[i]][length(temp[[i]])])
}
#	提取
s4 = stageIV[,match(allResult,allGeneID)]
s4 = data.frame(s4)
#癌旁
#	获取ID
geneName = colnames(aipang)
temp = strsplit(geneName,split = ".",fixed = T)
allGeneID = c()
for(i in 1:length(temp)){
	allGeneID = c(allGeneID,temp[[i]][length(temp[[i]])])
}
#	提取
sN = aipang[,match(allResult,allGeneID)]
colnames(sN) = colnames(s4)
sN = data.frame(sN)


#4.整理合并
#	添加分类标记
sN$class = "stageN"
s1$class = "stageI"
s2$class = "stageII"
s3$class = "stageIII"
s4$class = "stageIV"
#	去除基因为NA列
interGenes = intersect(names(s1),names(s2))
interGenes = intersect(interGenes,names(s3))
interGenes = intersect(interGenes,names(s4))
interGenes = intersect(interGenes,names(sN))
stageN = sN[,interGenes]
stageI = s1[,interGenes]
stageII = s2[,interGenes]
stageIII = s3[,interGenes]


#5.缺失值处理
#	查看缺失值分布
library(VIM)
exprSVM = rbind(stageN, stageI, stageII, stageIII)
png(file = "naData.png", height = 1000, width = 2000)
aggr(exprSVM, prop=T, numbers=F, combined = FALSE, axes = TRUE, labels = F)
dev.off()
#	缺失情况的相关性
library(corrplot)
library(Hmisc)
tempData = exprSVM[,-ncol(exprSVM)]
naData = tempData[,-which(apply(tempData,2,function(x) all(!is.na(x))))]
naData = abs(is.na(naData))
naData_cor = rcorr(naData)
png(file = "naData_cor.png", height = 600, width = 600)
corrplot(naData_cor$r, type = "upper", order = "hclust", tl.col = "black", tl.srt = 45,p.mat = naData_cor$P, sig.level = 0.05)
dev.off()
#	去除含有NA的基因
deNaExprSVM = exprSVM[,which(apply(tempData,2,function(x) all(!is.na(x))))]
deNaExprSVM$class = exprSVM$class
#	缺失值填充
library(Hmisc)
stageN[-ncol(stageN)] = apply(stageN[-ncol(stageN)],2,impute)
stageI[-ncol(stageI)] = apply(stageI[-ncol(stageI)],2,impute)
stageII[-ncol(stageII)] = apply(stageII[-ncol(stageII)],2,impute)
stageIII[-ncol(stageIII)] = apply(stageIII[-ncol(stageIII)],2,impute)
#library(DMwR)
#stageN[,-ncol(stageN)] = knnImputation(stageN[-ncol(stageN)],k=10,meth="weighAvg", distData = NULL) 
#stageI[,-ncol(stageI)] = knnImputation(stageI[-ncol(stageI)],k=10,meth="weighAvg", distData = NULL) 
#stageII[,-ncol(stageII)] = knnImputation(stageII[-ncol(stageII)],k=10,meth="weighAvg", distData = NULL) 
#stageIII[,-ncol(stageIII)] = knnImputation(stageIII[-ncol(stageIII)],k=10,meth="weighAvg", distData = NULL) 




#5.保存结果
save(stageN, stageI, stageII, stageIII, file = "dataFixed.RData")
save(deNaExprSVM, file = "deNaExprSVM.RData")


