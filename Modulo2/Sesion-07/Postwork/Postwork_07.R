#### Postwork 7 ####

#DIRECTORIO
setwd("C:/Users/saman/Documents/Sami/BEDU/R/Sesion-07/Postwork")

# LIBRERIAS
suppressWarnings(suppressMessages(library(mongolite)))

# Carga de datos
data <-data.table::fread("data.csv")
names(data)
head(data)
data <- data[,-1]
names(data)


# 1. Alojar el fichero data.csv en una base de datos llamada match_games, nombrando al collection como match ####
db <- mongo(
  collection = "match",
  db = "match_games",
  url = "mongodb+srv://sam_sobrino:DPJMinS_987@clusterbedu.p2vjo.mongodb.net/test?readPreference=primary&ssl=true"
)

db$insert(data)

# 2. Una vez hecho esto, realizar un count para conocer el número de registros que se tiene en la base ####
db$count()  #1140 

# 3. Realiza una consulta utilizando la sintaxis de Mongodb, en la base de datos para conocer el número de goles que metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió ó fue goleada? ####
db$find('{"Date": "2015-12-20"}')
db$find('{"HomeTeam": "Real Madrid"}')
# Ya que no existe esa fecha en el archivo, se tomara la fecha 22 de Diciembre 
# de 2019 que es lo mas cercano a 20 de diciembre
db$find('{"Date": "2019-12-22", "HomeTeam": "Real Madrid"}')
#        Date     HomeTeam    AwayTeam FTHG FTAG FTR
#  2019-12-22  Real Madrid  Ath Bilbao    0    0   D
#  El resultado es un empate


# 4. Agrega el dataset de mtcars a la misma BDD. Por último, no olvides cerrar la conexión con la BDD ####
db$insert(mtcars)
db$count()
db$drop()
db$disconnect()
