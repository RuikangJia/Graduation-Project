#2019-08-28 
#功能：模块中差异基因的占比

#1.导入数据
load("module_set_list.RData")
load("de_gene.RData")



#2.循环比对
#	提取差异基因ID
tempSplit = strsplit(de_gene, fixed = T, split = ".")
geneID = c()
for(i in 1:length(tempSplit)){
	geneID[i] = tempSplit[[i]][length(tempSplit[[i]])]
}
#a = unlist(deMods)
#names(a) = NULL
#b = unlist(module_set_list)
#names(b) = NULL
#length(setdiff(a,geneID))
#length(setdiff(b,geneID))

#	计算占比整理结果
rate = c()
for(j in 1:length(module_set_list)){
	modGene = module_set_list[[j]]
	modGeneDe = na.omit(geneID[match(modGene,geneID)])
	modGeneNotDe = setdiff(modGene,modGeneDe)
	rate[j] = length(modGeneDe)/length(modGene)
}
result = data.frame(modName = names(module_set_list), rate = rate)
result = result[order(result[,2], decreasing=T),]



#3.提取差异模块
deModsNames = as.character(result$modName[result$rate > 0.05])
deMods = module_set_list[deModsNames]



#4.结果保存
#	图片保存
load("result.RData")
png(file = "result.png")
barplot(result$rate, ylim = c(0,1), xlab = "mods", ylab = "rate", main = "stageIV",cex.main = 2.2,cex.lab = 1.8,cex.axis = 1.5)
abline(h = 0.05, col = "red")
dev.off()
#	数据保存
save(result, deMods, file = "result.RData")



#5.temp
load("result.RData")
library(DOSE)
library(GO.db)
library(org.Hs.eg.db)
library(GSEABase)
library(clusterProfiler)
kegg = compareCluster(deMods, fun = "enrichKEGG")
save(kegg, file = "kegg.RData")
write.csv(kegg, file = "kegg.csv")
png(file = "kegg.png", width=1000)
dotplot(kegg,font.size = 8,showCategory = 5)
dev.off()






target = c(
	"Breast cancer",
		"Estrogen signaling pathway",#雌激素信号通路
			"Calcium signaling pathway",
		"MAPK signaling pathway",#细胞增殖分化和迁移
			"TNF signaling pathway",
		"PI3K-Akt signaling pathway",#调节基本细胞功能，例如转录，翻译，增殖，生长和存活
			"mTOR signaling pathway",#控制细胞骨架组织
			"Insulin signaling pathway",
			"ErbB signaling pathway",
			"VEGF signaling pathway",#细胞增殖迁移
		"Notch signaling pathway",#信号转导
		"Wnt signaling pathway",#细胞增殖和不对称细胞分裂的控制
			"Focal adhesion",#细胞运动，细胞增殖，细胞分化，基因表达调节和细胞存活
			"TGF-beta signaling pathway",#调节广谱细胞功能，如增殖，凋亡，分化和迁移
			"Adherens junction",#限制细胞运动和增殖
		"p53 signaling pathway",#影响细胞周期，细胞衰老或细胞凋亡
		"Cell cycle",#细胞周期
			"Apoptosis",#细胞凋亡
		"Homologous recombination",#同源重组对于DNA双链断裂的修复至关重要，一些肿瘤抑制因子，通过HR维持基因组完整性。
		"Ras signaling pathway",
			"T cell receptor signaling pathway",
			"Rap1 signaling pathway",

		"PPAR signaling pathway",#核激素受体，细胞增殖
		"Hedgehog signaling pathway",#控制细胞增殖，组织模式，干细胞维持和发育中具有多种作用)
		"cAMP signaling pathway",#重要的信号转导
		"ECM-receptor interaction",#粘附，迁移，分化，增殖和凋亡
		"JAK-STAT signaling pathway",#多种细胞因子和生长因子的主要信号传导机制
		"Cytokine-cytokine receptor interaction"#关键的细胞间调节剂和细胞动员剂，参与先天性和适应性炎症宿主防御，细胞生长，分化，细胞死亡
)

a = kegg@compareClusterResult$Cluster[!is.na(match(kegg@compareClusterResult$Description,target))]
a[!duplicated(a)]

