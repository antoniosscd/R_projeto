
library(readxl) 
library(dplyr)

dados <- read_excel('pim.xlsx') 

str(dados) 

if(!dir.exists('sumario')){
  dir.create('sumario')
}

dados <- dados %>%
  mutate(Month_num = as.numeric(format(Month, "%Y")) * 12 + as.numeric(format(Month, "%m"))) 

model <- lm(Value ~ Month_num, data = dados)  

# Salvando os coeficientes do modelo em um arquivo CSV
coef_df <- as.data.frame(t(model$coefficients))
write.csv(coef_df, file = "sumario/coeficientes.csv", row.names = FALSE)

# Salvando os resíduos do modelo em um arquivo CSV
resid_df <- as.data.frame(model$residuals)
write.csv(resid_df, file = "sumario/residuos.csv", row.names = FALSE)

# Salvando o resumo do modelo em um arquivo de texto
summary_text <- capture.output(summary(model))
writeLines(summary_text, con = "sumario/resumo_modelo.txt")

