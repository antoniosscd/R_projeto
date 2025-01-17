install.packages("dygraphs")  
install.packages('readxl')    
install.packages('openxlsx') 
install.packages('ggplot2')
install.packages('gridExtra')

library(gridExtra)
library(openxlsx)
library(readxl)
library(dygraphs)
library(ggplot2)
library(grid)

dados <- read_excel('pim.xlsx')

head(dados)
tail(dados)

dados$Month <- as.Date(dados$Month)
dados <- dados[order(dados$Month),]

head(dados)
tail(dados)

serie <- ts(dados$Value, start = c(2005,1), end = c(2019,12), frequency = 12)

serie

decomp_stl <- stl(serie, s.window = "periodic")

plot(decomp_stl)

if(!dir.exists('decomposicao')){
  dir.create('decomposicao')
}

df_serie <- data.frame(Month = as.yearmon(time(serie)),
                       Value = as.numeric(serie))
df_serie


td_serie <- createWorkbook()

addWorksheet(td_serie, 'decomp_stl')

writeDataTable(td_serie, sheet = 'decomp_stl',x = df_serie, 
               tableStyle = 'TableStyleMedium2')
saveWorkbook(td_serie, 'decomposicao/td_serie.xlsx', overwrite = TRUE)

df <- data.frame(
  Date = time(serie),
  Tendencia = decomp_stl$time.series[,'trend'],
  Sazonalidade = decomp_stl$time.series[,'seasonal'],
  Residuos = decomp_stl$time.series[,'remainder']
)

head(df)

df$Date <- as.yearmon(df$Date)

decomposicao <- createWorkbook()
addWorksheet(decomposicao, 'decomp_stl')
writeDataTable(decomposicao, sheet = 'decomp_stl',x = df)
saveWorkbook(decomposicao, 'decomposicao/decomposicao.xlsx', overwrite = TRUE)


pdf(file = "decomposicao/graficos_pim.pdf", width = 8, height = 6)


ggplot(dados, aes(x = Month, y = Value)) + 
  geom_line(color = 'blue') +
  labs(title = 'Grafico Original da Serie pim',
       x = 'Mes',
       y = 'Valor')

plot(decomp_stl, main = 'Decomposição da Serie pim')

dev.off()
