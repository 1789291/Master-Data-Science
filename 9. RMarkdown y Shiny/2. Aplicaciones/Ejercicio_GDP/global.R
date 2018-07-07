require(gapminder)
require(ggplot2)
require(dplyr)

# Quitamos Kuwait

df_sin_kuw <- gapminder %>% filter(!country == 'Kuwait')



