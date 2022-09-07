
library(tidyverse) # version 1.3.2

# tidyverse 1.3.2 ──
# ✔ ggplot2 3.3.6      ✔ purrr   0.3.4 
# ✔ tibble  3.1.8      ✔ dplyr   1.0.10
# ✔ tidyr   1.2.0      ✔ stringr 1.4.1 
# ✔ readr   2.1.2      ✔ forcats 0.5.2 

# Los coches con motor más grande consumen más combustible
# que los coches con motor más pequeño.
# La relación consumo/tamaño es lineal? Es no lineal? Es exponencial?
# Es positiva? Es negativa?

View(mpg)
?mpg #help(mpg)
# displ: tamaño del motor del coche en litros
# hwy: número de millas recorridas en autopista por galón de combustible (3.78541 litros)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# Plantilla para hacer una representación gráfica con ggplot
#ggplot(data = <DATA_FRAME>) +
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
  
# Color de los puntos
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Tamaño de los puntos (conviene que sea numérico)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# Transparencia de los puntos
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Forma de los puntos (aparece warning porque ggplot solo permite 6 formas a la vez)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# Elección manual de estéticas
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "red") # Esto ya se trata de una estética global
# color = nombre del color en formato string
# size = tamaño en puntos en mm
# shape = forma del punto con números desde el 0 al 25
# 0 - 14: son formas huecas y por tanto solo se puede cambiar el color
# 15 - 20: son formas rellenas de color, por tanto se puede le puede cambiar el color
# 21 - 25: son formas con borde y relleno, y se les puede cambiar el color (borde) y el fill (relleno)

d = data.frame(p = c(0:25))
ggplot() +
  scale_y_continuous(name = "") +
  scale_x_continuous(name = "") +
  scale_shape_identity() +
  geom_point(data = d, mapping = aes(x = p%%16, y = p%/%16, shape = p, size = 5, fill = "red")) +
  geom_text(data = d, mapping = aes(x = p%%16, y = p%/%16+0.25, label = p), size = 3)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),
             shape = 23,
             size = 10,
             color = "red",
             fill = "yellow")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),
             shape = 23,
             size = 10,
             color = "red",
             fill = "yellow", stroke = 5)

# FACETS

# facet_wrap(~ <FORMULA_VARIABLE>): la variable debe de ser discreta
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 3)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ cty, nrow = 3)

# facet_grid(<FORMULA_VARIABLE1> ~ <FORMULA_VARIABLE2>)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)
  
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# Diferentes geometrías
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, color = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv, # a diferencia del linetype no hay leyenda
                            color = drv), show.legend = F)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = cty)) +
  geom_smooth(mapping = aes(x = displ, y = cty))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + # mappings globales
  geom_point(mapping = aes(color = class)) +
geom_smooth(mapping = aes(color = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "suv"), se = F)


# Ejemplo del dataset de diamantes
View(diamonds)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

?geom_bar

# Lo siguiente sale lo mismo que utilizando geom_bar()
ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))

demo_diamonds <- tribble(
  ~ cut, ~ freqs,
  "Fair", 1610,
  "Good", 4906,
  "Very Good", 12082,
  "Premium", 13791,
  "Ideal", 21551
)

# El stat sirve para indicar que el eje Y tiene que tener en cuenta las freqs
ggplot(data = demo_diamonds) +
  geom_bar(mapping = aes(x = cut, y = freqs), stat = "identity")

# Importante poner el group = 1 para que todas las filas sumen 1
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) +
  stat_summary(mapping = aes(x = cut, y = price),
               fun.min = min,
               fun.max = max,
               fun = mean)

# Colores y formas de los gráficos
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity)) # diagrama de barras apilado

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color)) # diagrama de barras apilado

# position = "identity"
ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) +
  geom_bar(fill = NA, position = "identity") # como si estuvieran uno detrás de otro

# position = "fill"
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill") # para comparar proporciones

# position = "dodge"
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge") # para cada grupo tenemos una barra al lado de la otra, más fácil de comparar

# Volvemos al scatterplot
## position = "jitter"
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(position = "jitter") # añade ruido para dispesar los puntos y que no caigan en el mismo sitio

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_jitter() # es lo mismo que lo anterior

?position_stack
?position_identity
?position_fill
?position_dodge
?position_jitter

# Sistemas de Coordenadas

# coord_flip() -> cambia los papeles de x e y
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

# coord_quickmap() -> configura el aspect ratio para mapas
usa <- map_data("usa")

ggplot(usa, aes(long, lat, group = group)) +
  geom_polygon(fill = "blue", color = "white") +
  coord_quickmap() # ajusta la deformación de los mapas

italy <- map_data("italy")

ggplot(italy, aes(long, lat, group = group)) +
  geom_polygon(fill = "blue", color = "white") +
  coord_quickmap() # ajusta la deformación de los mapas

# coord_polar()
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut),
           show.legend = F,
           width = 1) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL) +
  coord_polar()

# Gramática de las capas de ggplot2

#ggplot(data = <DATA_FRAME>) +
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>),
#  stat = <STAT>,
#  position = <POSITION>) +
#  <COORDINATE_FUNCTION>() +
#  <FACET_FUNCTION>()

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = clarity, fill = clarity, y = ..count..)) + # saldría lo mismo sin el y = ..count..
  coord_polar() +
  facet_wrap(~ cut) +
  labs(x = NULL, y = NULL, title = "Ejemplo final de ggplot con JB",
       caption = "Dos variables cruzadas de diamonds",
       subtitle = "Aprender ggplot puede ser hasta divertido ;)")
