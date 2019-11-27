#1.环境准备
library(WGCNA)
options(stringsAsFactors = FALSE)
allowWGCNAThreads()
ALLOW_WGCNA_THREADS=4



#2.读入基因表达矩阵，整理数据
#(变动部分：表达数据)
load("stageIVExpr.RData")
myExpr = stageIVExpr

#3.检查数据
#3.1缺失值检查
gsg = goodSamplesGenes(myExpr, verbose = 3)
if (!gsg$allOK){
	if (sum(!gsg$goodGenes)>0){
		printFlush(paste("Removing genes:", paste(colnames(myExpr)[!gsg$goodGenes], collapse = ", ")))
	}
	if (sum(!gsg$goodSamples)>0)
		printFlush(paste("Removing samples:", paste(rownames(myExpr)[!gsg$goodSamples], collapse = ", ")))
	gsg_throw_gene = colnames(myExpr)[!gsg$goodGenes]
	save(gsg_throw_gene,file = "gsg_throw_gene.RData")
	myExpr = myExpr[gsg$goodSamples, gsg$goodGenes]
}
save(gsg,file = "gsg.RData")
#（变动部分：去除NA过多的样本和基因后剩下的表达数据）
deNAExpr = myExpr
save(deNAExpr,file = "deNAExpr.RData")
#3.2离群值检查，同时除去
#	计算样本之间的距离
sampleTree = hclust(dist(myExpr), method = "average")
#	样本聚类树
save(sampleTree,file = "sampleTree.RData")
pdf(file = "sampleTree.pdf")
par(mar = c(5,5,5,5))
#	绘图
plot(sampleTree, main = "Sample clustering to detect outliers", 
		sub = "", xlab = "", cex.lab = .1,
		cex.axis = 1.5, cex.main = 2,labels = F)
#(变动部分：裁剪高度)
cutheight = 300#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<看图得出

abline(h = cutheight, col = "red")
dev.off()
#	对树进行裁剪
clust = cutreeStatic(sampleTree, cutHeight = cutheight, minSize = 10)
#	查看剪后情况，保留对应样本
table(clust)
keepSamples = (clust==1)
myExpr = myExpr[keepSamples, ]
#	保存除去样本后的差异基因信息
#(变动部分：去除离群样本的表达数据)
deOutlierExpr = myExpr
save(deOutlierExpr,file="deOutlierExpr.RData")





#4.样本临床数据热图
#	4.1临床数据整理
#（变动部分：挑选需要的临床变量）
load("stageIVclin.RData")
myClin = stageIVclin
myClin = myClin[,c(2:5,8:10,16)]
#因子数值化
for(i in names(myClin)){
	if(i != "pathologic_stage")
	myClin[,i] = as.numeric(myClin[,i])
}
#	选取需要的临床样本
matchResult = match(substr(rownames(myExpr),1,12),substr(rownames(myClin),1,12))
myClin = myClin[matchResult,]
#	去除离群后再次建树
sampleTree2 = hclust(dist(myExpr), method = "average")
#	红色高，白色低，灰色缺失
traitColors = numbers2colors(myClin, centered = T,signed = T)
#	去离群后样本树与临床数据热图
sampleTree2 = sampleTree2
save(sampleTree2,file = "sampleTree2.RData")
pdf(file = "sampleTreeAndColor.pdf")
plotDendroAndColors(sampleTree2, traitColors,groupLabels = names(myClin),main = "Sample dendrogram and trait heatmap",marAll = c(4,10,4,4))#,dendroLabels = F
dev.off()







#5.选择软阈值
#	计算软阈值
powers = c(c(1:10), seq(from = 12, to = 30, by = 2))
sft = pickSoftThreshold(myExpr, powerVector = powers, verbose = 5)
save(sft,file = "sft.RData")
#	绘制软阈值选取图
cex1 = 0.8;
pdf("pick_soft_thresholding(1).pdf");
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
	xlab = "Soft Threshold (power)",ylab = "Scale Free Topology Model Fit,signed R^2",type = "n",
	main = paste("Scale independence"));
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],labels = powers,cex = cex1,col = "red")
abline(h = 0.9,col = "red")
dev.off()
pdf("pick_soft_thresholding(2).pdf")
plot(sft$fitIndices[,1], sft$fitIndices[,5],xlab = "Soft Threshold (power)",ylab = "Mean Connectivity", type = "n",main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels = powers, cex = cex1,col = "red")
dev.off()




#6.网络构建
#	计算邻接矩阵
softPower = sft$powerEstimate
adjacency = adjacency(myExpr, power = softPower)
#	计算拓扑重叠矩阵
TOM = TOMsimilarity(adjacency)
#	获得相异矩阵
dissTOM = 1-TOM
rm(adjacency,TOM)
gc()
#	计算基因树
geneTree = hclust(as.dist(dissTOM), method = "average")
#	对基因树进行动态剪切
minModuleSize = 30
dynamicMods = cutreeDynamic(dendro = geneTree,
		distM = dissTOM,deepSplit = 2, 
		pamRespectsDendro = FALSE,
		minClusterSize = minModuleSize)
#	每个基因的颜色
dynamicColors = labels2colors(dynamicMods)
#	合并相近的模块
MEList = moduleEigengenes(myExpr, colors = dynamicColors)
MEs = MEList$eigengenes
MEDiss = 1-cor(MEs);
METree = hclust(as.dist(MEDiss), method = "average")
#	模块基因树绘图
pdf(file = "METree.pdf")
plot(METree, main = "Clustering of module eigengenes",xlab = "", sub = "")
MEDissThres = 0.25
abline(h=MEDissThres, col = "red")
dev.off()
#	合并距离小于0.25的模块
merge = mergeCloseModules(myExpr, dynamicColors, cutHeight = MEDissThres, verbose = 3)
mergedColors = merge$colors
mergedMEs = merge$newMEs
#	绘图：基因树模块
pdf(file = "geneDendro.pdf")
plotDendroAndColors(geneTree, cbind(dynamicColors, mergedColors),c("Dynamic TreeCut", "Merged dynamic"),dendroLabels = FALSE, hang = 0.03,addGuide = TRUE, guideHang = 0.05,marAll = c(1, 5, 3, 1))
dev.off()
#	绘图：模块之间相关性
pdf(file = "MEs.pdf")
plotEigengeneNetworks(MEs, 
                      "Eigengene adjacency heatmap", 
                      marHeatmap = c(3,4,2,2), 
                      plotDendrograms = FALSE, 
                      xLabelsAngle = 90) 
dev.off()
#	保存重要变量
moduleColors = mergedColors
colorOrder = c("grey", standardColors(50))
moduleLabels = match(moduleColors, colorOrder)-1
MEs = mergedMEs
save(MEs, moduleLabels, moduleColors, geneTree, file = "network.RData")
		




#7.模块导出
#	导出各个模块的基因组成的列表
colorset = names(table(moduleColors))
temp = unlist(strsplit(colnames(myExpr),split = "|",fixed = T))
temp = matrix(temp,ncol=2,byrow=T)
geneSymbols = temp[,1]
geneEntries = temp[,2]
module_set_list = list()
for(i in colorset){
	colorgene = geneEntries[i== moduleColors]
	module_set_list[i] = list(colorgene)
}
save(module_set_list,file = "module_set_list.RData")




