
library(tidyverse)

# * read_csv()  ","
# * read_csv2() ";"
# * read_tsv()  "\t"
# * read_delim(delim = '\n')

# * read_fwf()
  # * fwf_widths()
  # * fwf_positions()
# * read_table()

# * read_log()
# install.packages('webreadr')


write.csv(mtcars, file = "scripts/data/cars.csv")

cars <- read_csv("scripts/data/cars.csv")
cars %>%
  View()

read_csv("x,y,z
         1,2,3.5
         4,5,6
         7,8,9")

read_csv("Este fichero fue generado por Jesús
         el día 8 de enero de 2023 para poderlo
         usar en el curso de Tidyverse
         x,y,z
         1,2,3
         4,5,6", skip = 3) # saltarse 3 lineas (de los comentarios)

read_csv("#Esto es un comentario
         x,y,z
         1,2,3
         4,5,6", comment = "#") # saltarse todas las lineas que empiecen por #

read_csv("1,2,3\n4,5,6\n7,8,9", col_names = FALSE)

read_csv("1,2,3\n4,5,6\n7,8,9", col_names = c("primera", "segunda", "tercera"))

read_csv("x,y,z\n1,2,.\n4,#,6", na = c(".", "#"))


## Los Parsers de readr

#parse_*
str(parse_logical(c("TRUE","FALSE","FALSE","NA")))
str(parse_integer(c(1,2,3,4)))
str(parse_date(c("1992-12-26", "2023-01-08")))

parse_integer(c("1","2","#","5","729"), na = "#")

data <- parse_integer(c("1","2","hola","5","234","3.141592"))
problems(data)

# parse_logical()
# parse_integer()


# parse_double()
# parse_number()
  # decimales -> . ,
parse_double("12.345")
parse_double("12,345", locale = locale(decimal_mark = ","))
# monetarios 100€, $1000
  # porcentajes 12%
parse_number("100€")
parse_number("$1000")
parse_number("12%")
parse_number("El vestido ha costado 12.45€")  
  # agrupaciones 1,000,000
parse_number("$1,000,000")
parse_number("$1.000.000", locale = locale(grouping_mark = "."))
parse_number("123'456'789", locale = locale(grouping_mark = "'"))


# parse_character()
charToRaw("Jesús Mudarra") #ASCII
#Latin1 (ISO-8859-1) para idiomas de Europa del Oeste
  #b1 -> +-
#Latin2 (ISO-8859-2) para idiomas de Europa del Oeste
  #b1 -> a
#UTF-8
x1 <- "El Ni\xf1o ha estado enfermo"
x2 <- "\x82\xb1\x82\xf1\x82\xb2\x82\xcd"
parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

# parse_factor()
months <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug",
            "Sep","Oct","Nov","Dec")
parse_factor(c("May","Apr","Jul","Aug","Sec","Nob"), levels = months) # salta error por estar mal escrito


# parse_datetime() ISO-8601
# parse_date()
# parse_time()
# EPOCH -> 1970-01-01 00:00
parse_datetime("2023-01-09T0127") # "2023-01-09 01:27:00 UTC"
parse_datetime("20230109") # "2023-01-09 UTC"

parse_date("2015-12-07") # "2015-12-07"
parse_date("2017/05/18") # "2017-05-18"

parse_time("03:00pm")
parse_time("20:00:34")

# Años
# %Y -> año con 4 dígitos
# %y -> año con 2 dígitos (00-69) -> 2000-2069, (70-99) -> 1970-1999

# Meses
# %m -> mes en formato de dos dígitos 01-12
# %b -> abreviación del mes 'Ene', 'Feb', ...
# %B -> nombre completo del mes 'Enero', 'Febrero', ...

# Día
# %d -> número del día con dos dígitos 01-31
# %e -> de forma opcional, los dígitos 1-9 pueden llevar espacio en blanco

# Horas
# %H -> hora entre 0-23
# %I -> hora entre 0-12 siempre con %p
# %p -> am/pm
# %M -> minutos 0-59
# %s -> segundos enteros 0-59
# %OS -> segundos reales
# %Z -> Zona horaria America/Chicago, Canada, France, Spain, ...
# %z -> Zona horaria respecto a UTC+0800, +0100

# No dígitos
# %. -> Eliminar un carácter no dígito
# %* -> Eliminar cualquier número de caracteres que no sean dígitos

parse_date("05/08/15", format = "%d/%m/%y") # "2015-08-05"
parse_date("08/05/15", format = "%m/%d/%y") # "2015-08-05"
parse_date("01-05-2018", format = "%d-%m-%Y") # "2018-05-01"
parse_date("01 Jan 2018", format = "%d %b %Y")
parse_date("03 March 17", format = "%d %B %y")
parse_date("5 janvier 2012", format = "%d %B %Y", locale = locale("fr"))
parse_date("3 Septiembre 2014", format ="%d %B %Y", locale = locale("es")) 


# lógico -> integer -> double -> number
# -> time -> date -> datetime -> strings
guess_parser("2023-01-09")
guess_parser("18:59")
guess_parser(c("3,6,8,25"))
guess_parser(c("TRUE","FALSE","TRUE","F","T"))
guess_parser(c("3","6","8","25"))

challenge <- read_csv(readr_example("challenge.csv")) # en teoría debería de salir errores
problems(challenge)

challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(
                        x = col_double(), #parse_double()
                        y = col_date() #parse_date()
                      ))
View(challenge)
tail(challenge)


challenge2 <- read_csv(readr_example("challenge.csv"),
                       guess_max = 1001)
challenge2

challenge3 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character()))
challenge3
type_convert(challenge3)

df <- tribble(
  ~x, ~y,
  "1","1.2",
  "2","3.87",
  "3","3.1415"
)
type_convert(df)

read_lines(readr_example("challenge.csv"))
read_file(readr_example("challenge.csv"))


# Escritura de ficheros
# write_csv(), write_tsv()
# strings en UTF-8
# date / datetimes ISO-8601
# write_excel_csv()

write_csv(challenge, file = "scripts/data/challenge.csv")

read_csv("scripts/data/challenge.csv", guess_max = 1001)

write_rds(challenge, file = "scripts/data/challenge.rds")
read_rds("scripts/data/challenge.rds")

library(feather)
write_feather(challenge, path = "scripts/data/challenge.feather")
read_feather("scripts/data/challenge.feather")

# haven -> SPSS, Stata, SAS
# readxl -> .xml, .xmls
# DBI + RMySQL, RSQLite, RPostgreSQL

# jsonlite
# xml2

# rio (read input output)
