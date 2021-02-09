
from cohortextractor import (
    StudyDefinition,
    patients,
    codelist_from_csv,
    codelist,
    filter_codes_by_category,
    combine_codelists,
)

# Important Dates
campaign_start = "2020-12-07" # change this if you need to
latest_date = "2021-01-13" 

# Import Codelists
from codelists import *


# Specifiy study defeinition
study = StudyDefinition(
    # Configure the expectations framework
    default_expectations={
        "date": {"earliest": "1970-01-01", "latest": latest_date},
        "rate": "uniform",
        "incidence": 0.2,
    },
        
    index_date = "2020-12-01",
    # This line defines the study population
    population=patients.satisfying(
        """
        registered
        AND
        age >= 80
        AND
        (sex = "M" OR sex = "F")
        AND
        NOT has_died
        AND 
        NOT care_home
        AND
        NOT prior_positive_test_date
        """,
        registered=patients.registered_as_of(
            "index_date",  # Currently 1 Dec 2020 day but can change to before vaccination campaign starts
        ),
        has_died=patients.died_from_any_cause(
            on_or_before="index_date- 1 day",
            returning="binary_flag",
        ),
    ),


    # https://github.com/opensafely/risk-factors-research/issues/49
    age=patients.age_as_of(
        "2020-02-01",
        return_expectations={
            "rate": "universal",
            "int": {"distribution": "population_ages"},
        },
    ),
    
    # https://github.com/opensafely/risk-factors-research/issues/46
    sex=patients.sex(
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {"M": 0.49, "F": 0.51}},
        }
    ),

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


    has_follow_up_previous_year=patients.registered_with_one_practice_between(
        start_date="index_date - 1 year",
        end_date="index_date",
        return_expectations={"incidence": 0.95},
    ),

    registered_at_latest=patients.registered_as_of(
        reference_date=latest_date,
        return_expectations={"incidence": 0.95},
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

    # ETHNICITY IN 6 CATEGORIES
    # ethnicity=patients.with_these_clinical_events(
    #     ethnicity_codes,
    #     returning="category",
    #     find_last_match_in_period=True,
    #     include_date_of_match=False,
    #     return_expectations={
    #         "category": {"ratios": {"1": 0.2, "2": 0.2, "3": 0.2, "4": 0.2, "5": 0.2}},
    #         "incidence": 0.75,
    #     },
    # ),

    ################################################
    ###### PRACTICE AND PATIENT ADDRESS VARIABLES ##
    ################################################
    # practice pseudo id
    practice_id=patients.registered_practice_as_of(
        "index_date",  # day before vaccine campaign start
        returning="pseudo_id",
        return_expectations={
            "int": {"distribution": "normal", "mean": 1000, "stddev": 100},
            "incidence": 1,
        },
    ),

    # stp is an NHS administration region based on geography
    stp=patients.registered_practice_as_of(
        "index_date",
        returning="stp_code",
        return_expectations={
            "rate": "universal",
            "category": {
                "ratios": {
                    "STP1": 0.1,
                    "STP2": 0.1,
                    "STP3": 0.1,
                    "STP4": 0.1,
                    "STP5": 0.1,
                    "STP6": 0.1,
                    "STP7": 0.1,
                    "STP8": 0.1,
                    "STP9": 0.1,
                    "STP10": 0.1,
                }
            },
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
                    "South East": 0.2,
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
            "5": """index_of_multiple_deprivation >= 32844*4/5 AND index_of_multiple_deprivation < 32844""",
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
                    "0": 0.05,
                    "1": 0.19,
                    "2": 0.19,
                    "3": 0.19,
                    "4": 0.19,
                    "5": 0.19,
                }
            },
        },
    ),

    # CAREHOME STATUS
    care_home_type=patients.care_home_status_as_of(
        "index_date",
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
            "rate": "universal",
            "category": {"ratios": {"Carehome": 0.05, "Nursinghome": 0.05, "Mixed": 0.05, "": 0.85, }, },
        },
    ),

    # simple care home flag
    care_home=patients.satisfying(
        """care_home_type""",
        return_expectations={
            "rate": "universal",
            "category": {"ratios": {1: 0.15, 0: 0.85, }},
        },
    ),

    ###############################################################################
    # COVID VACCINATION
    ###############################################################################
    # any COVID vaccination (first dose)
    covid_vax_1_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after="index_date",  # check all december to date
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
    # SECOND DOSE COVID VACCINATION - any type
    covid_vax_2_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after="covid_vax_1_date + 1 day",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-29",  # first reported second dose administered on the 29/12
                "latest": "2021-01-31",
            }
        },
    ),
    # THIRD DOSE COVID VACCINATION - any type
    covid_vax_3_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after="covid_vax_2_date + 1 day",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-29",  # first reported second dose administered on the 29/12
                "latest": "2021-01-31",
            }
        },
    ),
    # 4th DOSE COVID VACCINATION - any type
    covid_vax_4_date=patients.with_tpp_vaccination_record(
        target_disease_matches="SARS-2 CORONAVIRUS",
        on_or_after="covid_vax_3_date + 1 day",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2020-12-29",  # first reported second dose administered on the 29/12
                "latest": "2021-01-31",
            }
        },
    ),
    
    
    
    # COVID VACCINATION TYPE = Pfizer BioNTech - first record of a pfizer vaccine 
       # NB *** may be patient's first COVID vaccine dose or their second if mixed types are given ***
    covid_vax_pfizer_1_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vac BNT162b2 30mcg/0.3ml conc for susp for inj multidose vials (Pfizer-BioNTech)",
        on_or_after="index_date",  # check all december to date
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

    # SECOND DOSE COVID VACCINATION, TYPE = Pfizer (after patient's first dose of same vaccine type)
    covid_vax_pfizer_2_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vac BNT162b2 30mcg/0.3ml conc for susp for inj multidose vials (Pfizer-BioNTech)",
        on_or_after="covid_vax_pfizer_1_date + 1 day",
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
    
    # THIRD DOSE COVID VACCINATION, TYPE = Pfizer (after patient's second dose of same vaccine type)
    covid_vax_pfizer_3_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vac BNT162b2 30mcg/0.3ml conc for susp for inj multidose vials (Pfizer-BioNTech)",
        on_or_after="covid_vax_pfizer_2_date + 1 day",
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
    
    # 4th DOSE COVID VACCINATION, TYPE = Pfizer (after patient's second dose of same vaccine type)
    covid_vax_pfizer_4_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 mRNA Vac BNT162b2 30mcg/0.3ml conc for susp for inj multidose vials (Pfizer-BioNTech)",
        on_or_after="covid_vax_pfizer_3_date + 1 day",
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



    # COVID VACCINATION TYPE = Oxford AZ - first record of an Oxford AZ vaccine 
        # NB *** may be patient's first COVID vaccine dose or their second if mixed types are given ***
    covid_vax_az_1_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="index_date",  # check all december to date
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

    # SECOND DOSE COVID VACCINATION, TYPE = Oxford AZ
    covid_vax_az_2_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="covid_vax_az_1_date + 1 day",
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

    # THIRD DOSE COVID VACCINATION, TYPE = Oxford AZ
    covid_vax_az_3_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="covid_vax_az_2_date + 1 day",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-03-02",  
                "latest": "2021-04-01",
            }
        },
    ),
    
    # 4th DOSE COVID VACCINATION, TYPE = Oxford AZ
    covid_vax_az_4_date=patients.with_tpp_vaccination_record(
        product_name_matches="COVID-19 Vac AstraZeneca (ChAdOx1 S recomb) 5x10000000000 viral particles/0.5ml dose sol for inj MDV",
        on_or_after="covid_vax_az_3_date + 1 day",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {
                "earliest": "2021-04-02",  
                "latest": "2021-05-01",
            }
        },
    ),

    ################################################
    ############ pre-vaccine events ################
    ################################################
    # FIRST EVER SGSS POSITIVE
    prior_positive_test_date=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        returning="date",
        date_format="YYYY-MM-DD",
        on_or_before="index_date - 1 day",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-02-01"},
            "rate": "exponential_increase",
        },
    ),
    # FIRST EVER PRIMARY CARE CASE IDENTIFICATION
    prior_primary_care_covid_case_date=patients.with_these_clinical_events(
        combine_codelists(
            covid_primary_care_code,
            covid_primary_care_positive_test,
            covid_primary_care_sequalae,
        ),
        returning="date",
        date_format="YYYY-MM-DD",
        on_or_before="index_date - 1 day",
        find_first_match_in_period=True,
        return_expectations={"rate": "exponential_increase"},
    ),
    
    
    ################################################
    ############ hospital admissions################
    ################################################
    
    admitted_1_date=patients.admitted_to_hospital(
        returning="date_admitted",
        on_or_after="index_date",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    discharged_1_date=patients.admitted_to_hospital(
        returning="date_discharged",
        on_or_after="index_date",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    admitted_2_date=patients.admitted_to_hospital(
        returning="date_admitted",
        on_or_after="admitted_1_date + 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    discharged_2_date=patients.admitted_to_hospital(
        returning="date_discharged",
        on_or_after="admitted_1_date + 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    admitted_3_date=patients.admitted_to_hospital(
        returning="date_admitted",
        on_or_after="admitted_2_date + 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    discharged_3_date=patients.admitted_to_hospital(
        returning="date_discharged",
        on_or_after="admitted_2_date + 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    

    admitted_4_date=patients.admitted_to_hospital(
        returning="date_admitted",
        on_or_after="admitted_3_date + 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    discharged_4_date=patients.admitted_to_hospital(
        returning="date_discharged",
        on_or_after="admitted_3_date + 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    

    admitted_5_date=patients.admitted_to_hospital(
        returning="date_admitted",
        on_or_after="admitted_4_date + 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    discharged_5_date=patients.admitted_to_hospital(
        returning="date_discharged",
        on_or_after="admitted_4_date + 1 day",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2020-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    
    
    
    ################################################
    ############ post-vaccine events ###############
    ################################################
    
    # POST VACCINE SGSS POSITIVE    
    post_vax_positive_test_date=patients.with_test_result_in_sgss(
        pathogen="SARS-CoV-2",
        test_result="positive",
        on_or_after="covid_vax_1_date",
        find_first_match_in_period=True,
        returning="date",
        date_format="YYYY-MM-DD",
        return_expectations={
            "date": {"earliest": "2021-01-01"},
            "rate": "exponential_increase",
        },
    ),
    # POST VACCINE PRIMARY CARE CASE IDENTIFICATION
    post_vax_primary_care_covid_case_date=patients.with_these_clinical_events(
        combine_codelists(
            covid_primary_care_code,
            covid_primary_care_positive_test,
            covid_primary_care_sequalae,
        ),
        returning="date",
        find_last_match_in_period=True,
        date_format="YYYY-MM-DD",
        on_or_after="covid_vax_1_date",
        return_expectations={
            "date": {"earliest": "2021-04-01", "latest" : "2021-05-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    # POST VACCINE COVID-RELATED HOSPITAL ADMISSION
    post_vax_admitted_date=patients.admitted_to_hospital(
        returning="date_admitted",
        with_these_diagnoses=covid_codes,
        on_or_after="covid_vax_1_date",
        date_format="YYYY-MM-DD",
        find_first_match_in_period=True,
        return_expectations={
            "date": {"earliest": "2021-05-01", "latest" : "2021-06-01"},
            "rate": "uniform",
            "incidence": 0.05,
        },
    ),
    # COVID-RELATED DEATH
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
    # ALL-CAUSE DEATH
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
