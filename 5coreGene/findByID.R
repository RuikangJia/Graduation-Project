#2019-06-03 
#功能：查看给定基因存在的模块


#基因向量
geneNames = c("216","332","595","898","999","1019",
	"1021","1048","1084","1493","2099","2064","3880",
	"4288","4318","4582","4830","5111","5241","7422")


#模块列表
load("module_set_list.RData")
myList = module_set_list

#查找
modNames = c()
for(geneName in geneNames){
	for(i in 1:length(names(myList))){
		if(!is.na(match(geneName,myList[[i]]))){
			modNames = c(modNames,names(myList)[i])
			flag = T
			break;
		}else{
			flag = F
		}
	}
	if(!flag){
		modNames = c(modNames,NA)
	}
}


#结果整理保存
geneLocation = data.frame(geneNames,modNames)
save(geneLocation,file = "geneLocation.RData")

