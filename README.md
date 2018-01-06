# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Tematika
Pri predmetu Analiza podatkov s programom R bom analiziral uporabo interneta v Evropski uniji. Zanimalo me bo, katere države uporabljajo internet največ, na kakšen način in poskušal najti povezave med podatki. Moja hipoteza je, da bolj razvite države uporabljajo internet več, tako v splošnem, kot še posebej za socialna omrežja in nakupe dobrin. Zato bom uvozil tudi podatke o BDP na prebivalca evropskih držav.

Podatke za prvi 2 tabeli bom v csv obliki prenesel iz Eurostata:
Podatki v tidy data:
1. tabela: delež uporabnikov 
stolpci: država EU, leto, vrsta uporabe (doma, WI-FI), delež

2. tabela: nakupi
stolpci: država EU, leto, doma ali v tujini, delež

3. tabela: število uporabnikov Facebooka
stolpci: država EU, število uporabnikov Facebooka

4. tabela: razvitost držav
stolpci: država EU, število prebivalcev, BDP na prebivalca

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `reshape` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
