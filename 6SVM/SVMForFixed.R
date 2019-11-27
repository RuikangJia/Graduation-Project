#2019-07-15 
#功能：采用一对一方案，进行多分类分析


#1.导入包
library(sampling)
library(e1071)


#2.导入数据
load("balancedSample.RData")
#	class因子化
stageN$class = as.factor(stageN$class)
stageI$class = as.factor(stageI$class)
stageII$class = as.factor(stageII$class)
stageIII$class = as.factor(stageIII$class)
#	数据归一化
myScale = function(x){
	x = (x - min(x))/(max(x) - min(x))
}
stageN[,-ncol(stageN)] = apply(stageN[,-ncol(stageN)],2,myScale)
stageI[,-ncol(stageI)] = apply(stageI[,-ncol(stageI)],2,myScale)
stageII[,-ncol(stageII)] = apply(stageII[,-ncol(stageII)],2,myScale)
stageIII[,-ncol(stageIII)] = apply(stageIII[,-ncol(stageIII)],2,myScale)
#stageI[,1:(ncol(stageI)-1)] = scale(stageI[,1:(ncol(stageI)-1)], center = T, scale = T)
#stageII[,1:(ncol(stageII)-1)] = scale(stageII[,1:(ncol(stageII)-1)], center = T, scale = T)
#stageIII[,1:(ncol(stageIII)-1)] = scale(stageIII[,1:(ncol(stageIII)-1)], center = T, scale = T)
#stageN[,1:(ncol(stageN)-1)] = scale(stageN[,1:(ncol(stageN)-1)], center = T, scale = T)

#3.划分训练集，验证集
#	抽样比例70%
size = round(.7*sampleSize)

