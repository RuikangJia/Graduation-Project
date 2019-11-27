#2019-04-03 
#功能：将整个临床数据分解为各个分期的临床数据
#操作目录：临床数据所在目录


#1.导入数据
load("clin.RData")
mydata = clin


#2.提取各阶段样本并保存
match = substr(mydata$pathologic_stage,7,7) == "x"
stageXclin = mydata[match,]
mydata = mydata[!match,]
save(stageXclin,file = "stageXclin.RData")

match = substr(mydata$pathologic_stage,8,8) == "v"
stageIVclin = mydata[match,]
mydata = mydata[!match,]
save(stageIVclin,file = "stageIVclin.RData")

match = substr(mydata$pathologic_stage,9,9) == "i"
stageIIIclin = mydata[match,]
mydata = mydata[!match,]
save(stageIIIclin,file = "stageIIIclin.RData")

match = substr(mydata$pathologic_stage,8,8) == "i"
stageIIclin = mydata[match,]
mydata = mydata[!match,]
save(stageIIclin,file = "stageIIclin.RData")

match = substr(mydata$pathologic_stage,7,7) == "i"
stageIclin = mydata[match,]
mydata = mydata[!match,]
save(stageIclin,file = "stageIclin.RData")
