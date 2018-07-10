# 3. faza: Vizualizacija podatkov

# Uvozimo zemljevid.
#uvozimo <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
#                          "ne_50m_admin_0_countries", 
#                          encoding = "UTF-8")
#evropa<-pretvori.zemljevid(uvozimo)
uvozimo <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                           "ne_50m_admin_0_countries", 
                           encoding = "UTF-8")
evropa<-pretvori.zemljevid(uvozimo)

regresijski_koef<-left_join(regres, zanima1)
#koeficjent<-cor(korelacija$Koeficient, regresijski_koef$`GDP pc`)

koncno<-left_join(evropa, ledux, by=c("SOVEREIGNT" = "Drzava"))
koncno$`Uporaba interneta`<-as.character(koncno$`Uporaba interneta`)
koncno$`Uporaba interneta`<-as.numeric(koncno$`Uporaba interneta`)
tess<-left_join(koncno, regresijski_koef, by=c("SOVEREIGNT" = "Drzava"))

grupiranje<-rezultati[-c(1, 6)]
grupe<-kmeans(grupiranje, 5)
rezultati$grupe<-grupe$cluster
pogrupah<-left_join(evropa, select(rezultati, c(1,8)), by=c("SOVEREIGNT" = "Drzava"))

luk<-subset(kupovanje, kupovanje$Drzava=="Luxembourg") %>% select(c(2,3))
wuk<-subset(uporaba, uporaba$Drzava=="Luxembourg" )%>% select(c(2,3))
puk<-subset(kupovanjeT, kupovanjeT$Drzava=="Luxembourg") %>% select(c(2,3))
luks<-inner_join(luk, puk,by="Leto") %>% inner_join(wuk, by="Leto")
luks$`Kupovanje-tujina`<-as.character(luks$`Kupovanje-tujina`)
luks$`Kupovanje-tujina`<-as.numeric(luks$`Kupovanje-tujina`)
luks$Kupovanje<-as.character(luks$Kupovanje)
luks$Kupovanje<-as.numeric(luks$Kupovanje)
luks$Leto<-as.numeric(luks$Leto)
luks$`Uporaba interneta`<-as.character(luks$`Uporaba interneta`)
luks$`Uporaba interneta`<-as.numeric(luks$`Uporaba interneta`)

