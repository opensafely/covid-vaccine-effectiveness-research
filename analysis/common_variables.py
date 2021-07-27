
from cohortextractor import (
    StudyDefinition,
    patients,
    codelist_from_csv,
    codelist,
    filter_codes_by_category,
    combine_codelists,
)

# Import Codelists
from codelists import *

# get STP codes

import pandas as pd

STPs = pd.read_csv(
    filepath_or_buffer = './lib/STP_region_map.csv'
)

dict_stp = { stp : 1/len(STPs.index) for stp in STPs['Code'].tolist() }


# define recurrent event variables

def with_these_clinical_events_date_X(name, codelist, index_date, n, return_expectations):
    
    def var_signature(name, on_or_after, codelist, return_expectations):
        return {
            name: patients.with_these_clinical_events(
                    codelist,
                    returning="date",
                    on_or_after=on_or_after,
                    date_format="YYYY-MM-DD",
                    find_first_match_in_period=True,
                    return_expectations=return_expectations
	    ),
        }
    variables = var_signature(f"{name}_1_date", index_date, codelist, return_expectations)
    for i in range(2, n+1):
        variables.update(var_signature(f"{name}_{i}_date", f"{name}_{i-1}_date + 1 day", codelist, return_expectations))
    return variables




def covid_test_date_X(name, index_date, n, test_result, return_expectations):
    
    def var_signature(name, on_or_after, test_result, return_expectations):
        return {
            name: patients.with_test_result_in_sgss(
                pathogen="SARS-CoV-2",
                test_result=test_result,
                on_or_after=on_or_after,
                find_first_match_in_period=True,
                restrict_to_earliest_specimen_date=False,
                returning="date",
                date_format="YYYY-MM-DD",
                return_expectations=return_expectations
	        ),
        }
    variables = var_signature(f"{name}_1_date", index_date, test_result, return_expectations)
    for i in range(2, n+1):
        variables.update(var_signature(f"{name}_{i}_date", f"{name}_{i-1}_date + 1 day", test_result, return_expectations))
    return variables


def emergency_attendance_date_X(name, index_date, n, return_expectations):
    
    def var_signature(name, on_or_after, return_expectations):
        return {
            name: patients.attended_emergency_care(
                    returning="date_arrived",
                    on_or_after=on_or_after,
                    find_first_match_in_period=True,
                    date_format="YYYY-MM-DD",
                    return_expectations=return_expectations
	        ),
        }
    variables = var_signature(f"{name}_1_date", index_date, return_expectations)
    for i in range(2, n+1):
        variables.update(var_signature(f"{name}_{i}_date", f"{name}_{i-1}_date + 1 day", return_expectations))
    return variables


def admitted_date_X(
    name, index_name, index_date, n, returning, 
    with_these_diagnoses=None, 
    with_admission_method=None, 
    with_patient_classification=None, 
    return_expectations=None
):
    def var_signature(
        name, on_or_after, returning, 
        with_these_diagnoses, 
        with_admission_method, 
        with_patient_classification, 
        return_expectations
    ):
        return {
            name: patients.admitted_to_hospital(
                    returning = returning,
                    on_or_after = on_or_after,
                    find_first_match_in_period = True,
                    date_format = "YYYY-MM-DD",
                    with_these_diagnoses = with_these_diagnoses,
                    with_admission_method = with_admission_method,
                    with_patient_classification = with_patient_classification,
                    return_expectations = return_expectations
	        ),
        }
    variables = var_signature(
        f"{name}_1_date", 
        index_date, 
        returning, 
        with_these_diagnoses,
        with_admission_method,
        with_patient_classification,
        return_expectations
    )
    for i in range(2, n+1):
        variables.update(var_signature(
            f"{name}_{i}_date", f"{index_name}_{i-1}_date + 1 day", returning, 
            with_these_diagnoses,
            with_admission_method,
            with_patient_classification,
            return_expectations
        ))
    return variables


###############################################
#### demographic/administrative variables #####
###############################################

