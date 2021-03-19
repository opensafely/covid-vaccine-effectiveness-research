from cohortextractor import (
    StudyDefinition,
    patients,
    codelist_from_csv,
    codelist,
    filter_codes_by_category,
    combine_codelists,
)

# Import codelists
from codelists import *

# Import json module
import json

# Import global-variables.json
with open("./analysis/global-variables.json") as f:
    gbl_vars = json.load(f)

# Define variables explicitly
start_date = gbl_vars["start_date"] # change this in global-variables.json if necessary
end_date = gbl_vars["end_date"] # change this in global-variables.json if necessary

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
    population=patients.all(
        # """
        # registered
        # AND
        # has_follow_up_previous_year
        # AND
        # (age >= 18 AND age < 110)
        # AND
        # (sex = "M" OR sex = "F")
        # AND
        # NOT has_died
        # AND
        # NOT unknown_vaccine_brand
        # AND
        # imd > 0
        # AND
        # region != ""
        # ethnicity > 0 OR ethnicity_6_sus > 0
        # """,
    ),
    
    # Inclusion/exclusion variables

    ## Age
    age=patients.age_as_of(
        "2020-03-31",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
            "incidence" : 0.001
        },
    ),
    
    # Sex
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),
    
    # Follow up
    has_follow_up_previous_year=patients.registered_with_one_practice_between(
        start_date="index_date - 1 year",
        end_date="index_date",
        return_expectations={"incidence": 0.95},
    ),
    
    # Registered
    registered_at_latest=patients.registered_as_of(
        reference_date=end_date,
        return_expectations={"incidence": 0.95},
    ),
    
    # Alive
    has_died=patients.died_from_any_cause(
            on_or_before="index_date",
            returning="binary_flag",
        ),
        
    # First COVID vaccination (any brnad)
    covid_vax_1_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after="index_date",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
                return_expectations={
            "date": {
                "earliest": "2020-12-08",  # first vaccine administered on the 8/12
                "latest": end_date,
            }
        },
    ),
    
    # First Pfizer vaccination
    covid_vax_pfizer_1_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vac BNT162b2 30mcg/0.3ml conc for susp for inj multidose vials (Pfizer-BioNTech)",
        on_or_after="index_date",  # check all december to date
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
                return_expectations={
            "date": {
                "earliest": "2020-12-08",  # first vaccine administered on the 8/12
                "latest": end_date,
            }
        },
    ),
    
    # First Oxford AZ vaccination 
    covid_vax_az_1_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="index_date",  # check all december to date
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-01-04",  # first vaccine administered on the 4/1
                "latest": end_date,
            }
        },
    ),
    
    # Unknown vaccine brand
    unknown_vaccine_brand = patients.satisfying(
        """
        covid_vax_1_date != ""
        AND
        covid_vax_pfizer_1_date = ""
        AND
        covid_vax_az_1_date = ""
        """,
        return_expectations={"incidence": 0.0001},
    ),


    # Ethnicity (6 categories)
    ethnicity=patients.with_these_clinical_events(
        ethnicity_codes,
        returning="category",
        find_last_match_in_period=True,
        include_date_of_match=False,
        return_expectations={
            "category": {"ratios": {"1": 0.2, "2": 0.2, "3": 0.2, "4": 0.2, "5": 0.2}},
            "incidence": 0.75,
        },
    ),
    
    ethnicity_6_sus = patients.with_ethnicity_from_sus(
        returning="group_6",  
        use_most_frequent_code=True,
        return_expectations={
            "category": {"ratios": {"1": 0.2, "2": 0.2, "3": 0.2, "4": 0.2, "5": 0.2}},
            "incidence": 0.4,
            },
    ),

    # NHS administrative region
    region=patients.registered_practice_as_of(
        "index_date",
        returning="nuts1_region_name",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "North East": 0.1,
                    "North West": 0.1,
                    "Yorkshire and the Humber": 0.2,
                    "East Midlands": 0.1,
                    "West Midlands": 0.1,
                    "East of England": 0.1,
                    "London": 0.1,
                    "South East": 0.1,
                    "" : 0.1
                },
            },
        },
    ),

    # IMD - quintile
    imd=patients.categorised_as(
        {
            "0": "DEFAULT",
            "1": """index_of_multiple_deprivation >=1 AND index_of_multiple_deprivation < 32844*1/5""",
            "2": """index_of_multiple_deprivation >= 32844*1/5 AND index_of_multiple_deprivation < 32844*2/5""",
            "3": """index_of_multiple_deprivation >= 32844*2/5 AND index_of_multiple_deprivation < 32844*3/5""",
            "4": """index_of_multiple_deprivation >= 32844*3/5 AND index_of_multiple_deprivation < 32844*4/5""",
            "5": """index_of_multiple_deprivation >= 32844*4/5 """,
        },
        index_of_multiple_deprivation=patients.address_as_of(
            "index_date",
            returning="index_of_multiple_deprivation",
            round_to_nearest=100,
        ),
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "0": 0.01,
                    "1": 0.20,
                    "2": 0.20,
                    "3": 0.20,
                    "4": 0.20,
                    "5": 0.19,
                }
            },
        },
    ),

)
