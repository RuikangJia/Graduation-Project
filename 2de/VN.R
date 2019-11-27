library(VennDiagram)


venn.diagram(x = list(stageI = de1,stageII = de2,stageIII = de3,stageIV = de4),filename = "vn.png",
	col = "black", #边框颜色
	lwd = 2, #边框线宽度
	fontface = "bold", #标签字体
	fill = c("cornflowerblue", "green", "yellow", "darkorchid1"),
	#cat.col = c("darkblue", "darkgreen", "orange", "darkorchid4"),
	alpha = 0.4, #透明度
	cex = 1.5, #标签字体大小
	cat.cex = 1.5, #类名字体大小
	cat.fontface = "bold", #类名字体
	margin = 0.04 #边际距离
	)


load("de1.RData")
temp = strsplit(as.character(de_gene), fixed = T, split = ".")
geneID = c()
for(i in 1:length(temp)){
	geneID[i] = temp[[i]][length(temp[[i]])]
}
de1 = geneID
load("de2.RData")
temp = strsplit(de_gene, fixed = T, split = ".")
geneID = c()
for(i in 1:length(temp)){
	geneID[i] = temp[[i]][length(temp[[i]])]
}
de2 = geneID
load("de3.RData")
temp = strsplit(de_gene, fixed = T, split = ".")
geneID = c()
for(i in 1:length(temp)){
	geneID[i] = temp[[i]][length(temp[[i]])]
}
de3 = geneID
load("de4.RData")
temp = strsplit(de_gene, fixed = T, split = ".")
geneID = c()
for(i in 1:length(temp)){
	geneID[i] = temp[[i]][length(temp[[i]])]
}
de4 = geneID

load("G:\\jrk\\毕业工作\\2de\\VN图\\de1.RData")
de1 = de_gene
load("G:\\jrk\\毕业工作\\2de\\VN图\\de2.RData")
de2 = de_gene
load("G:\\jrk\\毕业工作\\2de\\VN图\\de3.RData")
de3 = de_gene
load("G:\\jrk\\毕业工作\\2de\\VN图\\de4.RData")
de4 = de_gene


temp = strsplit(as.character(abandon_gene), fixed = T, split = ".")
geneID = c()
for(i in 1:length(temp)){
	geneID[i] = temp[[i]][length(temp[[i]])]
}

