install.packages("forecast")
install.packages("readxl")
install.packages('openxlsx')

library(forecast)
library(readxl)
library(openxlsx)


dados <- read_excel("pim.xlsx")

dados$Month <- as.Date(dados$Month)
dados <- dados[order(dados$Month),]

if(!dir.exists('amortecomentoExpon')){
  dir.create('amortecomentoExpon')
}

serie <- ts(dados, start = c(2005,1), end = c(2019,12), frequency = 12)

treino <- window(serie, end = c(2018,12))
write.xlsx(treino,'amortecomentoExpon/treino.xlsx')
write.csv(treino,'amortecomentoExpon/treino.csv', row.names = FALSE)

validacao <- window(serie, start = c(2019,1))
write.xlsx(validacao,'amortecomentoExpon/validacao.xlsx')
write.csv(validacao,'amortecomentoExpon/validacao.csv', row.names = FALSE)
fit <- ses(treino[,2], h = 12, alpha = 0.8269)
write.xlsx(fit,'amortecomentoExpon/fit.xlsx')
write.csv(fit,'amortecomentoExpon/fit.csv', row.names = FALSE)

summary(fit)

pdf(file = 'amortecomentoExpon/graficos_previsão_pim.pdf', width = 8, height = 6)

plot(fit, main='Previsões x Valores Observados nos ultimos 12 meses')

lines(validacao[,2], lty=3)

dev.off()



# 
# ''''
# Analise do relatório gerado pelo modelo de suavização exponencial simples (Simple exponential smoothing) para série temporal univariada.
# 
# 1. Método de Previsão
# Forecast method: Simple exponential smoothing (Suavização exponencial simples).
# Este método ajusta previsões baseando-se em uma média ponderada dos valores passados, onde os pesos decrescem exponencialmente à medida que os valores se afastam no tempo.
# 2. Parâmetros do Modelo
# Smoothing parameters:
#   
#   alpha = 0.8269: Este é o parâmetro de suavização, indicando quão rapidamente os efeitos dos valores passados diminuem. Um valor de alfa próximo de 1 significa que as observações mais recentes têm um peso maior nas previsões.
# Initial states:
#   
#   l = 80.5457: Este é o valor inicial estimado da série temporal no modelo. Representa o nível da série temporal no ponto de partida.
# sigma = 6.0893: Este é o desvio padrão do erro de previsão, uma medida da incerteza ou variabilidade nas previsões feitas pelo modelo.
# 
# 3. Critérios de Informação
# AIC (Akaike Information Criterion): 1471.809
# AICc (Akaike Information Criterion corrigido): 1471.955
# BIC (Bayesian Information Criterion): 1481.181
# Esses critérios são usados para avaliar a qualidade do modelo, penalizando o número de parâmetros. Modelos com menores valores de AIC, AICc e BIC são geralmente preferíveis porque indicam um melhor equilíbrio entre ajuste e complexidade.
# 
# 4. Medidas de Erro
# ME (Mean Error): -0.002785871
# Média dos erros de previsão. Um valor próximo de zero é desejável.
# RMSE (Root Mean Square Error): 6.052942
# Raiz do erro quadrático médio, uma métrica que penaliza grandes erros de previsão. Quanto menor, melhor.
# MAE (Mean Absolute Error): 4.817918
# Média dos erros absolutos. Mede o erro médio em termos absolutos.
# MPE (Mean Percentage Error): -0.2547084
# Média dos erros percentuais. Um valor negativo indica que, em média, o modelo tende a subestimar os valores reais.
# MAPE (Mean Absolute Percentage Error): 5.164703
# Média dos erros percentuais absolutos. Um MAPE de 5,16% significa que, em média, as previsões erram por cerca de 5,16% em relação aos valores reais.
# MASE (Mean Absolute Scaled Error): 0.9474288
# Erro absoluto médio escalado. Um valor menor que 1 indica que o modelo é melhor que o modelo de referência de "previsão de ingênuo".
# ACF1: -0.02398243
# Autocorrelação do erro na defasagem 1. Um valor próximo de zero indica que os erros são aproximadamente independentes, o que é uma boa característica para um modelo de previsão.
# 5. Previsões Futuras
# Point Forecast: As previsões pontuais para os próximos 12 períodos (de Jan 2019 a Dez 2019) são constantes em 80.15871, o que é típico para um modelo de suavização exponencial simples quando não há tendência.
# Intervalos de Confiança:
#   Lo 80, Hi 80: Intervalo de confiança de 80%.
# Lo 95, Hi 95: Intervalo de confiança de 95%.
# Esses intervalos mostram a faixa dentro da qual esperamos que os valores reais se situem, com uma certa probabilidade.
# Interpretação Geral
# O modelo ajustado com suavização exponencial simples fornece previsões estáveis (fixas) para os próximos períodos, o que é comum em séries temporais que não apresentam uma tendência clara ou sazonalidade.
# O alto valor de alfa indica que as observações recentes influenciam fortemente as previsões.
# As medidas de erro sugerem que o modelo tem uma boa precisão, com um MAPE de cerca de 5,16%, o que é bastante aceitável na maioria dos contextos.
# 
# '''''
