
install.packages("dygraphs")  
install.packages('readxl')    
install.packages('openxlsx') 

library(dygraphs)


serie <- read.table("clipboard")  
serie <- ts(serie, start = c(2005,1), end = c(2019,12), frequency = 12)
serie 


if(!dir.create('multv_aditv')){
  dir.create('multv_aditv')
}

write.xlsx(serie,'multv_aditv/serie.xlsx')


pdf(file = 'multv_aditv/grafico_modeloMultAdit_pim.pdf', width = 8, height = 6)

decomp.ad = decompose(serie) 
decomp.mult = decompose(serie, type = "multiplicative")


par(cex.main = 1)
par(cex.lab = 0.5, cex.axis = 0.5)

plot(decomp.ad)
plot(decomp.mult)

dev.off()


library(readxl)

serie <- read_excel('pim.xlsx')  
serie <- ts(serie, start = c(2005,1), end = c(2019,12), frequency = 12)  

serie


if(!dir.create('multv_aditv')){
  dir.create('multv_aditv')
}

write.xlsx(serie,'multv_aditv/serie.xlsx')


pdf(file = 'multv_aditv/grafico_modeloMultAdit_pim.pdf', width = 8, height = 6)

decomp.ad = decompose(serie) 
decomp.mult = decompose(serie, type = "multiplicative")


par(cex.main = 1)
par(cex.lab = 0.5, cex.axis = 0.5)

plot(decomp.ad)
plot(decomp.mult)

dev.off()



library(openxlsx)


serie <- read.xlsx('pim.xlsx', sheet = 1) 
serie <- ts(serie, start = c(2005,1), end = c(2019,12), frequency = 12)  
serie

if(!dir.create('multv_aditv')){
  dir.create('multv_aditv')
}

write.xlsx(serie,'multv_aditv/serie.xlsx')


pdf(file = 'multv_aditv/grafico_modeloMultAdit_pim.pdf', width = 8, height = 6)

decomp.ad = decompose(serie) 
decomp.mult = decompose(serie, type = "multiplicative")


par(cex.main = 1)
par(cex.lab = 0.5, cex.axis = 0.5)

plot(decomp.ad)
plot(decomp.mult)

dev.off()
