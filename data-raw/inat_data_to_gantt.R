## code to prepare `inat_data_to_gantt` dataset goes here

library(tidyverse)

# identify the top 10 species in every site
top10species <- shinyInat::inatqc %>%
  group_by(region, taxon_species_name) %>%
  tally %>%
  arrange(region,desc(n)) %>%
  nest %>%
  mutate(top10 = map(data, head, 10)) %>%
  select(-data) %>%
  unnest(top10)


# count observations on each day of the year for each species
count_taxa <- shinyInat::inatqc %>%
  mutate(julianday = lubridate::yday(observed_on)) %>%
  group_by(region, taxon_species_name, julianday) %>% 
  tally

# take only the top 10 species in each site -- test out the filtering join
count_taxa %>%
  semi_join(top10species %>% select(-n)) %>%
  ggplot(aes(x = julianday, y = n)) +
  geom_point() +
  facet_wrap(~region)


# collect the start and end for every taxa
inat_data_to_gantt <- count_taxa %>%
  semi_join(top10species %>% select(-n),
            by = c("region", "taxon_species_name")) %>%
  group_by(region, taxon_species_name) %>% nest %>% 
  mutate(map_df(data, ~ tibble(start = min(.x$julianday), 
                               end = max(.x$julianday)))) %>% 
  select(-data) %>% 
  ungroup



usethis::use_data(inat_data_to_gantt, overwrite = TRUE)



# count days in the "range" for each species
nper_day <- chosen_species_range_days %>%
  mutate(dayrange = map2(start, end, ~.x:.y)) %>%
  select(dayrange) %>%
  unnest(cols = c(dayrange)) %>%
  group_by(dayrange) %>% tally %>%
  # fill in missing days:
  right_join(tibble(dayrange = 1:365)) %>%
  replace_na(list(n = 0)) %>%
  arrange(dayrange)



usethis::use_data(nper_day, overwrite = TRUE)

