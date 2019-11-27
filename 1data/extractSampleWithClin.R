#2019-03-26 
#功能：筛选各个阶段的临床信息样本
#操作目录：临床数据，表达数据共同目录


#1.导入表达数据
load("ai.RData")
myExpr = ai

#2.导入临床数据
load("stageIclin.RData")
myClin = stageIclin
clinSamples = rownames(myClin)
expressSamples = rownames(myExpr)
expressSamples = substring(expressSamples,1,12)
matchSamples = na.omit(match(clinSamples,expressSamples))
stageIExpr = myExpr[matchSamples,]
stageIExpr = data.frame(stageIExpr)
save(stageIExpr,file = "stageIExpr.RData")

load("stageIIclin.RData")
myClin = stageIIclin
clinSamples = rownames(myClin)
expressSamples = rownames(myExpr)
expressSamples = substring(expressSamples,1,12)
matchSamples = na.omit(match(clinSamples,expressSamples))
stageIIExpr = myExpr[matchSamples,]
stageIIExpr = data.frame(stageIIExpr)
save(stageIIExpr,file = "stageIIExpr.RData")

load("stageIIIclin.RData")
myClin = stageIIIclin
clinSamples = rownames(myClin)
expressSamples = rownames(myExpr)
expressSamples = substring(expressSamples,1,12)
matchSamples = na.omit(match(clinSamples,expressSamples))
stageIIIExpr = myExpr[matchSamples,]
stageIIIExpr = data.frame(stageIIIExpr)
save(stageIIIExpr,file = "stageIIIExpr.RData")

load("stageIVclin.RData")
myClin = stageIVclin
clinSamples = rownames(myClin)
expressSamples = rownames(myExpr)
expressSamples = substring(expressSamples,1,12)
matchSamples = na.omit(match(clinSamples,expressSamples))
stageIVExpr = myExpr[matchSamples,]
stageIVExpr = data.frame(stageIVExpr)
save(stageIVExpr,file = "stageIVExpr.RData")
