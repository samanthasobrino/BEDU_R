#### Postwork 4 ####

# LIBRERIAS
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(ggplot2)))
suppressWarnings(suppressMessages(library(reshape2)))
suppressWarnings(suppressMessages(library(boot)))

# Cargamos los datos ####
link1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
data_1718 <- read.csv(file = link1718)
link1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
data_1819 <- read.csv(file = link1819)
link1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
data_1920 <- read.csv(file = link1920)

# Exploracion de los datos ####
str(data_1718); head(data_1718); View(data_1718); summary(data_1718)
str(data_1819); head(data_1819); View(data_1819); summary(data_1819)
str(data_1920); head(data_1920); View(data_1920); summary(data_1920)

# Creación del dataframe ####
list <- list(data_1718, data_1819, data_1920)
datasets <- lapply(list, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)
datasets[[1]] <- mutate(datasets[[1]], Date = as.Date(Date, "%d/%m/%y"))
datasets[[2]] <- mutate(datasets[[2]], Date = as.Date(Date, "%d/%m/%Y"))
datasets[[3]] <- mutate(datasets[[3]], Date = as.Date(Date, "%d/%m/%Y"))
data <- do.call(rbind, datasets)
str(data)
summary(data)

# Cálculo de probabilidades ####
#La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)
pr_casa <- round(table(data$FTHG)/dim(data)[1], 4)
#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)
pr_visitante <- round(table(data$FTAG)/dim(data)[1], 4)
#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)
pr_conj <- round(table(data$FTHG, data$FTAG)/dim(data)[1], 4)


# 1. Tabla de Cocientes ####
cocientes <- pr_conj/outer(pr_casa, pr_visitante, "*")

# 2. Procedimiento de boostrap ####
set.seed(123)
indices <- sample(dim(data)[1], size = 380, replace = TRUE) # tamaño = 380 igual que los datos anuales
nuevosdatos <- data[indices, ]

# Estimaciones de las probabilidades

# Marginales casa
pcasa <- round(table(nuevosdatos$FTHG)/dim(nuevosdatos)[1], 4)
# Marginales visitante
pvisita <- round(table(nuevosdatos$FTAG)/dim(nuevosdatos)[1], 4)
# Conjuntas
pcta <- round(table(nuevosdatos$FTHG, nuevosdatos$FTAG)/dim(nuevosdatos)[1], 4)

#Cocientes
cocientes <- pcta/outer(pcasa, pvisita, "*")

arreglo <- as.vector(cocientes)
boot.f <- function(datos, indice){
  mean(datos[indice])
}

stat.boot <- boot(arreglo,boot.f, 10000)

p <- ggplot() +
  geom_histogram(aes(stat.boot$t), bins = 50, col="violetred", fill = "aquamarine") +
  ggtitle("Remuestreo con Bootstrap") +
  ylab("Frecuencia") +
  geom_vline(xintercept =  mean(na.omit(stat.boot$t)), col = "red", lwd = 1.5, lty =2)
p

### Observamos que la mayoría de los cocientes son distinto de uno es decir que sí depende el número de goles
# que anote el otro equipo sobre el número que anota el equipo.