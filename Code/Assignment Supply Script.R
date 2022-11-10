library(tidyverse)
library(data.table)
library(lubridate)
library(readr)

distance = fread('~/R/unspecified-ML-project/ML Project/distance.csv')

contractor_geolocations_distance = fread('~/R/unspecified-ML-project/ML Project/contractor-geolocations-distance.csv')

assignments = read_csv("~/R/unspecified-ML-project/ML Project/assignments.csv", 
                       col_types = cols(assignment_created_at = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                        start_date = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                        end_date = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                        filled_date = col_datetime(format = "%Y-%m-%d %H:%M:%S"), 
                                        hours_worked = col_double(),
                                        bonus_percent = col_double(),
                                        admin_bonus_percent = col_double(),
                                        bonus_added_at = col_datetime(format = "%Y-%m-%d %H:%M:%S"),
                                        professional_removed_at = col_datetime(format = "%Y-%m-%d %H:%M:%S")))

contractor_availability_true = read_csv("~/R/unspecified-ML-project/ML Project/contractor-availability-true.csv", 
                                        col_types = cols(date = col_date(format = "%Y-%m-%d")))


#Join the distance data with the contractor's set maximum distance
distance = distance %>%
  left_join(
    contractor_geolocations_distance,
    by = "contractor_id"
  )

#The client said to calculate contractor availability in regards to distance using any given contractor's max distance +5. So just going to add 5 to the column
distance$maximum_travel_distance = distance$maximum_travel_distance + 5

#Filter out all rows where a contractor's maximum range (with the 5 we added) is LESS than the distance to the office
distance = distance %>%
  filter(maximum_travel_distance >= distance)

#Our distance dataset now represents the pool of contractors that are available to work at any given office location (not factoring in scheduling availability)
#Next step is to factor in scheduling
#Going to be a bit of a process here, but I'll do my best to detail what I'm doing

#First, we're going to create a version of assignments where we only have the columns for date of assignment start, and the contractor that filled that position
#We're going to use this dataset to determine which contractors are unavailable due to already being assigned to work a particular date
assigned_contractors = assignments %>%
  filter(contractor_id != 'NULL') %>%
  select(c(contractor_id, start_date)) %>%
  mutate(already_assigned = 1)

#Not sure if you can join a datetime with a regular date, so let's convert the start datetimes to regular dates
assigned_contractors$start_date = as.Date(assigned_contractors$start_date)

#Also apparently the contractor_id here is character based so let's convert it to numeric
assigned_contractors$contractor_id = as.numeric(assigned_contractors$contractor_id)

#Now we're going to join distance on contractor availability so that we'll have the dates each contractor is available for any given office location
contractor_availability_true = contractor_availability_true %>%
  left_join(
    distance,
    "contractor_id"
  )

#New table is pretty huge but we're going to cut it down in a bit
#Now it's time to join our "Assigned Contractors" table that we made onto this, so that we'll have a table that tells us both the days that contractors are available
#as well as days that the contractors are already scheduled for a shift

contractor_availability_true = contractor_availability_true %>%
  left_join(
    assigned_contractors,
    by = c("contractor_id", 
           "date" = "start_date")
  )

#Now let's take this table and use group_by to calculate the "supply" of contractors for any given assignment date and office location
assignment_supply = contractor_availability_true %>%
  group_by(office_id, date) %>%
  summarise(
    available_contractors = sum(is.na(already_assigned))
  )

#Exporting this into a csv because it seems very relevant
write.csv(
  assignment_supply,
  "~/R/unspecified-ML-project/Output/assignment-supply.csv",
  row.names = F
)