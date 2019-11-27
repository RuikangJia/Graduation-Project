



#1.相关包
library(XML)
library(rvest)
library(clusterProfiler)


#2.数据导入
load("allResult.RData")
genes = bitr(allResultDeDup,fromType="ENTREZID", toType="SYMBOL", OrgDb="org.Hs.eg.db")
genes$url = paste("https://www.ncbi.nlm.nih.gov/gene/",genes$ENTREZID,sep="")


#3.循环爬取
for(i in 1:nrow(genes)){
	web = read_html(genes$url[i],encoding = 'utf-8')
	n = match("Summary",web %>% html_nodes("div#summaryDiv dl#summaryDl dt") %>% html_text)
	if(is.na(n)){
		summary = "NA"
	}else{
		summary = (web %>% html_nodes("div#summaryDiv dl#summaryDl dd"))[n] %>% html_text
	}
	genes[i,"summary"] = gsub("\n","",summary)
}


#4.保存结果
write.table(recordeGenes[,-3],file = "recordeGenes.txt",eol = "\n",row.names = F)
write.table(nonRecordeGenes[,-3],file = "nonRecordeGenes.txt",eol = "\n",row.names = F)
save(recordeGenes,nonRecordeGenes, file = "genesSummary.RData")
write.table(temp[,-3],file = "recordeGenes.txt",eol = "\n",row.names = F)



#/html/body/div[1]/div[1]/form/div[1]/div[4]/div/div[6]/div[2]/div[1]/div/div/div/dl/dt[10] 标签
#/html/body/div[1]/div[1]/form/div[1]/div[4]/div/div[6]/div[2]/div[1]/div/div/div/dl/dd[10] 具体字
