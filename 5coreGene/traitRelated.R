#2019-07-20 
#功能：筛选核心基因


#1.环境准备
library(WGCNA)
options(stringsAsFactors = FALSE)
allowWGCNAThreads()
ALLOW_WGCNA_THREADS=4
#1.导入整理数据
load("network.RData")
load("deOutlierExpr.RData")
load("deMods.RData")
module_set_list = deMods
myExpr = deOutlierExpr
relateMod = names(module_set_list[names(module_set_list) != "grey"])
relateMod = names(module_set_list)
match = relateMod[match(moduleColors,relateMod)] == moduleColors
moduleColors = moduleColors[!is.na(match)]
myExpr = myExpr[,!is.na(match)]


#2.样本临床数据(以单独除去，待删除)
#	2.1临床数据整理
#（变动部分：挑选需要的临床变量）
load("sIClin.RData")
myClin = sIClin
#	选取需要的临床样本
matchResult = match(substr(rownames(myExpr),1,12),tolower(substr(rownames(myClin),1,12)))
myClin = myClin[matchResult,]
#	选取分期临床性状
myClin = myClin[,c(6,7)]


#3.模块与性状关联
#3.1模块整体与性状整体
#	表达数据的维度
nGenes = ncol(myExpr)
nSamples = nrow(myExpr)
#	计算临床与模块基因的相关性
MEs = MEs[,match(relateMod,substring(names(MEs),3))]
MEs = MEs[,names(MEs) != "MEgrey"]
moduleTraitCor_noFP = cor(MEs, myClin, use = "p")
moduleTraitPvalue_noFP = corPvalueStudent(moduleTraitCor_noFP, nSamples)
#	绘图：模块与性状之间的相关性
textMatrix_noFP = paste(signif(moduleTraitCor_noFP, 2), "\n(", signif(moduleTraitPvalue_noFP, 1), ")", sep = ""); 
png(file = "moduleTraitCor.png", width = 500, height = 800)
par(mar = c(8,9,3,3))
labeledHeatmap(Matrix = moduleTraitCor_noFP, 
               xLabels = names(myClin), 
               yLabels = names(MEs), 
               ySymbols = names(MEs), 
               colorLabels = FALSE, 
               colors = blueWhiteRed(50), 
               textMatrix = textMatrix_noFP,
               setStdMargins = FALSE, 
#		cex.text = .7,
#               cex.lab.x = .5,
#               cex.lab.y = .5,
               zlim = c(-1,1), 
               main = paste("stageIV Module-trait relationships")) 
dev.off()




#3.2挑选模块中的hub基因
#	计算基因与模块的相关性（MM）
geneModuleMembership = as.data.frame(cor(myExpr, MEs, use = "p"))
MMPvalue = as.data.frame(corPvalueStudent(as.matrix(geneModuleMembership), nSamples))

#	计算基因与表型的相关性（GS）
#（变动部分：特定的性状，模块基因命名）
targetTraitDF = as.data.frame(myClin$pathology_T_stage)
names(targetTraitDF) = "pathology_T_stage"
geneTraitSignificance = as.data.frame(cor(myExpr, targetTraitDF, use = "p"))
GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples))
#	模块的hubGene
modsHubGenes = list()
for(modName in relateMod){
	match = (geneTraitSignificance >0.1 & (GSPvalue < 0.05) & (geneModuleMembership[,paste("ME",modName,sep = "")] > .8) & MMPvalue[,paste("ME",modName,sep = "")]<0.05 & moduleColors == modName)
	hubGene = colnames(myExpr)[match]
	if(length(hubGene) != 0){
		temp = unlist(strsplit(hubGene,split = "|",fixed = T))
		temp = matrix(temp,ncol=2,byrow=T)
		hubGene = temp[,2]	
	}
	modsHubGenes[modName] = list(hubGene)
}
modsHubGenesT = modsHubGenes
save(modsHubGenesT,file = "modsHubGenesT.RData")


#	计算基因与表型的相关性（GS）
#（变动部分：特定的性状，模块基因命名）
targetTraitDF = as.data.frame(myClin$pathology_N_stage)
names(targetTraitDF) = "pathology_N_stage"
geneTraitSignificance = as.data.frame(cor(myExpr, targetTraitDF, use = "p"))
GSPvalue = as.data.frame(corPvalueStudent(as.matrix(geneTraitSignificance), nSamples))
#	模块的hubGene
modsHubGenes = list()
for(modName in relateMod){
	match = (geneTraitSignificance >0.1 & (GSPvalue < 0.05) & (geneModuleMembership[,paste("ME",modName,sep = "")] > .8) &MMPvalue[,paste("ME",modName,sep = "")]<0.05 & moduleColors == modName)
	hubGene = colnames(myExpr)[match]
	if(length(hubGene) != 0){
		temp = unlist(strsplit(hubGene,split = "|",fixed = T))
		temp = matrix(temp,ncol=2,byrow=T)
		hubGene = temp[,2]	
	}
	modsHubGenes[modName] = list(hubGene)
}
modsHubGenesN = modsHubGenes
save(modsHubGenesN,file = "modsHubGenesN.RData")

