#2019-03-04 
#功能：对基因进行生存分析


#0.包的安装
#source("https://bioconductor.org/biocLite.R")
#options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/")
#biocLite("RTCGA")
#biocLite("RTCGA.clinical")
#biocLite("RTCGA.mRNA")


#1.获取临床数据
library(RTCGA)
infoTCGA = infoTCGA() 
library(RTCGA.clinical)
clin = survivalTCGA(BRCA.clinical)


#2.导入数据
#	目标基因
load("allResult.RData")
targetGene = allResultDeDup
#	表达数据
load("ai.RData")


#3.提取对应基因表达矩阵
#	基因名称处理
geneNames = names(ai)
geneID = c()
for(i in 1:length(geneNames)){
	temp = strsplit(geneNames[i],split = ".",fixed = T)
	geneID[i] = temp[[1]][length(temp[[1]])]
}
#	提取
expr = ai[,match(targetGene,geneID)]
#	NA补充
#library(Hmisc)
#expr = apply(expr,2,impute)


#4.提取对应样本临床数据
#	样本名称处理
sampleNames = rownames(expr)
#	提取
inter = intersect(clin$bcr_patient_barcode,substr(sampleNames,1,12))
expr = expr[match(inter,substr(sampleNames,1,12)),]
#	缺失值填充
library(Hmisc)
expr = apply(expr,2,impute)
clin = clin[match(inter,clin$bcr_patient_barcode),]
#	整合数据
data = cbind(expr,clin)


#5.生存分析
library(ggplot2)
library(ggpubr)
library(magrittr)
library(survminer)
library(survival)
#	时间数据
surv = Surv(data$times,data$patient.vital_status)
#	循环计算p值
pVals = c()
for(i in 1:(length(names(data))-3)){
	#	表达水平高低两组
	group = ifelse(data[,i] > median(data[,i]),"high","low")
	#	生存分析
	sfit = survival::survfit(surv~group,data = data)
	survdiff = survdiff(surv~group)
	pval = 1 - pchisq(survdiff$chisq, length(survdiff$n)-1)
	pVals[i] = pval
	if(pval < 0.05){
		ggsurvplot(sfit, data = data, conf.int = F, pval = T)
		ggsave(file = paste(names(data)[i],".png",sep = ""))
	}
}
dev.off()
#	p值结果
pVals = data.frame(pVals = pVals)
rownames(pVals) = names(data)[-c(length(data),length(data)-1,length(data)-2)]
#	显著基因
gene = rownames(pVals)[pVals < 0.05]
#	结果保存
save(pVals,gene, file = "SVResult.RData")
