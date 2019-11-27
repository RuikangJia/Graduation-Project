#2019-06-11 
#功能：取差异性模块与性状相关基因交集




#导入数据
load("modsHubGenesN.RData")
load("modsHubGenesT.RData")



#取交集，去空表
resultT = modsHubGenesT
resultN = modsHubGenesN


#整理合并
resultT = unlist(resultT)
names(resultT) = NULL
resultN = unlist(resultN)
names(resultN) = NULL

result = c(na.omit(union(resultT,resultN)))

save(result,file = "result.RData")
