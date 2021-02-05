#### POSTWORK SESION 1 ####

# Cambio del directorio de trabajo

setwd("C:/Users/saman/Documents/Sami/BEDU/R/Sesion-01")

# Carga de la base de datos

S19.20_PD <- read.csv("Data/SP1.csv") # El archivo csv debe estar en el directorio de trabajo
str(S19.20_PD)

# Número de goles anotados por los equipos que jugaron en casa (FTHG) y
# Goles anotados por los equipos que jugaron como visitante (FTAG)

casayvisitante <- S19.20_PD[,c(2, 4:7)] # Incluimos tambien la fecha y nombre de los equipos

?table

# La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)
casa <- table(casayvisitante$HomeTeam,casayvisitante$FTHG)
pr_casa <- prop.table(casa)
(goles_casa <- margin.table(pr_casa,2))

# La probabilidad (marginal) de que el equipo que juega en casa anote y goles (y = 0, 1, 2, ...)
visitante <- table(casayvisitante$AwayTeam, casayvisitante$FTAG)
pr_visitante <- prop.table(visitante)
(goles_visitante <- margin.table(pr_visitante,2))

# La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y
# el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)
##Son eventos independientes por lo que su probailidad conjunta es la multiplicación de ambas
(conjunta <- as.matrix(goles_casa)%*%t(as.matrix(goles_visitante)))

