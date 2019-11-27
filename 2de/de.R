#时间：2018-10-10
#功能：进行差异性分析
#操作目录：数据所在目录


#	1.环境准备
#导入包
library(DESeq2)
library("BiocParallel")
register(MulticoreParam(4))


#	2.数据预处理
load("aipang.RData")
load("stageIIExpr.RData")
mydata0 = data.frame(t(aipang))
mydata1 = data.frame(t(stageIIExpr))
mydata = cbind(mydata0,mydata1)


#	3.分析过程
#制作分组对象
sample_ID = colnames(mydata)
group = as.factor(c(rep(0,nrow(aipang)),rep(1,nrow(stageIIExpr))))
colData  =  data.frame(row.names=sample_ID, group_list=group)

#差异性分析计算
dds  =  DESeqDataSetFromMatrix(countData = round(mydata),colData = colData,design = ~ group_list)
dds$group_list = relevel(dds$group_list, ref = "0")
dds = DESeq(dds)
res = results(dds,lfcThreshold=1)
resShr = lfcShrink(dds, coef=2, type="apeglm")


#	4.结果整理
#差异性基因，矩阵，丢弃基因向量提取
res  =  res[order(res$padj),]
res_de = subset(res,padj < 0.05)
de_gene = res_de@rownames
all_gene = res@rownames
abandon_gene = setdiff(all_gene,de_gene)
de_matrix = mydata[match(de_gene,rownames(mydata)),]


#	5.图片绘制
#绘制LFC图
png(file = "res.png")
plotMA(res, ylim =c(-2,2), alpha = 0.05)
abline(v=1, col = "blue")
abline(h=c(-1,1), col = "blue")
dev.off()
#绘制收缩LFC图
pdf(file = "resShr.pdf")
plotMA(resShr,ylab = "shrink log fold change", ylim =c(-2,2), alpha = 0.05)
abline(v=1, col = "blue")
dev.off()
#绘制拟合图
pdf(file = "dds.pdf")
plotDispEsts(dds)
dev.off() 


#	6.结果输出
#Excel形式输出结果
write.csv(res_de,file = "de_gene.csv")
write.csv(res,file = "res.csv")
#保留关键数据
save(colData,file = "colData.RData")
save(dds,file = "dds.RData")
save(res,file = "res.RData")
save(resShr,file = "resShr.RData")
save(all_gene,file = "all_gene.RData")
save(res_de,file = "res_de.RData")
save(de_gene,file = "de_gene.RData")
save(abandon_gene,file = "abandon_gene.RData")
save(de_matrix,file = "de_matrix.RData")



