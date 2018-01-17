#smo brez liechtensteina, albanije, rvest, reshape, dplyr, gridEXTRA, ggplot2
# 2. faza: uvoz podatkov
tabela1<-read.csv("podatki/goods.csv",header=FALSE,encoding="Windows-1250",skip=2, nrows=43)
ha<-select(tabela1, 1, seq(from=2, to=24, by=2))
ha<-ha[-c(1, 2, 3, 4, 5, 6, 36, 41),]
colnames(ha)<-c("Drzava", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
ha$Drzava<-as.character(ha$Drzava)
ha$Drzava[ha$Drzava=="Former Yugoslav Republic of Macedonia, the"]<-"Macedonia"
ha<-melt(ha,id=c("Drzava"))
ha<-ha[order(ha$Drzava),]
colnames(ha)<-c("Drzava", "Leto", "Kupovanje")

#urejene tabele imajo imena "ha", "ha1", "uporaba", "wifi" in "zanima"
tabela2<-read.csv("podatki/goods_tuj.csv", header=FALSE, encoding="Windows-1250", skip=3, nrows=42)
ha1<-select(tabela2, 1, seq(from=2, to=18, by=2))
colnames(ha1)<-c("Drzava", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
ha1<-ha1[-c(1, 2, 3, 4, 5, 35, 40),]
ha1<-melt(ha1,id=c("Drzava"))
ha1<-ha1[order(ha1$Drzava),]
ha1$Drzava<-as.character(ha1$Drzava)
ha1$Drzava[ha1$Drzava=="Former Yugoslav Republic of Macedonia, the "]<-"Macedonia"
colnames(ha1)<-c("Drzava", "Leto", "Kupovanje-tujina")

tabela3<-read.csv("podatki/int_use.csv", header=FALSE, encoding="Windows-1250", skip=8, nrows=37)
uporaba<-select(tabela3, 1, seq(from=2, to=24, by=2))
colnames(uporaba)<-c("Drzava", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
uporaba<-uporaba[-c(30, 35),]
uporaba<-melt(uporaba,id=c("Drzava"))
uporaba<-uporaba[order(uporaba$Drzava),]
uporaba$Drzava<-as.character(uporaba$Drzava)
uporaba$Drzava[uporaba$Drzava=="Former Yugoslav Republic of Macedonia, the"]<-"Macedonia"
colnames(uporaba)<-c("Drzava", "Leto", "Uporaba interneta")

tabela4<-read.csv("podatki/wifi.csv", header=FALSE, encoding="Windows-1250", skip=1, nrows=44)
wifi<-select(tabela3, 1, seq(from=2, to=10, by=2))
wifi<-wifi[-c(30, 35),]
colnames(wifi)<-c("Drzava", "2012", "2013", "2014", "2015", "2016")
wifi<-melt(wifi,id=c("Drzava"))
wifi<-wifi[order(wifi$Drzava),]
wifi$Drzava<-as.character(wifi$Drzava)
wifi$Drzava[wifi$Drzava=="Former Yugoslav Republic of Macedonia, the"]<-"Macedonia"
colnames(wifi)<-c("Drzava", "Leto", "Uporaba WIFI")

scotusURL <- "https://en.wikipedia.org/wiki/List_of_European_countries_by_population"
temp <- scotusURL %>% html %>% html_nodes("table")
tabela5<-(html_table(temp[2], fill=TRUE))
tabela5<-as.data.frame(tabela5)
zanima<-select(tabela5, 2, 8)
colnames(zanima)<-c("Drzava", "st. prebivalcev")
zanima$Drzava[zanima$Drzava=="France[7][Note 1]"]<-"France"
zanima$Drzava<-as.character(zanima$Drzava)
zanima$`st. prebivalcev`<-as.integer(gsub(",", "", zanima$`st. prebivalcev`))

# poglejmo kaj se dogaja pri uporabi, zanima nas od wifi dalje
nova<-left_join(uporaba, wifi)
nova<-subset(nova, nova$Leto>=2012)
se<-left_join(nova, zanima, by="Drzava")
se<-subset(se, se$`Uporaba interneta`!=":" & se$`Uporaba WIFI`!=":")
se$`Uporaba interneta`<-as.character(se$`Uporaba interneta`)
se$`Uporaba interneta`<-as.integer(se$`Uporaba interneta`)
se$`Uporaba WIFI`<-as.character(se$`Uporaba WIFI`)
se$`Uporaba WIFI`<-as.integer(se$`Uporaba WIFI`)
se$"skupaj"<-(se$`Uporaba interneta`/100)*se$`st. prebivalcev`
se$"skupajwifi"<-(se$`Uporaba WIFI`/100)*se$`st. prebivalcev`
se$Leto<-as.numeric(se$Leto)

novvek<-function(se, stolp){
  matrika<-matrix(nrow=5, ncol=2)
  for(i in 2012:2016){
    matrika[i-2011, 1]<-i
    matrika[i-2011, 2]<-sum(subset(se, se[2]==i)[stolp])/sum(subset(se, se[2]==i)[5])
  }
  return(matrika)
}
idemo<-as.data.frame(novvek(se, 6))
idemowifi<-as.data.frame(novvek(se, 7))
colnames(idemo)<-c("leto", "stevilo uporabnikov")
colnames(idemowifi)<-c("leto", "stevilo uporabnikovwifi")
ide<-left_join(idemo, idemowifi, by="leto")
ide<-ide*100
ide$leto<-ide$leto/100
luxemburg<-subset(se, se$Drzava=="Luxembourg")
luxemburg<-select(luxemburg, 2, 3, 4)

turcija<-subset(se, se$Drzava=="Turkey")
turcija<-select(turcija, 2, 3, 4)
slovaska<-subset(se, se$Drzava=="Slovakia")
slovaska<-select(slovaska, 2, 3, 4)
turcija<-select(slovaska, 2, 3, 4)

graf1<-ggplot()+geom_line(data=ide, aes(x=ide$leto, y=ide$`stevilo uporabnikov`, group=1), colour="red")+geom_line(data=ide, aes(x=ide$leto, y=ide$`stevilo uporabnikovwifi`, group=1), colour="blue")+
  ggtitle("Drzave EU skupaj")+labs(x="Leto", y="Delez uporabnikov v %")+coord_cartesian(ylim = c(0, 100))+geom_text(aes(82, x=2015), label="INTERNET", colour="red")+geom_text(aes(y=50, x=2015), label="WIFI", colour="blue")
graf4<-ggplot()+geom_line(data=slovaska, aes(x=slovaska$Leto, y=slovaska$`Uporaba interneta`, group=1), colour="red")+geom_line(data=slovaska, aes(x=slovaska$Leto, y=slovaska$`Uporaba WIFI`, group=1), colour="blue")+
  ggtitle("Slovaska")+labs(x="Leto", y="Delez uporabnikov v %")+coord_cartesian(ylim = c(0, 100)) 
graf3<-ggplot()+geom_line(data=turcija, aes(x=turcija$Leto, y=turcija$`Uporaba interneta`, group=1), colour="red")+geom_line(data=turcija, aes(x=turcija$Leto, y=turcija$`Uporaba WIFI`, group=1), colour="blue")+
  ggtitle("Turcija")+labs(x="Leto", y="Delez uporabnikov v %")+coord_cartesian(ylim = c(0, 100)) 
graf2<-ggplot()+geom_line(data=luxemburg, aes(x=luxemburg$Leto, y=luxemburg$`Uporaba interneta`, group=1), colour="red")+geom_line(data=luxemburg, aes(x=luxemburg$Leto, y=luxemburg$`Uporaba WIFI`, group=1), colour="blue")+
  ggtitle("Luksemburg")+labs(x="Leto", y="Delez uporabnikov v %")+coord_cartesian(ylim = c(0, 100)) 

regresija<-function(tabela){
  lel<-unique(tabela$"Drzava")
  kek<-rep(NA, length(lel))
  for(i in 1:length(lel)){
    vnos<-lm(`Uporaba interneta` ~ Leto , data=tabela, subset=(tabela$"Drzava"==lel[i]))
    kek[i]<-coef(vnos)[2]
  }
  rezultat<-data.frame(lel, kek)
  colnames(rezultat)<-c("Drzava", "Koeficient")
  return(rezultat)
}

regres<-regresija(se)
#grid.arrange(graf1, graf2, graf3, graf4)
