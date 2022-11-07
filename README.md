# unspecified-ML-project

**Tasks**:

- Determine how to generate a "Supply" for any given work site (NEED TO COMPLETE THE HIGH COMPLEXITY TASK AT THE BOTTOM OF THIS LIST FIRST)
- Likewise, generate a "demand"
- Create an "is_urgent" column
- Create a "shift_length" column
- Create a "day_of_week" column (use numbered days)
- Create a season column


- Slightly more complex task: they want insights based on the software used by the clinic. Let's create a numbered key for all of the different softwares used, and then join that key to the assignments dataset rather than join the names of the softwares. That way we can more easily feed the data to a ML algorithm

- High Complexity: Seems as though determining what constitutes an "available contractor" includes calculating their distance in miles from a location. Going to have to do this through latitudes and longitudes.

**Questions to Ask**:

- There are two position_id's (1 and 2). position_id indicates the type of contractor, but there isn't any info about what those types are.
- In demand it says "# of other shifts available in that area". What is an 'area' in this context? Is it an office_id? Or is it a radius around that specific office_id?
- Similarly, "Location of clients work site". What exactly does location refer to here? Is it just the latitude and longitude? Or are we trying to analyze the city/zip/county/state?
- Ask if they want us to calculate distance as just a straight line from Point A to Point B, or if they want the distance to be a driving distance instead

**Completed Tasks**:

