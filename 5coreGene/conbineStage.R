#2019-07-15 
#功能：合并各个阶段的结果


#1.导入数据
load("./stageI/result.RData")
stageI = result
load("./stageII/result.RData")
stageII = result
load("./stageIII/result.RData")
stageIII = result
load("./stageIV/result.RData")
stageIV = result


#2.整理为列表结果和向量结果
#	列表结果
allResult_list = list(stageI = stageI, stageII = stageII, stageIII = stageIII, stageIV = stageIV)
#	向量结果
allResult = unlist(allResult_list)
names(allResult) = NULL
allResult[!duplicated(allResult)]



#3.保存结果
save(allResult, allResult_list, file = "allResult.RData")