demographic_variables = dict(
    # https://github.com/opensafely/risk-factors-research/issues/49
    age=patients.age_as_of(
        "2020-03-31", # based on JCVI priority group definitions
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
            "incidence" : 1
        },
    ),
    
    # https://github.com/opensafely/risk-factors-research/issues/46
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),
    
    # ETHNICITY IN 6 CATEGORIES
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
    
    # New ethnicity variable that takes data from SUS
    ethnicity_6_sus = patients.with_ethnicity_from_sus(
        returning="group_6",  
        use_most_frequent_code=True,
        return_expectations={
            "category": {"ratios": {"1": 0.2, "2": 0.2, "3": 0.2, "4": 0.2, "5": 0.2}},
            "incidence": 0.8,
            },
    ),
    
    # ETHNICITY IN 16 CATEGORIES
    # ethnicity_16=patients.with_these_clinical_events(
    #     ethnicity_codes_16,
    #     returning="category",
    #     find_last_match_in_period=True,
    #     include_date_of_match=False,
    #     return_expectations={
    #         "category": {
    #             "ratios": {
    #                 "1": 0.0625,
    #                 "2": 0.0625,
    #                 "3": 0.0625,
    #                 "4": 0.0625,
    #                 "5": 0.0625,
    #                 "6": 0.0625,
    #                 "7": 0.0625,
    #                 "8": 0.0625,
    #                 "9": 0.0625,
    #                 "10": 0.0625,
    #                 "11": 0.0625,
    #                 "12": 0.0625,
    #                 "13": 0.0625,
    #                 "14": 0.0625,
    #                 "15": 0.0625,
    #                 "16": 0.0625,
    #             }
    #         },
    #         "incidence": 0.75,
    #     },
    # ),
    
    
    #### registration variables

    has_follow_up_previous_year=patients.registered_with_one_practice_between(
        start_date="index_date - 1 year",
        end_date="index_date - 1 day",
        return_expectations={"incidence": 0.99},
    ),

    dereg_date=patients.date_deregistered_from_all_supported_practices(
        on_or_after="index_date - 1 day", date_format="YYYY-MM-DD",
    ),


    ###### practice and patient address variables

    # practice pseudo id
    practice_id=patients.registered_practice_as_of(
        "index_date - 1 day",  # day before vaccine campaign start
        returning="pseudo_id",
        return_expectations={
            "int": {"distribution": "normal", "mean": 1000, "stddev": 100},
            "incidence": 1,
        },
    ),
    
    # msoa
    msoa=patients.address_as_of(
        "index_date - 1 day",
        returning="msoa",
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"E02000001": 0.0625, "E02000002": 0.0625, "E02000003": 0.0625, "E02000004": 0.0625,
                                    "E02000005": 0.0625, "E02000007": 0.0625, "E02000008": 0.0625, "E02000009": 0.0625, 
                                    "E02000010": 0.0625, "E02000011": 0.0625, "E02000012": 0.0625, "E02000013": 0.0625, 
                                    "E02000014": 0.0625, "E02000015": 0.0625, "E02000016": 0.0625, "E02000017": 0.0625}},
        },
    ),    

    # stp is an NHS administration region based on geography
    stp=patients.registered_practice_as_of(
        "index_date - 1 day",
        returning="stp_code",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": dict_stp
            },
        },
    ),
    # NHS administrative region
    region=patients.registered_practice_as_of(
        "index_date - 1 day",
        returning="nuts1_region_name",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "North East": 0.1,
                    "North West": 0.2,
                    "Yorkshire and the Humber": 0.2,
                    "East Midlands": 0.1,
                    "West Midlands": 0.1,
                    "East of England": 0.1,
                    "London": 0.1,
                    "South East": 0.09,
                    "" : 0.01
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
            "index_date - 1 day",
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
    
    rural_urban=patients.address_as_of(
        "2020-03-01",
        returning="rural_urban_classification",
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {1: 0.125, 2: 0.125, 3: 0.125, 4: 0.125, 5: 0.125, 6: 0.125, 7: 0.125, 8: 0.125}},
        },
    ),

    # CAREHOME STATUS
    care_home_type=patients.care_home_status_as_of(
        "index_date - 1 day",
        categorised_as={
            "Carehome": """
              IsPotentialCareHome
              AND LocationDoesNotRequireNursing='Y'
              AND LocationRequiresNursing='N'
            """,
            "Nursinghome": """
              IsPotentialCareHome
              AND LocationDoesNotRequireNursing='N'
              AND LocationRequiresNursing='Y'
            """,
            "Mixed": "IsPotentialCareHome",
            "": "DEFAULT",  # use empty string
        },
        return_expectations={
            "category": {"ratios": {"Carehome": 0.05, "Nursinghome": 0.05, "Mixed": 0.05, "": 0.85, }, },
            "incidence": 1,
        },
    ),

    # simple care home flag
    care_home_tpp=patients.satisfying(
        """care_home_type""",
        return_expectations={"incidence": 0.01},
    ),
    
    care_home_code=patients.with_these_clinical_events(
        carehome_primis_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.01},
    ),
    
    # household_id = patients.household_as_of(
    #     "2020-02-01",
    #     returning="pseudo_id",
    #     return_expectations = {
    #         "int": {"distribution": "normal", "mean": 100000, "stddev": 20000},
    #         "incidence": 1,
    #     },
    # ),
    # 
    # mixed household flag 
    # nontpp_household = patients.household_as_of(
    #     "2020-02-01",
    #     returning="has_members_in_other_ehr_systems",
    #     return_expectations={"incidence": 0.75},
    # ),
    # # mixed household percentage 
    # tpp_coverage = patients.household_as_of(
    #     "2020-02-01", 
    #     returning="percentage_of_members_with_data_in_this_backend", 
    #     return_expectations={
    #         "int": {"distribution": "normal", "mean": 75, "stddev": 10},
    #         "incidence": 1,
    #     },
    # ),

    
)



