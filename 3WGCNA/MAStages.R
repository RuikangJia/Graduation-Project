#2019-07-11 
#功能：查看阶段间的模块保守情况


#1.导入数据
load("stageI.RData")
stageI = module_set_list
load("stageII.RData")
stageII = module_set_list
load("stageIII.RData")
stageIII = module_set_list
load("stageIV.RData")
stageIV = module_set_list


#2.阶段间模块比对
#	stageI，stageII之间的比对
rateIn1 = data.frame()
rateIn2 = data.frame()
interGene = list()
for(i in 1:length(stageI)){
	s1m = stageI[[i]]
	tempList = list()
	for(j in 1:length(stageII)){
		s2m = stageII[[j]]
		inter = intersect(s1m,s2m)
		rateIns1 = length(inter) / length(s1m)
		rateIns2 = length(inter) / length(s2m)
		rateIn1[j,i] = rateIns1
		rateIn2[j,i] = rateIns2
		tempList[[j]] = inter
	}
	names(tempList) = names(stageII)
	interGene[[i]] = tempList
}
names(interGene) = names(stageI)
rownames(rateIn1) = names(stageII)
colnames(rateIn1) = names(stageI)
rownames(rateIn2) = names(stageII)
colnames(rateIn2) = names(stageI)
rateIn2 = t(rateIn2)
save(rateIn1, rateIn2, interGene, file = "MAS_I_II.RData")
#	stageII，stageIII之间的比对
rateIn2 = data.frame()
rateIn3 = data.frame()
interGene = list()
for(i in 1:length(stageII)){
	s2m = stageII[[i]]
	tempList = list()
	for(j in 1:length(stageIII)){
		s3m = stageIII[[j]]
		inter = intersect(s2m,s3m)
		rateIns2 = length(inter) / length(s2m)
		rateIns3 = length(inter) / length(s3m)
		rateIn2[j,i] = rateIns2
		rateIn3[j,i] = rateIns3
		tempList[[j]] = inter
	}
	names(tempList) = names(stageIII)
	interGene[[i]] = tempList
}
names(interGene) = names(stageII)
rownames(rateIn2) = names(stageIII)
colnames(rateIn2) = names(stageII)
rownames(rateIn3) = names(stageIII)
colnames(rateIn3) = names(stageII)
rateIn3 = t(rateIn3)
save(rateIn2, rateIn3, interGene, file = "MAS_II_III.RData")
#	stageIII，stageIV之间的比对
rateIn3 = data.frame()
rateIn4 = data.frame()
interGene = list()
for(i in 1:length(stageIII)){
	s3m = stageIII[[i]]
	tempList = list()
	for(j in 1:length(stageIV)){
		s4m = stageIV[[j]]
		inter = intersect(s3m,s4m)
		rateIns3 = length(inter) / length(s3m)
		rateIns4 = length(inter) / length(s4m)
		rateIn3[j,i] = rateIns3
		rateIn4[j,i] = rateIns4
		tempList[[j]] = inter
	}
	names(tempList) = names(stageIV)
	interGene[[i]] = tempList
}
names(interGene) = names(stageIII)
rownames(rateIn3) = names(stageIV)
colnames(rateIn3) = names(stageIII)
rownames(rateIn4) = names(stageIV)
colnames(rateIn4) = names(stageIII)
rateIn4 = t(rateIn4)
save(rateIn3, rateIn4, interGene, file = "MAS_III_IV.RData")
