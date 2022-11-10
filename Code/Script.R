library(tidyverse)
library(ggplot2)

assignments = read_csv("ML Project/assignments.csv", 
                        col_types = cols(assignment_created_at = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                         start_date = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                         end_date = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                         filled_date = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                         hours_worked = col_double(),
                                         bonus_percent = col_double(),
                                         admin_bonus_percent = col_double(),
                                         bonus_added_at = col_datetime(format = "%Y-%m-%d %H:%M:%S"),
                                         professional_removed_at = col_datetime(format = "%Y-%m-%d %H:%M:%S")))






contractor_availability_true = read_csv("ML Project/contractor-availability-true.csv", 
                                        col_types = cols(date = col_date(format = "%Y-%m-%d")))

contractor_geolocations_distance = read.csv('~/R/unspecified-ML-project/ML Project/contractor-geolocations-distance.csv')

office_alternative_locations = read.csv('~/R/unspecified-ML-project/ML Project/office-alternative-locations.csv')

office_geolocations = read.csv('~/R/unspecified-ML-project/ML Project/office-geolocations.csv')

office_softwares = read.csv('~/R/unspecified-ML-project/ML Project/office-softwares.csv')


#Create relevant columns for assignmentsassignments
assignments$is_filled = if_else(assignments$contractor_id == 'NULL', 0, 1)

#Create assignments df that's only past assignments
past_assignments = assignments %>%
  filter(end_date < Sys.Date())