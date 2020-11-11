## code to prepare `inat_data_to_gantt` dataset goes here

library(tidyverse)

# identify the top 10 species in every site
top10species <- tableauphenologie::inatqc %>%
  group_by(region, taxon_species_name) %>%
  tally %>%
  arrange(region,desc(n)) %>%
  nest %>%
  mutate(top10 = map(data, head, 10)) %>%
  select(-data) %>%
  unnest(top10)


# count observations on each day of the year for each species
count_taxa <- tableauphenologie::inatqc %>%
  mutate(julianday = lubridate::yday(observed_on)) %>%
  group_by(region, taxon_species_name, julianday) %>% 
  tally

# take only the top 10 species in each site -- test out the filtering join
count_taxa %>%
  semi_join(top10species %>% select(-n)) %>%
  ggplot(aes(x = julianday, y = n)) +
  geom_point() +
  facet_wrap(~region)

top_10_julian_day <- count_taxa %>%
  semi_join(top10species %>% select(-n),
            by = c("region", "taxon_species_name"))


# collect the start and end for every taxa
inat_data_to_gantt <- top_10_julian_day %>%
  group_by(region, taxon_species_name) %>% nest %>% 
  mutate(map_df(data, ~ tibble(start = min(.x$julianday), 
                               end = max(.x$julianday)))) %>% 
  select(-data) %>% 
  ungroup %>% 
  pivot_longer(cols = c("start", "end"), names_to = "dayname", values_to = "jday")



usethis::use_data(inat_data_to_gantt, overwrite = TRUE)


top_10_julian_day

chosen_species_range_days <- top_10_julian_day %>%
  group_by(region, taxon_species_name) %>% 
  summarize(jday = range(julianday)) %>%
  # rank species -- flexibly, for those seen only one day
  mutate(dayname = c("start", "end")) %>% 
  pivot_wider(names_from = dayname, values_from = jday) 


# count days in the "range" for each species
nper_day <- chosen_species_range_days %>%
  mutate(dayrange = map2(start, end, ~.x:.y)) %>%
  select(dayrange) %>%
  unnest(cols = c(dayrange)) %>%
  group_by(region, dayrange) %>% tally %>%
  # grouped by region
  nest %>% 
  mutate(data2 = map(data, right_join, y = tibble(dayrange = 1:365), by = "dayrange")) %>%
  select(-data) %>% 
  unnest(data2) %>% 
  replace_na(list(n = 0)) %>%
  arrange(region, dayrange) %>% 
  ungroup

nper_day

usethis::use_data(nper_day, overwrite = TRUE)