###############################################################################
# COVID VACCINATION
###############################################################################

vaccination_variables = dict(


    ## any covid vaccination, identified by target disease
    # covid_vax_disease_0_date = patients.with_tpp_vaccination_record(
    #     target_disease_matches="SARS-2 CORONAVIRUS",
    #     on_or_before="index_date -1 day",
    #     find_first_match_in_period=True,
    #     returning="date",
    #     date_format="YYYY-MM-DD",
    #     return_expectations={
    #         "date": {
    #             "earliest": "2020-06-08",  # first vaccine administered on the 8/12
    #             "latest": "2020-12-07",
    #         }
    #     },
    # ),
    # covid_vax_disease_1_date=patients.with_tpp_vaccination_record(
    #     target_disease_matches="SARS-2 CORONAVIRUS",
    #     on_or_after="index_date",
    #     find_first_match_in_period=True,
    #     returning="date",
    #     date_format="YYYY-MM-DD",
    #     return_expectations={
    #         "date": {
    #             "earliest": "2020-12-08",  # first vaccine administered on the 8/12
    #             "latest": "2021-02-01",
    #         }
    #     },
    # ),
    # covid_vax_disease_2_date=patients.with_tpp_vaccination_record(
    #     target_disease_matches="SARS-2 CORONAVIRUS",
    #     on_or_after="covid_vax_1_date + 15 days",
    #     find_first_match_in_period=True,
    #     returning="date",
    #     date_format="YYYY-MM-DD",
    #     return_expectations={
    #         "date": {
    #             "earliest": "2021-02-02",
    #             "latest": "2021-04-30",
    #         }
    #     },
    # ),

    # Pfizer BioNTech - first record of a pfizer vaccine 
    # NB *** may be patient's first COVID vaccine dose or their second if mixed types are given ***
       
    covid_vax_pfizer_0_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vaccine Pfizer-BioNTech BNT162b2 30micrograms/0.3ml dose conc for susp for inj MDV",
        on_or_before="index_date - 1 day",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-06-08",  # first vaccine administered on the 8/12
                "latest": "index_date",
            }
        },
    ), 
    covid_vax_pfizer_1_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vaccine Pfizer-BioNTech BNT162b2 30micrograms/0.3ml dose conc for susp for inj MDV",
        on_or_after="index_date",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-08",  # first vaccine administered on the 8/12
                "latest": "2021-01-01",
            }
        },
    ),
    covid_vax_pfizer_2_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vaccine Pfizer-BioNTech BNT162b2 30micrograms/0.3ml dose conc for susp for inj MDV",
        on_or_after="covid_vax_pfizer_1_date + 15 days",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-29",  # first reported second dose administered on the 29/12
                "latest": "2021-02-01",
            }
        },
    ),
    
    ## Oxford AZ - first record of an Oxford AZ vaccine 
    # NB *** may be patient's first COVID vaccine dose or their second if mixed types are given ***
    covid_vax_az_0_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_before="index_date - 1 day",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-06-04",  # first vaccine administered on the 4/1
                "latest": "index_date",
            }
        },
    ),
    covid_vax_az_1_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="index_date",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-01-04",  # first vaccine administered on the 4/1
                "latest": "2021-02-01",
            }
        },
    ),
    covid_vax_az_2_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="covid_vax_az_1_date + 15 days",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-02-01",
                "latest": "2021-03-01",
            }
        },
    ),
    
    ## Moderna - first record of moderna vaccine
    ## NB *** may be patient's first COVID vaccine dose or their second if mixed types are given ***
    covid_vax_moderna_0_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA (nucleoside modified) Vaccine Moderna 0.1mg/0.5mL dose dispersion for inj MDV",
        on_or_before="index_date - 1 day",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-06-04",  # first vaccine administered on the 4/1
                "latest": "index_date",
            }
        },
    ),            
    covid_vax_moderna_1_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA (nucleoside modified) Vaccine Moderna 0.1mg/0.5mL dose dispersion for inj MDV",
        on_or_after="index_date",  
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-01-04",  # first vaccine administered on the 4/1
                "latest": "2021-02-01",
            }
        },
    ),
    covid_vax_moderna_2_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA (nucleoside modified) Vaccine Moderna 0.1mg/0.5mL dose dispersion for inj MDV",
        on_or_after="covid_vax_moderna_1_date + 15 days",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-02-01",
                "latest": "2021-03-01",
            }
        },
    ),

    unknown_vaccine_brand = patients.satisfying(
        """
        (
            (covid_vax_pfizer_1_date = covid_vax_az_1_date)
            AND
            covid_vax_pfizer_1_date != "" 
            AND
            covid_vax_az_1_date != ""
        )
        OR 
        (
            (covid_vax_pfizer_1_date = covid_vax_moderna_1_date)
            AND
            covid_vax_pfizer_1_date != "" 
            AND
            covid_vax_moderna_1_date != ""
        )
        OR 
        (
            (covid_vax_az_1_date = covid_vax_moderna_1_date)
            AND
            covid_vax_az_1_date != "" 
            AND
            covid_vax_moderna_1_date != ""
        )
        """,
        return_expectations={"incidence": 0.0001},
    ),
    
)
 

