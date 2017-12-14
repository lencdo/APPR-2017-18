# 2. faza: uvoz podatkov
tabela1<-read.csv("goods.csv",header=FALSE,encoding="Windows-1250",skip=2, nrows=43)
ha<-select(tabela1, 1, seq(from=2, to=24, by=2))
ha<-ha[-c(1, 2, 3, 4, 5, 6, 41),]
colnames(ha)<-c("Drzava", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
ha<-melt(ha,id=c("Drzava"))
ha<-ha[order(ha$Drzava),]
colnames(ha)<-c("Drzava", "Leto", "Kupovanje")

#urejene tabele imajo imena "ha", "ha1", "uporaba", "wifi" in "zanima"
tabela2<-read.csv("goods_tuj.csv", header=FALSE, encoding="Windows-1250", skip=3, nrows=42)
ha1<-select(tabela2, 1, seq(from=2, to=18, by=2))
colnames(ha1)<-c("Drzava", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
ha1<-ha1[-c(1, 2, 3, 4, 5, 40),]
ha1<-melt(ha1,id=c("Drzava"))
ha1<-ha1[order(ha1$Drzava),]
colnames(ha1)<-c("Drzava", "Leto", "Kupovanje-tujina")

tabela3<-read.csv("int_use.csv", header=FALSE, encoding="Windows-1250", skip=8, nrows=37)
uporaba<-select(tabela3, 1, seq(from=2, to=24, by=2))
colnames(uporaba)<-c("Drzava", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
uporaba<-uporaba[-c(35),]
uporaba<-melt(uporaba,id=c("Drzava"))
uporaba<-uporaba[order(uporaba$Drzava),]
colnames(uporaba)<-c("Drzava", "Leto", "Uporaba interneta")

tabela4<-read.csv("wifi.csv", header=FALSE, encoding="Windows-1250", skip=1, nrows=44)
wifi<-select(tabela3, 1, seq(from=2, to=10, by=2))
wifi<-wifi[-c(35),]
colnames(wifi)<-c("Drzava", "2012", "2013", "2014", "2015", "2016")
wifi<-melt(wifi,id=c("Drzava"))
wifi<-wifi[order(wifi$Drzava),]
colnames(wifi)<-c("Drzava", "Leto", "Uporaba WIFI")

scotusURL <- "https://en.wikipedia.org/wiki/List_of_European_countries_by_population"
temp <- scotusURL %>% html %>% html_nodes("table")
tabela5<-(html_table(temp[2], fill=TRUE))
tabela5<-as.data.frame(tabela5)
zanima<-select(tabela5, 2, 8)
colnames(zanima)<-c("Drzava", "st. prebivalcev")
