#2019-07-15 
#功能：样本的数目规划等，数据的提前整理


#1.导入数据
load("dataFixed.RData")


#2.样本的整理
#	最小类别的数目
sampleSize = min(nrow(stageN),nrow(stageI),nrow(stageII),nrow(stageIII))
#	各类抽取上述数目样本
stageN = stageN[sample(nrow(stageN), sampleSize, replace = F), ]
stageI = stageI[sample(nrow(stageI), sampleSize, replace = F), ]
stageII = stageII[sample(nrow(stageII), sampleSize, replace = F), ]
stageIII = stageIII[sample(nrow(stageIII), sampleSize, replace = F), ]


#3.以分离的形式保存
save(stageI,stageII,stageIII,stageN,sampleSize, file = "balancedSample.RData")
