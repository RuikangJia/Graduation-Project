#时间：2018-09-25 
#功能：进行基因的各种富集分析
#操作目录：基因集数据存在的目录


#1.环境准备
library(DOSE)
library(GO.db)
library(org.Hs.eg.db)
library(GSEABase)
library(clusterProfiler)


#2.导入模块基因
load(dir())


#3.GO分组分析
goGOnBP = groupGO(gene = data, OrgDb = org.Hs.eg.db, ont = "BP", level = 3)
goGOnCC = groupGO(gene = data, OrgDb = org.Hs.eg.db, ont = "CC", level = 3)
goGOnMF = groupGO(gene = data, OrgDb = org.Hs.eg.db, ont = "MF", level = 3)
#	数据保存
save(goGOnBP,file = "goGOnBP.RData")
save(goGOnCC,file = "goGOnCC.RData")
save(goGOnMF,file = "goGOnMF.RData")
#	Excel结果
write.csv(goGOnBP, file = "goGOnBP.csv")
write.csv(goGOnCC, file = "goGOnCC.csv")
write.csv(goGOnMF, file = "goGOnMF.csv")


#4.GO富集分析
goEOnBP = enrichGO(gene = data, OrgDb = org.Hs.eg.db, ont = "BP",
		pAdjustMethod = "BH", pvalueCutoff = 0.01, qvalueCutoff = 0.05)
goEOnCC = enrichGO(gene = data, OrgDb = org.Hs.eg.db, ont = "CC",
		pAdjustMethod = "BH", pvalueCutoff = 0.01, qvalueCutoff = 0.05)
goEOnMF = enrichGO(gene = data, OrgDb = org.Hs.eg.db, ont = "MF",
		pAdjustMethod = "BH", pvalueCutoff = 0.01, qvalueCutoff = 0.05)
#	数据保存
save(goEOnBP,file = "goEOnBP.RData")
save(goEOnCC,file = "goEOnCC.RData")
save(goEOnMF,file = "goEOnMF.RData")
#	Excel结果
write.csv(goEOnBP, file = "goEOnBP.csv")
write.csv(goEOnCC, file = "goEOnCC.csv")
write.csv(goEOnMF, file = "goEOnMF.csv")
#	图片结果
png(file = "goEOnBP.png", width=800, height=600)
barplot(goEOnBP,showCategory = 30)
dev.off()
png(file = "goEOnCC.png", width=800, height=600)
barplot(goEOnBP,showCategory = 30)
dev.off()
png(file = "goEOnMF.png", width=800, height=600)
barplot(goEOnBP,showCategory = 30)
dev.off()


#5.KEGG富集分析
kegg = enrichKEGG(gene = data, organism = 'hsa', pvalueCutoff = 0.05)
#	数据保存
save(kegg, file = "kegg.RData")
#	Excel结果
write.csv(kegg, file = "kegg.csv")
#	图片结果
png(file = "kegg.png", width=800, height=600)
barplot(kegg, showCategory = 30)
dev.off()



