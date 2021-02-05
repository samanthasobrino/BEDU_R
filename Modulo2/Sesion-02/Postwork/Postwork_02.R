#### Postwork 2 ####
suppressWarnings(suppressMessages(library(dplyr)))

# 1. Importa los datos de soccer de las temporadas 2017/2018, 2018/2019 y 2019/2020 de la primera división de la liga española ####
link1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"
data_1718 <- read.csv(file = link1718)

link1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
data_1819 <- read.csv(file = link1819)

link1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
data_1920 <- read.csv(file = link1920)

# 2. Obten una mejor idea de las características de los data frames al usar las funciones: str, head, View y summary####
str(data_1718); head(data_1718); View(data_1718); summary(data_1718)
str(data_1819); head(data_1819); View(data_1819); summary(data_1819)
str(data_1920); head(data_1920); View(data_1920); summary(data_1920)

# 3. Con la función select del paquete dplyr selecciona únicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR ####
list <- list(data_1718, data_1819, data_1920)
datasets <- lapply(list, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

# 4. Asegúrate de que los elementos de las columnas correspondientes de los nuevos data frames sean del mismo tipo ####
datasets[[1]] <- mutate(datasets[[1]], Date = as.Date(Date, "%d/%m/%y"))
datasets[[2]] <- mutate(datasets[[2]], Date = as.Date(Date, "%d/%m/%Y"))
datasets[[3]] <- mutate(datasets[[3]], Date = as.Date(Date, "%d/%m/%Y"))

# Con ayuda de la función rbind forma un único data frame que contenga las seis columnas mencionadas en el punto 3
data <- do.call(rbind, datasets)
dim(data)
View(data)
str(data)
summary(data)