################################################
### EVENT VARIABLES
################################################   

event_variables = dict(

############ events during study period ########

    
    # covid test
    **covid_test_date_X(
        name = "covid_test",
        index_date = "index_date",
        n = 5,
        test_result="any",
        return_expectations = {
            "date": {"earliest": "2020-12-01",  "latest" : "2021-03-31"},
            "rate": "exponential_increase",
        },
    ),

    
    # positive covid test
    positive_test_0_date=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        returning="date",
        date_format="YYYY-MM-DD",
        on_or_before="index_date - 1 day",
        find_last_match_in_period=True,
        restrict_to_earliest_specimen_date=False,
        return_expectations={
            "date": {"earliest": "2020-02-01"},
            "rate": "exponential_increase",
            "incidence": 0.01
        },
    ),
    **covid_test_date_X(
        name = "positive_test",
        index_date = "index_date",
        n = 5,
        test_result="any",
        return_expectations = {
            "date": {"earliest": "2020-12-15",  "latest" : "2021-03-31"},
            "rate": "exponential_increase",
        },
    ),


    # covid case identified in primary care
    primary_care_covid_case_0_date=patients.with_these_clinical_events(
        combine_codelists(
            covid_primary_care_code,
            covid_primary_care_positive_test,
            covid_primary_care_sequalae,
        ),
        returning="date",
        date_format="YYYY-MM-DD",
        on_or_before="index_date - 1 day",
        find_last_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-02-01"},
            "rate": "exponential_increase",
            "incidence": 0.01
        },
    ),
    **with_these_clinical_events_date_X(
        name = "primary_care_covid_case",
        n = 5,
        index_date = "index_date",
        codelist = combine_codelists(
            covid_primary_care_code,
            covid_primary_care_positive_test,
            covid_primary_care_sequalae,
        ),
        
        return_expectations={
            "date": {"earliest": "2021-04-01", "latest" : "2021-05-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    
    # suspected covid case identified in primary care
    primary_care_suspected_covid_0_date=patients.with_these_clinical_events(
        primary_care_suspected_covid_combined,
        returning="date",
        date_format="YYYY-MM-DD",
        on_or_before="index_date - 1 day",
        find_last_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-02-01"},
            "rate": "exponential_increase",
            "incidence": 0.01
        },
    ),
    **with_these_clinical_events_date_X(
        name = "primary_care_suspected_covid",
        n = 5,
        index_date = "index_date",
        codelist = primary_care_suspected_covid_combined,
        return_expectations={
            "date": {"earliest": "2021-04-01", "latest" : "2021-05-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    
    # probable covid case identified in primary care
    primary_care_probable_covid_0_date=patients.with_these_clinical_events(
        covid_primary_care_probable_combined,
        returning="date",
        date_format="YYYY-MM-DD",
        on_or_before="index_date - 1 day",
        find_last_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-02-01"},
            "rate": "exponential_increase",
            "incidence": 0.01
        },
    ),
    **with_these_clinical_events_date_X(
        name = "primary_care_probable_covid",
        n = 5,
        index_date = "index_date",
        codelist = covid_primary_care_probable_combined,
        return_expectations={
            "date": {"earliest": "2021-04-01", "latest" : "2021-05-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    
    # emergency attendance
    **emergency_attendance_date_X(
        name = "emergency",
        n = 2,
        index_date = "index_date",
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    # unplanned hospital admission
    admitted_unplanned_0_date=patients.admitted_to_hospital(
        returning="date_admitted",
        on_or_before="index_date - 1 day",
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        with_patient_classification = ["1"],
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    **admitted_date_X(
        name = "admitted_unplanned",
        n = 5,
        index_name = "admitted_unplanned",
        index_date = "index_date",
        returning="date_admitted",
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        with_patient_classification = ["1"],
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    discharged_unplanned_0_date=patients.admitted_to_hospital(
        returning="date_discharged",
        on_or_before="index_date - 1 day",
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        with_patient_classification = ["1"],
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ), 
    **admitted_date_X(
        name = "discharged_unplanned",
        n = 5,
        index_name = "admitted_unplanned",
        index_date = "index_date",
        returning="date_discharged",
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        with_patient_classification = ["1"],
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    
    # unplanned infectious hospital admission
    admitted_unplanned_infectious_0_date=patients.admitted_to_hospital(
        returning="date_admitted",
        on_or_before="index_date - 1 day",
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        with_patient_classification = ["1"],
        with_these_diagnoses = ICD10_I_codes,
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    **admitted_date_X(
        name = "admitted_unplanned_infectious",
        n = 5,
        index_name = "admitted_unplanned_infectious",
        index_date = "index_date",
        returning="date_admitted",
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        with_patient_classification = ["1"],
        with_these_diagnoses = ICD10_I_codes,
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    discharged_unplanned_infectious_0_date=patients.admitted_to_hospital(
        returning="date_discharged",
        on_or_before="index_date - 1 day",
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        with_patient_classification = ["1"],
        with_these_diagnoses = ICD10_I_codes,
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ), 
    **admitted_date_X(
        name = "discharged_unplanned_infectious",
        n = 5,
        index_name = "admitted_unplanned_infectious",
        index_date = "index_date",
        returning="date_discharged",
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        with_patient_classification = ["1"],
        with_these_diagnoses = ICD10_I_codes,
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    # covid hospital adamission
    covidadmitted_0_date=patients.admitted_to_hospital(
        returning="date_admitted",
        with_these_diagnoses=covid_codes,
        on_or_before="index_date - 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-02-01"},
            "rate": "exponential_increase",
            "incidence": 0.01,
        },
    ),
    **admitted_date_X(
        name = "covidadmitted",
        n = 5,
        index_name = "covidadmitted",
        index_date = "index_date",
        returning="date_admitted",
        with_these_diagnoses=covid_codes,
        with_admission_method=["21", "22", "23", "24", "25", "2A", "2B", "2C", "2D", "28"],
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    
    ## planned hospital admission
    # admitted_planned_0_date=patients.admitted_to_hospital(
    #     returning="date_admitted",
    #     on_or_before="index_date - 1 day",
    #     with_admission_method=["11", "12", "13", "81"],
    #     date_format="YYYY-MM-DD",
    #     find_first_match_in_period=True,
    #     return_expectations={
    #         "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
    #         "rate": "uniform",
    #         "incidence": 0.05,
    #     },
    # ), 
    # **admitted_date_X(
    #     name = "admitted_planned",
    #     index_name = "admitted_planned",
    #     index_date = "index_date",
    #     n = 5,
    #     returning="date_admitted",
    #     with_admission_method=["11", "12", "13", "81"],
    #     return_expectations={
    #         "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
    #         "rate": "uniform",
    #         "incidence": 0.05,
    #     },
    # ),
    # discharged_planned_0_date=patients.admitted_to_hospital(
    #     returning="date_discharged",
    #     on_or_before="index_date - 1 day",
    #     with_admission_method=["11", "12", "13", "81"],
    #     date_format="YYYY-MM-DD",
    #     find_first_match_in_period=True,
    #     return_expectations={
    #         "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
    #         "rate": "uniform",
    #         "incidence": 0.05,
    #     },
    # ),
    # **admitted_date_X(
    #     name = "discharged_planned",
    #     index_name = "admitted_planned",
    #     index_date = "index_date",
    #     n = 5,
    #     returning="date_discharged",
    #     with_admission_method=["11", "12", "13", "81"],
    #     return_expectations={
    #         "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
    #         "rate": "uniform",
    #         "incidence": 0.05,
    #     },
    # ),
    

    
    # covid death
    coviddeath_date=patients.with_these_codes_on_death_certificate(
        covid_codes,
        returning="date_of_death",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2021-06-01", "latest" : "2021-08-01"},
            "rate": "uniform",
            "incidence": 0.02
        },
    ),
    # any death
    death_date=patients.died_from_any_cause(
        returning="date_of_death",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2021-06-01", "latest" : "2021-08-01"},
            "rate": "uniform",
            "incidence": 0.02
        },
    ),
    
)


############################################################
######### CLINICAL CO-MORBIDITIES ##########################
############################################################

clinical_variables = dict(
    
    
    # https://github.com/opensafely/risk-factors-research/issues/51
    bmi=patients.categorised_as(
        {
            "Not obese": "DEFAULT",
            "Obese I (30-34.9)": """ bmi_value >= 30 AND bmi_value < 35""",
            "Obese II (35-39.9)": """ bmi_value >= 35 AND bmi_value < 40""",
            "Obese III (40+)": """ bmi_value >= 40 AND bmi_value < 100""",
            # set maximum to avoid any impossibly extreme values being classified as obese
        },
        bmi_value=patients.most_recent_bmi(
            on_or_after="2015-12-01",
            minimum_age_at_measurement=16
            ),
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "Not obese": 0.7,
                    "Obese I (30-34.9)": 0.1,
                    "Obese II (35-39.9)": 0.1,
                    "Obese III (40+)": 0.1,
                }
            },
        },
    ),

    chronic_cardiac_disease=patients.with_these_clinical_events(
        chronic_cardiac_disease_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05},
    ),
    heart_failure=patients.with_these_clinical_events(
        heart_failure_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05},
    ),
    other_heart_disease=patients.with_these_clinical_events(
        other_heart_disease_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05},
    ),

    diabetes=patients.with_these_clinical_events(
        diabetes_codes,
        returning="binary_flag",
        find_last_match_in_period=True,
        on_or_before="index_date - 1 day",
        return_expectations={"incidence": 0.05},
    ),
    dialysis=patients.with_these_clinical_events(
        dialysis_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    chronic_liver_disease=patients.with_these_clinical_events(
        chronic_liver_disease_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05},
    ),
    
    current_copd=patients.with_these_clinical_events(
        current_copd_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05},
    ),
    LD_incl_DS_and_CP=patients.with_these_clinical_events(
        learning_disability_including_downs_syndrome_and_cerebral_palsy_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    cystic_fibrosis=patients.with_these_clinical_events(
        cystic_fibrosis_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    other_resp_conditions=patients.with_these_clinical_events(
        other_respiratory_conditions_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05},
    ),
    
    
    lung_cancer=patients.with_these_clinical_events(
        lung_cancer_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    haematological_cancer=patients.with_these_clinical_events(
        haematological_cancer_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    cancer_excl_lung_and_haem=patients.with_these_clinical_events(
        cancer_excluding_lung_and_haematological_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    
    chemo_or_radio=patients.with_these_clinical_events(
        chemotherapy_or_radiotherapy_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    solid_organ_transplantation=patients.with_these_clinical_events(
        solid_organ_transplantation_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    bone_marrow_transplant=patients.with_these_clinical_events(
        bone_marrow_transplant_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    
    sickle_cell_disease=patients.with_these_clinical_events(
        sickle_cell_disease_codes,
        on_or_before="index_date",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    permanant_immunosuppression=patients.with_these_clinical_events(
        permanent_immunosuppression_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    temporary_immunosuppression=patients.with_these_clinical_events(
        temporary_immunosuppression_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    asplenia=patients.with_these_clinical_events(
        asplenia_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    dmards=patients.with_these_medications(
        dmards_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    dementia=patients.with_these_clinical_events(
        dementia_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),
    other_neuro_conditions=patients.with_these_clinical_events(
        other_neuro_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05},
    ),
    
    psychosis_schiz_bipolar=patients.with_these_clinical_events(
        psychosis_schizophrenia_bipolar_affective_disease_codes,
        on_or_before="index_date - 1 day",
        returning="binary_flag",
        return_expectations={"incidence": 0.05, },
    ),

    flu_vaccine=patients.satisfying(
        """
        flu_vaccine_tpp_table>0 OR
        flu_vaccine_med>0 OR
        flu_vaccine_clinical>0
        """,
        
        flu_vaccine_tpp_table=patients.with_tpp_vaccination_record(
            target_disease_matches="INFLUENZA",
            between=["2015-04-01", "2020-03-31"], 
            returning="binary_flag",
        ),
        
        flu_vaccine_med=patients.with_these_medications(
            flu_med_codes,
            between=["2015-04-01", "2020-03-31"], 
            returning="binary_flag",
        ),
        flu_vaccine_clinical=patients.with_these_clinical_events(
            flu_clinical_given_codes,
            ignore_days_where_these_codes_occur=flu_clinical_not_given_codes,
            between=["2015-04-01", "2020-03-31"], 
            returning="binary_flag",
        ),
        
        return_expectations={"incidence": 0.5, },
    ),
    
    efi = patients.with_these_decision_support_values(
        algorithm = "electronic_frailty_index",
        on_or_before = "2020-12-08", # hard-coded because there are no other dates available for efi
        find_last_match_in_period = True,
        returning="numeric_value",
        return_expectations={
            #"category": {"ratios": {0.1: 0.25, 0.15: 0.25, 0.30: 0.25, 0.5: 0.25}},
            "float": {"distribution": "normal", "mean": 0.20, "stddev": 0.09},
            "incidence": 0.99
        },
    ),

    endoflife = patients.satisfying(
        """
        midazolam OR
        endoflife_coding
        """,
        
        midazolam = patients.with_these_medications(
            midazolam_codes,
            returning="binary_flag",
            on_or_before = "index_date - 1 day",
        ),
    
        endoflife_coding = patients.with_these_clinical_events(
            eol_codes,
            returning="binary_flag",
            on_or_before = "index_date - 1 day",
            find_last_match_in_period = True,
        ),
        
        return_expectations={"incidence": 0.001},
    
    ),
    
    ### PRIMIS CODELIST DERIVED CLINICAL VARIABLES     ###

    shielded_ever = patients.with_these_clinical_events(
            shield_codes,
            returning="binary_flag",
            on_or_before = "index_date - 1 day",
            find_last_match_in_period = True,
        ),

    shielded = patients.satisfying(
        """severely_clinically_vulnerable AND NOT less_vulnerable""", 

        ### SHIELDED GROUP - first flag all patients with "high risk" codes
        severely_clinically_vulnerable=patients.with_these_clinical_events(
            shield_codes,
            returning="binary_flag",
            on_or_before = "index_date - 1 day",
            find_last_match_in_period = True,
        ),

        # find date at which the high risk code was added
        date_severely_clinically_vulnerable=patients.date_of(
            "severely_clinically_vulnerable", 
            date_format="YYYY-MM-DD",   
        ),

        ### NOT SHIELDED GROUP (medium and low risk) - only flag if later than 'shielded'
        less_vulnerable=patients.with_these_clinical_events(
            nonshield_codes, 
            between=["date_severely_clinically_vulnerable + 1 day", "index_date - 1 day"],
        ),
        
        return_expectations={"incidence": 0.01},
    ),
    
)