for(j in 1:30){
#	4组分层抽样
sub = sampling::strata(stageN, stratanames = "class", size =size, method = "srswor")
trainId = sub$ID_unit
train_N = stageN[trainId,]
test_N = stageN[-trainId,]
sub = sampling::strata(stageI, stratanames = "class", size =size, method = "srswor")
trainId = sub$ID_unit
train_I = stageI[trainId,]
test_I = stageI[-trainId,]
sub = sampling::strata(stageII, stratanames = "class", size =size, method = "srswor")
trainId = sub$ID_unit
train_II = stageII[trainId,]
test_II = stageII[-trainId,]
sub = sampling::strata(stageIII, stratanames = "class", size =size, method = "srswor")
trainId = sub$ID_unit
train_III = stageIII[trainId,]
test_III = stageIII[-trainId,]
#	6组训练集
train_N_I = data.frame(rbind(train_N, train_I))
train_N_II = data.frame(rbind(train_N, train_II))
train_N_III = data.frame(rbind(train_N, stageIII))
train_I_II = data.frame(rbind(train_I, train_II))
train_I_III = data.frame(rbind(train_I, train_III))
train_II_III = data.frame(rbind(train_II, train_III))
#	验证集
test = data.frame(rbind(test_N, test_I, test_II, test_III))


#4.构建支持向量机
#	确定支持向量机参数,默认参数 kernel = "radial"，tyep = C-classification
par_N_I = tune.svm(class~., data = train_N_I,
		gamma = seq(from = 0.001, to = 0.01, by = 0.001), 
		cost = seq(from = 1, to = 10, by = 1))
par_N_II = tune.svm(class~., data = train_N_II,
		gamma = seq(from = 0.001, to = 0.01, by = 0.001), 
		cost = seq(from = 1, to = 10, by = 1))
par_N_III = tune.svm(class~., data = train_N_III,
		gamma = seq(from = 0.001, to = 0.01, by = 0.001), 
		cost = seq(from = 1, to = 10, by = 1))
par_I_II = tune.svm(class~., data = train_I_II,
		gamma = seq(from = 0.001, to = 0.01, by = 0.001), 
		cost = seq(from = 1, to = 10, by = 1))
par_I_III = tune.svm(class~., data = train_I_III,
		gamma = seq(from = 0.001, to = 0.01, by = 0.001), 
		cost = seq(from = 1, to = 10, by = 1))
par_II_III = tune.svm(class~., data = train_II_III,
		gamma = seq(from = 0.001, to = 0.01, by = 0.001), 
		cost = seq(from = 1, to = 10, by = 1))
#	对应最优模型
fit_N_I = par_N_I$best.model
fit_N_II = par_N_II$best.model
fit_N_III = par_N_III$best.model
fit_I_II = par_I_II$best.model
fit_I_III = par_I_III$best.model
fit_II_III = par_II_III$best.model
save(fit_N_I, fit_N_II, fit_N_III, fit_I_II, fit_I_II, fit_II_III, file = paste("fit",j,".RData",sep = ""))


#5.投票法评估
#	模型预测结果
pred_1 = predict(fit_N_I, test)
pred_2 = predict(fit_N_II, test)
pred_3 = predict(fit_N_III, test)
pred_4 = predict(fit_I_II, test)
pred_5 = predict(fit_I_III, test)
pred_6 = predict(fit_II_III, test)

#	投票数据框
voteData = data.frame(test$class, stageN = 0, stageI = 0, stageII = 0, stageIII = 0)
rownames(voteData) = rownames(test)
for(i in 1:length(pred_1)){
	if(pred_1[i] == "stageN"){ voteData$stageN[i] = voteData$stageN[i] + 1}
	if(pred_1[i] == "stageI"){ voteData$stageI[i] = voteData$stageI[i] + 1}
	if(pred_1[i] == "stageII"){ voteData$stageII[i] = voteData$stageII[i] + 1}
	if(pred_1[i] == "stageIII"){ voteData$stageIII[i] = voteData$stageIII[i] + 1}
}
for(i in 1:length(pred_2)){
	if(pred_2[i] == "stageN"){ voteData$stageN[i] = voteData$stageN[i] + 1}
	if(pred_2[i] == "stageI"){ voteData$stageI[i] = voteData$stageI[i] + 1}
	if(pred_2[i] == "stageII"){ voteData$stageII[i] = voteData$stageII[i] + 1}
	if(pred_2[i] == "stageIII"){ voteData$stageIII[i] = voteData$stageIII[i] + 1}
}
for(i in 1:length(pred_3)){
	if(pred_3[i] == "stageN"){ voteData$stageN[i] = voteData$stageN[i] + 1}
	if(pred_3[i] == "stageI"){ voteData$stageI[i] = voteData$stageI[i] + 1}
	if(pred_3[i] == "stageII"){ voteData$stageII[i] = voteData$stageII[i] + 1}
	if(pred_3[i] == "stageIII"){ voteData$stageIII[i] = voteData$stageIII[i] + 1}
}
for(i in 1:length(pred_4)){
	if(pred_4[i] == "stageN"){ voteData$stageN[i] = voteData$stageN[i] + 1}
	if(pred_4[i] == "stageI"){ voteData$stageI[i] = voteData$stageI[i] + 1}
	if(pred_4[i] == "stageII"){ voteData$stageII[i] = voteData$stageII[i] + 1}
	if(pred_4[i] == "stageIII"){ voteData$stageIII[i] = voteData$stageIII[i] + 1}
}
for(i in 1:length(pred_5)){
	if(pred_5[i] == "stageN"){ voteData$stageN[i] = voteData$stageN[i] + 1}
	if(pred_5[i] == "stageI"){ voteData$stageI[i] = voteData$stageI[i] + 1}
	if(pred_5[i] == "stageII"){ voteData$stageII[i] = voteData$stageII[i] + 1}
	if(pred_5[i] == "stageIII"){ voteData$stageIII[i] = voteData$stageIII[i] + 1}
}
for(i in 1:length(pred_6)){
	if(pred_6[i] == "stageN"){ voteData$stageN[i] = voteData$stageN[i] + 1}
	if(pred_6[i] == "stageI"){ voteData$stageI[i] = voteData$stageI[i] + 1}
	if(pred_6[i] == "stageII"){ voteData$stageII[i] = voteData$stageII[i] + 1}
	if(pred_6[i] == "stageIII"){ voteData$stageIII[i] = voteData$stageIII[i] + 1}
}
voteData = voteData[,-1]
pred = c()
for(i in 1:nrow(voteData)){
	pred = c(pred,names(voteData)[which(voteData[i,] == max(voteData[i,]))[1]])
}
data = data.frame(test$class,pred)
table = table(data)
rate = (table[1,4] + table[2,1] + table[3,2] + table[4,3]) / nrow(test)
save(table,rate,file = paste("result",j,".RData",sep = ""))
}



for(j in 1:30){
sub = sampling::strata(ai, stratanames = "class", size =112, method = "srswor")
stageI = ai[sub$ID_unit,]

#	4组分层抽样
sub = sampling::strata(stageN, stratanames = "class", size =size, method = "srswor")
trainId = sub$ID_unit
train_N = stageN[trainId,]
test_N = stageN[-trainId,]
sub = sampling::strata(stageI, stratanames = "class", size =size, method = "srswor")
trainId = sub$ID_unit
train_I = stageI[trainId,]
test_I = stageI[-trainId,]
#	训练集
train_N_I = data.frame(rbind(train_N, train_I))
#	验证集
test = data.frame(rbind(test_N, test_I))

#4.构建支持向量机
#	确定支持向量机参数,默认参数 kernel = "radial"，tyep = C-classification
par = tune.svm(class~., data = train_N_I,
		gamma = seq(from = 0.001, to = 0.01, by = 0.001), 
		cost = seq(from = 1, to = 10, by = 1))
#	对应最优模型
fit = par$best.model
save(fit, file = paste("fit",j,".RData",sep = ""))


#5.投票法评估
#	模型预测结果
pred = predict(fit, test)
table = table(pred,test$class)
save(table,file = paste("result",j,".RData",sep = ""))
}






