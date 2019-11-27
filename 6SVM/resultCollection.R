#2019-07-20 
#功能：按需求对结果进行整理


#1.准备数据文件向量
files = dir()
files = files[files != "resultCollection.R"]


#2.读入数据,计算参数
#	真正例
TP1 = c()
TP2 = c()
TP3 = c()
TPn = c()
TP = c()
#	假反例
FN1 = c()
FN2 = c()
FN3 = c()
FNn = c()
#	灵敏度/查全率
R1 = c()
R2 = c()
R3 = c()
Rn = c()
#	假正例
FP1 = c()
FP2 = c()
FP3 = c()
FPn = c()
#	查准率
P1  = c()
P2  = c()
P3  = c()
Pn  = c()
#	准确率
Q = c()

for(i in 1:length(files)){
	load(files[i])
	#	真正例
	TPn[i] = table[1,4]
	TP1[i] = table[2,1]
	TP2[i] = table[3,2]
	TP3[i] = table[4,3]
	TP[i] = TP1[i] + TP2[i] + TP3[i] + TPn[i]
	#	假反例
	FNn[i] = sum(table[1,c(1,2,3)])
	FN1[i] = sum(table[2,c(2,3,4)])
	FN2[i] = sum(table[3,c(1,3,4)])
	FN3[i] = sum(table[4,c(1,2,4)])
	#	查全率
	R1[i] = TP1[i] / (TP1[i] + FN1[i])
	R2[i] = TP2[i] / (TP2[i] + FN2[i])
	R3[i] = TP3[i] / (TP3[i] + FN3[i])
	Rn[i] = TPn[i] / (TPn[i] + FNn[i])
	#	假正例
	FPn[i] = sum(table[c(2,3,4),4])
	FP1[i] = sum(table[c(1,3,4),1])
	FP2[i] = sum(table[c(1,2,4),2])
	FP3[i] = sum(table[c(1,2,3),3])
	#	查准率
	P1[i] = TP1[i] / (TP1[i] + FP1[i])
	P2[i] = TP2[i] / (TP2[i] + FP2[i])
	P3[i] = TP3[i] / (TP3[i] + FP3[i])
	Pn[i] = TPn[i] / (TPn[i] + FPn[i])
	#	准确率
	Q[i] = TP[i] / sum(table)
}


#3.整理为数据框
#	构建数据框
evaluation = data.frame(TPn = TPn,FNn = FNn,FPn = FPn,Rn = Rn,Pn =Pn,
		TP1 = TP1,FN1 = FN1,FP1 = FP1,R1 = R1,P1 =P1,
		TP2 = TP2,FN2 = FN2,FP2 = FP2,R2 = R2,P2 =P2,	
		TP3 = TP3,FN3 = FN3,FP3 = FP3,R3 = R3,P3 =P3,	
		#TP4 = TP4,FN4 = FN4,FP4 = FP4,R4 = R4,P4 =P4,	
		TP = TP,Q = Q)
#	计算平均值
meanValue = apply(evaluation,2,mean)
evaluation = rbind(evaluation,meanValue)

		

#4.保存结果
save(evaluation,file = "evaluation.RData")
write.csv(evaluation, file = "evaluation.csv")









files = dir()
files = files[files != "resultCollection.R"]
TP = c()
FN = c()
FP = c()
TN = c()

#	查准率
P = c()
R = c()
#	准确率
Q = c()

for(i in 1:length(files)){
	load(files[i])
	TP[i] = table[1,1]
	TN[i] = table[2,2]
	FP[i] = table[2,1]
	FN[i] = table[1,2]

	R[i] = TP[i] / (TP[i] + FN[i])
	P[i] = TP[i] / (TP[i] + FP[i])
	Q[i] = (TP[i]+TN[i]) / sum(table)
}


#3.整理为数据框
#	构建数据框
evaluation = data.frame(TP = TP, TN = TN, FP = FP, FN = FN, R = R,P =P,Q = Q)
#	计算平均值
meanValue = apply(evaluation,2,mean)
evaluation = rbind(evaluation,meanValue)

		

#4.保存结果
save(evaluation,file = "evaluation.RData")
write.csv(evaluation, file = "evaluation.csv")

