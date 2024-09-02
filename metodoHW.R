install.packages("forecast")
install.packages("readxl")
install.packages('openxlsx')

library(forecast)
library(readxl)
library(openxlsx)


dados <- read_excel('pim.xlsx')

dados$Month <- as.Date(dados$Month)
dados <- dados[order(dados$Month),]

head(dados)
tail(dados)

serie <- ts(dados$Value, start = c(2005,1), end = c(2019, 12), frequency = 12)


treino <- window(serie, end = c(2018,12))
treino <- ts(treino, frequency = 12)
validacao <- window(serie, start = c(2019, 1))

fit <- hw(treino, h=12)

summary(fit)

plot(fit,main= "Previsões x Valores Observados nos Últimos 12 Meses")

lines(validacao,lty=3)