load("dedown.RData")
load("deup.RData")
load("result.RData")

temp = strsplit(deup, fixed = T,split = ".")
upID = c()
for(i in 1:length(temp)){
	upID[i] = temp[[i]][length(temp[[i]])]
}
temp = strsplit(dedown, fixed = T,split = ".")
downID = c()
for(i in 1:length(temp)){
	downID[i] = temp[[i]][length(temp[[i]])]
}

upResult = intersect(upID,result)
downResult = intersect(downID,result)
noResult = setdiff(result,union(upResult,downResult))

save(upResult,file = "upResult.RData")
save(downResult,file = "downResult.RData")
save(noResult,file = "noResult.RData")


library(DOSE)
library(GO.db)
library(org.Hs.eg.db)
library(GSEABase)
library(clusterProfiler)

upb = bitr(up, fromType="ENTREZID", toType="SYMBOL", OrgDb="org.Hs.eg.db")
downb = bitr(down, fromType="ENTREZID", toType="SYMBOL", OrgDb="org.Hs.eg.db")
nob = bitr(no, fromType="ENTREZID", toType="SYMBOL", OrgDb="org.Hs.eg.db")

noS = nob$SYMBOL
upS = upb$SYMBOL
downS  = downb$SYMBOL
write.csv(noS,file = "no.csv")
write.csv(upS,file = "up.csv")
write.csv(downS,file = "down.csv")

