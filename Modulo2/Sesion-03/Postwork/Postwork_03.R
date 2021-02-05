#### Postwork 3 ####

# LIBRERIAS
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(ggplot2)))
suppressWarnings(suppressMessages(library(reshape2)))

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

# Creacion del dataframe ####
list <- list(data_1718, data_1819, data_1920)
datasets <- lapply(list, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)
datasets[[1]] <- mutate(datasets[[1]], Date = as.Date(Date, "%d/%m/%y"))
datasets[[2]] <- mutate(datasets[[2]], Date = as.Date(Date, "%d/%m/%Y"))
datasets[[3]] <- mutate(datasets[[3]], Date = as.Date(Date, "%d/%m/%Y"))

data <- do.call(rbind, datasets)
str(data)
summary(data)

# 1. Elabora tablas de frecuencias relativas para estimar las siguientes probabilidades ####

  #La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)
(pr_casa <- round(table(data$FTHG)/dim(data)[1], 4))

  #La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)
(pr_visitante <- round(table(data$FTAG)/dim(data)[1], 4))

  #La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)
(pr_conj <- round(table(data$FTHG, data$FTAG)/dim(data)[1], 4))

# 2. GRÁFICAS ####
#Formatos
pr_casa <- as.data.frame(pr_casa)
str(pr_casa)
pr_casa <- pr_casa %>% rename(NumGoles = Var1, FreqRel = Freq)

pr_visitante <- as.data.frame(pr_visitante)
pr_visitante <- rename(pr_visitante, NumGoles = Var1, FreqRel = Freq)

# De barras de probabilidades marginales del num de goles que anota el equipo de casa
barrascasa <- ggplot(pr_casa, aes(x = NumGoles, y = FreqRel)) + 
  geom_bar (stat="identity", fill = 'steelblue') +
  ggtitle('Equipo de casa')
barrascasa

# De barras de probabilidades marginales del num de goles que anota el equipo visitante
barrasvis <- ggplot(pr_visitante, aes(x = NumGoles, y = FreqRel)) + 
  geom_bar (stat="identity", fill = 'palevioletred4') +
  ggtitle('Equipo visitante')
barrasvis

# HeatMap para las probabilidades conjuntas estimadas
pr_conj <- melt(pr_conj)
pr_conj <- rename(pr_conj, GolesCasa = Var1, GolesVisita = Var2, ProbEst = value)
pr_conj %>% ggplot(aes(GolesCasa, GolesVisita)) + 
  geom_tile(aes(fill = ProbEst)) + 
  ggtitle('Probabilidades conjuntas estimadas') +
  scale_fill_gradient(low = 'darkgoldenrod2', high = 'mediumorchid4') + 
  theme(axis.text.x = element_text(angle = 90, hjust = 0))

