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

korelacija<-left_join(regres, zanima1)
koeficjent<-cor(korelacija$Koeficient, korelacija$`GDP pc`)

koncno<-left_join(evropa, ledux, by=c("SOVEREIGNT" = "Drzava"))
koncno$`Uporaba interneta`<-as.character(koncno$`Uporaba interneta`)
koncno$`Uporaba interneta`<-as.numeric(koncno$`Uporaba interneta`)
tess<-left_join(koncno, korelacija, by=c("SOVEREIGNT" = "Drzava"))

koncno<-left_join(evropa, ledux, by=c("SOVEREIGNT" = "Drzava"))
koncno$`Uporaba interneta`<-as.character(koncno$`Uporaba interneta`)
koncno$`Uporaba interneta`<-as.numeric(koncno$`Uporaba interneta`)
#zem <- ggplot() + geom_polygon(data = koncno ,aes(x = long, y = lat, group = group), fill=koncno$`Uporaba interneta`) +coord_map(xlim = c(-25, 40), ylim = c(32, 72)) + scale_fill_identity(na.value = "white")
