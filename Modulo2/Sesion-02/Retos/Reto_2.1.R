### Reto 1. ###

# Considere el siguiente vector

set.seed(134)

x <- round(rnorm(1000, 175, 6), 1)

library(DescTools)

# 1. Calcule, la media, mediana y moda de los valores en x
mean(x)
median(x)
Mode(x)

# 2. Obtenga los deciles de los numeros en x
quantile(x, probs = seq(0.1, 0.9, 0.1))

# 3. Encuentre la rango intercuartalico, la desviacion estandar y varianza muestral
IQR(x)
sd(x)
var(x)
