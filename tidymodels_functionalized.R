
### Tidymodels functionalized 

## Setup 

# source our libraries and functions
source(here::here("libraries.R"))
source(here::here("functions.R"))

## Load all models
mods = map(model_names, load_models)