#2019-03-26 
#功能：分别获取癌与癌旁样本
#操作目录：待提取数据所在目录



#导入数据
#(变动部分)
load("raw_counts.RData")
mydata =t(raw_counts)             


#提取
ai = mydata[(substring(rownames(mydata),14,15) < "10"),]
aipang = mydata[(substring(rownames(mydata),14,15) >= "10"),]
ai = data.frame(ai)
aipang = data.frame(aipang)


#保存
save(aipang,file = "aipang.RData")
save(ai,file = "ai.RData")




