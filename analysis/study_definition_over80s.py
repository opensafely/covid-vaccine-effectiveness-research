
from cohortextractor import (
    StudyDefinition,
    patients,
    codelist_from_csv,
    codelist,
    filter_codes_by_category,
    combine_codelists,
)

# Import variable dictionaries
from common_variables import *

# Import Codelists
from codelists import *

# import json module
import json

# import global-variables.json
with open("./analysis/global-variables.json") as f:
    gbl_vars = json.load(f)

# define variables explicitly
start_date = gbl_vars["start_date_over80s"]
end_date = gbl_vars["end_date"] 
# change this in global-variables.json if necessary
# start_date is currently set to the start of the vaccination campaign
# end_date depends on the most reent data coverage in the database, and the particular variables of interest



# Specifiy study defeinition
study = StudyDefinition(
    # Configure the expectations framework
    default_expectations={
        "date": {"earliest": "1970-01-01", "latest": end_date},
        "rate": "uniform",
        "incidence": 0.2,
    },
        
    index_date = start_date,
    # This line defines the study population
    population=patients.satisfying(
        """
        registered
        AND
        (age >= 80 AND age < 110)
        AND
        NOT has_died
        """,
        registered=patients.registered_as_of(
            "index_date",
        ),
        has_died=patients.died_from_any_cause(
            on_or_before="index_date - 1 day",
            returning="binary_flag",
        ),
    ),

    **demographic_variables,
    
    **clinical_variables,
    
    **vaccination_variables,
    
     **event_variables,
)
