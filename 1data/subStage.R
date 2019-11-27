#2019-07-13 
#功能：对阶段的亚阶段，整理，因子化


#1.导入数据
load("stageIVclin.RData")
myClin = stageIVclin
myClin = myClin[,c(2:5,7:10,16)]


#2.按组织学分期合并
myClin$pathology_N_stage[myClin$pathology_N_stage == "n0 (i-)"] = "n0"
myClin$pathology_N_stage[myClin$pathology_N_stage == "n0 (i+)"] = "n0"
myClin$pathology_N_stage[myClin$pathology_N_stage == "n0 (mol+)"] = "n0"
myClin$pathology_N_stage[myClin$pathology_N_stage == "n1mi"] = "n0"
myClin$pathology_M_stage[myClin$pathology_M_stage == "cm0 (i+)"] = "m0"


#3.变量因子数值化
myClin$pathologic_stage = as.numeric(factor(myClin$pathologic_stage, levels = c("stage i","stage ia","stage ib","stage ii","stage iia","stage iib","stage iii","stage iiia","stage iiib","stage iiic","stage iv","stage x"), order = T))
myClin$pathology_T_stage = as.numeric(factor(myClin$pathology_T_stage, levels = c("t1","t1a","t1b","t1c","t2","t2a","t2b","t3","t3a","t4","t4b","t4d","tx"), order = T))
myClin$pathology_N_stage = as.numeric(factor(myClin$pathology_N_stage, levels = c("n0","n1","n1a","n1b","n1c","n2","n2a","n3","n3a","n3b","n3c","nx"), order = T))
myClin$pathology_M_stage = as.numeric(factor(myClin$pathology_M_stage, levels = c("m0","m1"), order = T))


#4.保存结果
sIVClin = myClin
save(sIVClin, file = "sIVClin.RData")
