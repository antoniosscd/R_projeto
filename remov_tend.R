install.packages('readxl')
install.packages('dplyr')
install.packages('openxlsx')


library(readxl) 
library(dplyr)
library(openxlsx)

dados <- read_excel("pim.xlsx")


dados = dados %>%
  mutate(Month_num = as.numeric(format(Month, '%Y')) * 12 + as.numeric(format(Month, '%m')))


model <- lm(Value ~ Month_num, data = dados)


dados = dados %>%
  mutate(Tendencia = predict(model)) %>%  
  mutate(Value_detrended = Value - Tendencia)


head(dados)

if(!dir.exists('tendencia')){
  dir.create('tendencia')
}

write.csv(dados, 'tendencia/pim_sem_tendencia.csv', row.names = FALSE)
write.xlsx(dados, 'tendencia/pim_sem_tendencia.xlsx')


pdf(file = 'tendencia/grafico-ten.pdf', width = 8, height = 6)

plot(dados$Month, dados$Value,
     type = 'l',
     col = 'blue',
     main = "Série Temporal com e Sem Tendência",
     xlab = "Mês",
     ylab = "Valor",
     ylim = c(min(dados$Value_detrended, na.rm = TRUE), 
              max(dados$Value, na.rm = TRUE)))


lines(dados$Month, dados$Tendencia,
      col = 'red')


lines(dados$Month, dados$Value_detrended,
      col = 'green')


legend('topright',
       legend = c('Original', 'Tendência', 'Sem Tendência'),
       col = c('blue', 'red', 'green'),       
       lty = 1)

dev.off()
