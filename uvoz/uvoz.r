#smo brez liechtensteina, albanije, rvest, reshape, dplyr, gridEXTRA, ggplot2
# 2. faza: uvoz podatkov
tabela1<-read.csv("podatki/goods.csv",header=FALSE,encoding="Windows-1250",skip=2, nrows=43)
kupovanje<-select(tabela1, 1, seq(from=2, to=24, by=2))
kupovanje<-kupovanje[-c(1, 2, 3, 4, 5, 6, 36, 41),]
colnames(kupovanje)<-c("Drzava", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
kupovanje$Drzava<-as.character(kupovanje$Drzava)
kupovanje$Drzava[kupovanje$Drzava=="Former Yugoslav Republic of Macedonia, the"]<-"Macedonia"
kupovanje<-melt(kupovanje,id=c("Drzava"))
kupovanje<-kupovanje[order(kupovanje$Drzava),]
colnames(kupovanje)<-c("Drzava", "Leto", "Kupovanje")

#urejene tabele imajo imena "ha", "ha1", "uporaba", "wifi" in "zanima"
tabela2<-read.csv("podatki/goods_tuj.csv", header=FALSE, encoding="Windows-1250", skip=3, nrows=42)
kupovanjeT<-select(tabela2, 1, seq(from=2, to=18, by=2))
colnames(kupovanjeT)<-c("Drzava", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016")
kupovanjeT<-kupovanjeT[-c(1, 2, 3, 4, 5, 35, 40),]
kupovanjeT<-melt(kupovanjeT,id=c("Drzava"))
kupovanjeT<-kupovanjeT[order(kupovanjeT$Drzava),]
kupovanjeT$Drzava<-as.character(kupovanjeT$Drzava)
kupovanjeT$Drzava[kupovanjeT$Drzava=="Former Yugoslav Republic of Macedonia, the "]<-"Macedonia"
colnames(kupovanjeT)<-c("Drzava", "Leto", "Kupovanje-tujina")

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

scotusURL2 <- "https://en.wikipedia.org/wiki/List_of_sovereign_states_in_Europe_by_GDP_(nominal)_per_capita"
temp2 <- scotusURL2 %>% html %>% html_nodes("table")
tabela6<-(html_table(temp2[1], fill=TRUE))
tabela6<-as.data.frame(tabela6)
zanima1<-select(tabela6, 1, 3)
colnames(zanima1)<-c("Drzava", "GDP pc")
zanima1$Drzava<-as.character(zanima1$Drzava)
zanima1$`GDP pc`<-as.numeric(gsub(",", ".", zanima1$`GDP pc`))

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
skupnoEU<-as.data.frame(novvek(se, 6))
idemowifi<-as.data.frame(novvek(se, 7))
colnames(skupnoEU)<-c("leto", "stevilo uporabnikov")
colnames(idemowifi)<-c("leto", "stevilo uporabnikovwifi")
ide<-left_join(skupnoEU, idemowifi, by="leto")
ide<-ide*100
ide$leto<-ide$leto/100
luxemburg<-subset(se, se$Drzava=="Luxembourg")
luxemburg<-select(luxemburg, 2, 3, 4)

turcija<-subset(se, se$Drzava=="Turkey")
turcija<-select(turcija, 2, 3, 4)
slovaska<-subset(se, se$Drzava=="Slovakia")
slovaska<-select(slovaska, 2, 3, 4)

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

spremen<-function(vektor){
  out<-as.character(vektor)
  out<-as.numeric(vektor)
  return(out)
}


regres<-regresija(se)

ledux<-subset(uporaba, uporaba$Leto==2016) %>% select(1,3)
ledux2<-subset(kupovanje, kupovanje$Leto==2016) %>% select(1,3)
ledux3<-subset(kupovanjeT, kupovanjeT$Leto==2016) %>% select(1,3)
rezultati<-inner_join(ledux, ledux2,by="Drzava") %>% inner_join(ledux3, by="Drzava")%>% 
  inner_join(regres, by="Drzava") %>% inner_join(zanima, by="Drzava") %>% inner_join(zanima1, by="Drzava")
rezultati<-subset(rezultati, rezultati$Drzava!="Iceland")%>% select(2, 3, 4, 5, 6, 7)
rezultati$`Uporaba interneta`<-as.character(rezultati$`Uporaba interneta`)
rezultati$`Uporaba interneta`<-as.numeric(rezultati$`Uporaba interneta`)
rezultati$`Kupovanje`<-as.character(rezultati$`Kupovanje`)
rezultati$`Kupovanje`<-as.numeric(rezultati$`Kupovanje`)
rezultati$`Kupovanje-tujina`<-as.character(rezultati$`Kupovanje-tujina`)
rezultati$`Kupovanje-tujina`<-as.numeric(rezultati$`Kupovanje-tujina`)
rezultati$`st. prebivalcev`<-as.numeric(rezultati$`st. prebivalcev`)
cor(rezultati)

korelacija<-left_join(regres, zanima1, by="Drzava")
koeficjent<-cor(korelacija$Koeficient, korelacija$`GDP pc`)
#grid.arrange(graf1, graf2, graf3, graf4)
