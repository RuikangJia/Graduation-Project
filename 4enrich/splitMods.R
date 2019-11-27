#2019-07-09 
#功能：将模块列表分开为每个模块

#1.导入数据
load("module_set_list.RData")


#2.分割
modNames = names(module_set_list)
for(i in 1:length(modNames)){
	data = module_set_list[[i]]
	save(data,file = paste(modNames[i],".RData",sep = ""))
}
