---
title: "Vaccine effectiveness report"
output:
  html_document:
    code_folding: hide
    keep_md: yes
  md_document:
    variant: gfm
  pdf_document: default
---



## Vaccine effectiveness data in OpenSAFELY-TPP data

This document reports the frequency of covid-related outcomes in TPP-registered patients who have received a vaccine for SARS-CoV-2. 
This is a technical document to help inform the design of vaccine effectiveness Studies in OpenSAFELY. Only patients who have received the vaccine are included, and **no inferences should be made about the comparative effectiveness between vaccinated and unvaccinated patient, between vaccine brands, or across different patient groups**. 

Measured outcomes include:

* Positive Covid case identification in primary care, using the following clinical codes:
  * [probable covid](https://codelists.opensafely.org/codelist/opensafely/covid-identification-in-primary-care-probable-covid-clinical-code/2020-07-16)
  * [positive covid test](https://codelists.opensafely.org/codelist/opensafely/covid-identification-in-primary-care-probable-covid-positive-test/2020-07-16/)
  * [covid sequelae](https://codelists.opensafely.org/codelist/opensafely/covid-identification-in-primary-care-probable-covid-sequelae/2020-07-16/)
* Positive SARS-CoV-2 test, as reported via the Second Generation Surveillance System (SGSS)
* Covid-related hospital admission, where [Covid](https://codelists.opensafely.org/codelist/opensafely/covid-identification/2020-06-03/) is listed as a reason for admission.
* Covid-related death, where [Covid](https://codelists.opensafely.org/codelist/opensafely/covid-identification/2020-06-03/) is mentioned anywhere on the death certificate.
* All-cause death.

### Data notes

The code and data for this report can be found at the [covid-vaccine-effectiveness-research GitHub repository](https://github.com/opensafely/covid-vaccine-effectiveness-research). 

The dataset used for this report was created using the study definition `/analysis/study_definition.py`, using codelists referenced in `/codelists/codelists.txt`. It was extracted from the OpenSAFELY-TPP data extracted on 2021-01-21, with event dates censored on (occurring no later than) 2021-01-13.

To minimise data disclosivity in frequency tables, counts are rounded to the nearest 7 and percentages are derived from these rounded counts.















## Summary

As of 2021-01-13, there were 2590143 TPP-registered patients who had received at least one vaccine dose. Of these, 0 received the Pfizer-BioNTech (P-B) vaccine and 0 received the Oxford-AstraZenica (Ox-AZ) vaccine. Brand is unknown for the remaining 2590143 patients. 

## Summaries by patient characteristics

The tables below show, for each characteristic:

* Vaccine type, including those who have received both vaccine types
* 7-day post-vaccination event rates
* Cumulative post-vaccination event rates over time
* Estimated hazard rates over time.


### Sex

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#reeeztghjo .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#reeeztghjo .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#reeeztghjo .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#reeeztghjo .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#reeeztghjo .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#reeeztghjo .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#reeeztghjo .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#reeeztghjo .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#reeeztghjo .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#reeeztghjo .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#reeeztghjo .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#reeeztghjo .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#reeeztghjo .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#reeeztghjo .gt_from_md > :first-child {
  margin-top: 0;
}

#reeeztghjo .gt_from_md > :last-child {
  margin-bottom: 0;
}

#reeeztghjo .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#reeeztghjo .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#reeeztghjo .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#reeeztghjo .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#reeeztghjo .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#reeeztghjo .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#reeeztghjo .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#reeeztghjo .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#reeeztghjo .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#reeeztghjo .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#reeeztghjo .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#reeeztghjo .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#reeeztghjo .gt_left {
  text-align: left;
}

#reeeztghjo .gt_center {
  text-align: center;
}

#reeeztghjo .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#reeeztghjo .gt_font_normal {
  font-weight: normal;
}

#reeeztghjo .gt_font_bold {
  font-weight: bold;
}

#reeeztghjo .gt_font_italic {
  font-style: italic;
}

#reeeztghjo .gt_super {
  font-size: 65%;
}

#reeeztghjo .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="reeeztghjo" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="7" class="gt_heading gt_title gt_font_normal" style>Vaccine type</th>
    </tr>
    <tr>
      <th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">Sex</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Ox-AZ</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">P-B</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Unknown</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">Female</td>
      <td class="gt_row gt_center">469938</td>
      <td class="gt_row gt_right">61.4&percnt;</td>
      <td class="gt_row gt_center">1153866</td>
      <td class="gt_row gt_right">63.3&percnt;</td>
      <td class="gt_row gt_center">763</td>
      <td class="gt_row gt_right">65.2&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Male</td>
      <td class="gt_row gt_center">295456</td>
      <td class="gt_row gt_right">38.6&percnt;</td>
      <td class="gt_row gt_center">669704</td>
      <td class="gt_row gt_right">36.7&percnt;</td>
      <td class="gt_row gt_center">406</td>
      <td class="gt_row gt_right">34.8&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="7">- indicates redacted values</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;


<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#iajsisxsxj .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#iajsisxsxj .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#iajsisxsxj .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#iajsisxsxj .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#iajsisxsxj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#iajsisxsxj .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#iajsisxsxj .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#iajsisxsxj .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#iajsisxsxj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#iajsisxsxj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#iajsisxsxj .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#iajsisxsxj .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#iajsisxsxj .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#iajsisxsxj .gt_from_md > :first-child {
  margin-top: 0;
}

#iajsisxsxj .gt_from_md > :last-child {
  margin-bottom: 0;
}

#iajsisxsxj .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#iajsisxsxj .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#iajsisxsxj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#iajsisxsxj .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#iajsisxsxj .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#iajsisxsxj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#iajsisxsxj .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#iajsisxsxj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#iajsisxsxj .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#iajsisxsxj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#iajsisxsxj .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#iajsisxsxj .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#iajsisxsxj .gt_left {
  text-align: left;
}

#iajsisxsxj .gt_center {
  text-align: center;
}

#iajsisxsxj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#iajsisxsxj .gt_font_normal {
  font-weight: normal;
}

#iajsisxsxj .gt_font_bold {
  font-weight: bold;
}

#iajsisxsxj .gt_font_italic {
  font-style: italic;
}

#iajsisxsxj .gt_super {
  font-size: 65%;
}

#iajsisxsxj .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="iajsisxsxj" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="12" class="gt_heading gt_title gt_font_normal" style>Post-vaccination event rates at 14 days amongst those with sufficient follow-up</th>
    </tr>
    <tr>
      <th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">Sex</th>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">n</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">primary care case</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">positive test</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related admission</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related all-cause death</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">all-cause death</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">Female</td>
      <td class="gt_row gt_center">241136</td>
      <td class="gt_row gt_center">189</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">2408</td>
      <td class="gt_row gt_right">1.0&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">35</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">126</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Male</td>
      <td class="gt_row gt_center">154966</td>
      <td class="gt_row gt_center">126</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">1022</td>
      <td class="gt_row gt_right">0.7&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">28</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">140</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="12">Numbers are rounded to the nearest 7</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;

![](../released_outputs/output/tte/figures/plot_patch_sex.svg "outcomes by Sex"){width="80%"}




### Age

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#gzqryzxysh .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#gzqryzxysh .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#gzqryzxysh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#gzqryzxysh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#gzqryzxysh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#gzqryzxysh .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#gzqryzxysh .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#gzqryzxysh .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#gzqryzxysh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#gzqryzxysh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#gzqryzxysh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#gzqryzxysh .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#gzqryzxysh .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#gzqryzxysh .gt_from_md > :first-child {
  margin-top: 0;
}

#gzqryzxysh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#gzqryzxysh .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#gzqryzxysh .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#gzqryzxysh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#gzqryzxysh .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#gzqryzxysh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#gzqryzxysh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#gzqryzxysh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#gzqryzxysh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#gzqryzxysh .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#gzqryzxysh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#gzqryzxysh .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#gzqryzxysh .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#gzqryzxysh .gt_left {
  text-align: left;
}

#gzqryzxysh .gt_center {
  text-align: center;
}

#gzqryzxysh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#gzqryzxysh .gt_font_normal {
  font-weight: normal;
}

#gzqryzxysh .gt_font_bold {
  font-weight: bold;
}

#gzqryzxysh .gt_font_italic {
  font-style: italic;
}

#gzqryzxysh .gt_super {
  font-size: 65%;
}

#gzqryzxysh .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="gzqryzxysh" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="7" class="gt_heading gt_title gt_font_normal" style>Vaccine type</th>
    </tr>
    <tr>
      <th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">Age</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Ox-AZ</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">P-B</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Unknown</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">18-49</td>
      <td class="gt_row gt_center">115696</td>
      <td class="gt_row gt_right">15.1&percnt;</td>
      <td class="gt_row gt_center">443149</td>
      <td class="gt_row gt_right">24.3&percnt;</td>
      <td class="gt_row gt_center">210</td>
      <td class="gt_row gt_right">18.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">50s</td>
      <td class="gt_row gt_center">60739</td>
      <td class="gt_row gt_right">7.9&percnt;</td>
      <td class="gt_row gt_center">208376</td>
      <td class="gt_row gt_right">11.4&percnt;</td>
      <td class="gt_row gt_center">112</td>
      <td class="gt_row gt_right">9.6&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">60s</td>
      <td class="gt_row gt_center">54824</td>
      <td class="gt_row gt_right">7.2&percnt;</td>
      <td class="gt_row gt_center">111790</td>
      <td class="gt_row gt_right">6.1&percnt;</td>
      <td class="gt_row gt_center">56</td>
      <td class="gt_row gt_right">4.7&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">70s</td>
      <td class="gt_row gt_center">331744</td>
      <td class="gt_row gt_right">43.3&percnt;</td>
      <td class="gt_row gt_center">385042</td>
      <td class="gt_row gt_right">21.1&percnt;</td>
      <td class="gt_row gt_center">273</td>
      <td class="gt_row gt_right">23.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">80+</td>
      <td class="gt_row gt_center">202391</td>
      <td class="gt_row gt_right">26.4&percnt;</td>
      <td class="gt_row gt_center">675213</td>
      <td class="gt_row gt_right">37.0&percnt;</td>
      <td class="gt_row gt_center">525</td>
      <td class="gt_row gt_right">44.5&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="7">- indicates redacted values</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;


<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ddddnkmvzv .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ddddnkmvzv .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ddddnkmvzv .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ddddnkmvzv .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ddddnkmvzv .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ddddnkmvzv .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ddddnkmvzv .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ddddnkmvzv .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ddddnkmvzv .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ddddnkmvzv .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ddddnkmvzv .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ddddnkmvzv .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#ddddnkmvzv .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ddddnkmvzv .gt_from_md > :first-child {
  margin-top: 0;
}

#ddddnkmvzv .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ddddnkmvzv .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ddddnkmvzv .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#ddddnkmvzv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ddddnkmvzv .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ddddnkmvzv .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ddddnkmvzv .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ddddnkmvzv .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ddddnkmvzv .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ddddnkmvzv .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ddddnkmvzv .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ddddnkmvzv .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ddddnkmvzv .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ddddnkmvzv .gt_left {
  text-align: left;
}

#ddddnkmvzv .gt_center {
  text-align: center;
}

#ddddnkmvzv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ddddnkmvzv .gt_font_normal {
  font-weight: normal;
}

#ddddnkmvzv .gt_font_bold {
  font-weight: bold;
}

#ddddnkmvzv .gt_font_italic {
  font-style: italic;
}

#ddddnkmvzv .gt_super {
  font-size: 65%;
}

#ddddnkmvzv .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ddddnkmvzv" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="12" class="gt_heading gt_title gt_font_normal" style>Post-vaccination event rates at 14 days amongst those with sufficient follow-up</th>
    </tr>
    <tr>
      <th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">Age</th>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">n</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">primary care case</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">positive test</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related admission</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related all-cause death</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">all-cause death</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">18-49</td>
      <td class="gt_row gt_center">72478</td>
      <td class="gt_row gt_center">56</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">1456</td>
      <td class="gt_row gt_right">2.0&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">50s</td>
      <td class="gt_row gt_center">38934</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">665</td>
      <td class="gt_row gt_right">1.7&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">60s</td>
      <td class="gt_row gt_center">17724</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">287</td>
      <td class="gt_row gt_right">1.6&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">70s</td>
      <td class="gt_row gt_center">33061</td>
      <td class="gt_row gt_center">28</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">189</td>
      <td class="gt_row gt_right">0.6&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">35</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">80+</td>
      <td class="gt_row gt_center">233905</td>
      <td class="gt_row gt_center">182</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">847</td>
      <td class="gt_row gt_right">0.4&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">49</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">224</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="12">Numbers are rounded to the nearest 7</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;

![](../released_outputs/output/tte/figures/plot_patch_ageband.svg "outcomes by Age"){width="80%"}




### Ethnicity

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ojpconqczh .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ojpconqczh .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ojpconqczh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ojpconqczh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ojpconqczh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ojpconqczh .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ojpconqczh .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ojpconqczh .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ojpconqczh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ojpconqczh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ojpconqczh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ojpconqczh .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#ojpconqczh .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ojpconqczh .gt_from_md > :first-child {
  margin-top: 0;
}

#ojpconqczh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ojpconqczh .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ojpconqczh .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#ojpconqczh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ojpconqczh .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ojpconqczh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ojpconqczh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ojpconqczh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ojpconqczh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ojpconqczh .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ojpconqczh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ojpconqczh .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ojpconqczh .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ojpconqczh .gt_left {
  text-align: left;
}

#ojpconqczh .gt_center {
  text-align: center;
}

#ojpconqczh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ojpconqczh .gt_font_normal {
  font-weight: normal;
}

#ojpconqczh .gt_font_bold {
  font-weight: bold;
}

#ojpconqczh .gt_font_italic {
  font-style: italic;
}

#ojpconqczh .gt_super {
  font-size: 65%;
}

#ojpconqczh .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ojpconqczh" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="7" class="gt_heading gt_title gt_font_normal" style>Vaccine type</th>
    </tr>
    <tr>
      <th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">Ethnicity</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Ox-AZ</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">P-B</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Unknown</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">Black</td>
      <td class="gt_row gt_center">8617</td>
      <td class="gt_row gt_right">1.1&percnt;</td>
      <td class="gt_row gt_center">20643</td>
      <td class="gt_row gt_right">1.1&percnt;</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">1.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Mixed</td>
      <td class="gt_row gt_center">3402</td>
      <td class="gt_row gt_right">0.4&percnt;</td>
      <td class="gt_row gt_center">10654</td>
      <td class="gt_row gt_right">0.6&percnt;</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.9&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">South Asian</td>
      <td class="gt_row gt_center">22757</td>
      <td class="gt_row gt_right">3.0&percnt;</td>
      <td class="gt_row gt_center">79814</td>
      <td class="gt_row gt_right">4.4&percnt;</td>
      <td class="gt_row gt_center">49</td>
      <td class="gt_row gt_right">4.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">White</td>
      <td class="gt_row gt_center">546007</td>
      <td class="gt_row gt_right">71.3&percnt;</td>
      <td class="gt_row gt_center">1257683</td>
      <td class="gt_row gt_right">69.0&percnt;</td>
      <td class="gt_row gt_center">812</td>
      <td class="gt_row gt_right">68.9&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Other</td>
      <td class="gt_row gt_center">5628</td>
      <td class="gt_row gt_right">0.7&percnt;</td>
      <td class="gt_row gt_center">17374</td>
      <td class="gt_row gt_right">1.0&percnt;</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.9&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">(missing)</td>
      <td class="gt_row gt_center">178983</td>
      <td class="gt_row gt_right">23.4&percnt;</td>
      <td class="gt_row gt_center">437402</td>
      <td class="gt_row gt_right">24.0&percnt;</td>
      <td class="gt_row gt_center">287</td>
      <td class="gt_row gt_right">24.2&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="7">- indicates redacted values</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;


<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#qdygyuqond .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#qdygyuqond .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qdygyuqond .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qdygyuqond .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qdygyuqond .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qdygyuqond .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qdygyuqond .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#qdygyuqond .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#qdygyuqond .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qdygyuqond .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qdygyuqond .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#qdygyuqond .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#qdygyuqond .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#qdygyuqond .gt_from_md > :first-child {
  margin-top: 0;
}

#qdygyuqond .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qdygyuqond .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#qdygyuqond .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#qdygyuqond .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qdygyuqond .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#qdygyuqond .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qdygyuqond .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qdygyuqond .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qdygyuqond .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qdygyuqond .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qdygyuqond .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#qdygyuqond .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qdygyuqond .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#qdygyuqond .gt_left {
  text-align: left;
}

#qdygyuqond .gt_center {
  text-align: center;
}

#qdygyuqond .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qdygyuqond .gt_font_normal {
  font-weight: normal;
}

#qdygyuqond .gt_font_bold {
  font-weight: bold;
}

#qdygyuqond .gt_font_italic {
  font-style: italic;
}

#qdygyuqond .gt_super {
  font-size: 65%;
}

#qdygyuqond .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="qdygyuqond" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="12" class="gt_heading gt_title gt_font_normal" style>Post-vaccination event rates at 14 days amongst those with sufficient follow-up</th>
    </tr>
    <tr>
      <th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">Ethnicity</th>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">n</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">primary care case</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">positive test</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related admission</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related all-cause death</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">all-cause death</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">Black</td>
      <td class="gt_row gt_center">3199</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">56</td>
      <td class="gt_row gt_right">1.7&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Mixed</td>
      <td class="gt_row gt_center">1967</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">28</td>
      <td class="gt_row gt_right">1.5&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">South Asian</td>
      <td class="gt_row gt_center">17437</td>
      <td class="gt_row gt_center">21</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">301</td>
      <td class="gt_row gt_right">1.7&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">White</td>
      <td class="gt_row gt_center">271313</td>
      <td class="gt_row gt_center">217</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">2177</td>
      <td class="gt_row gt_right">0.8&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">189</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Other</td>
      <td class="gt_row gt_center">3542</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">56</td>
      <td class="gt_row gt_right">1.5&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">(missing)</td>
      <td class="gt_row gt_center">98644</td>
      <td class="gt_row gt_center">77</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">826</td>
      <td class="gt_row gt_right">0.8&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">21</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">77</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="12">Numbers are rounded to the nearest 7</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;

![](../released_outputs/output/tte/figures/plot_patch_ethnicity.svg "outcomes by Ethnicity"){width="80%"}


### Index of Multiple Deprivation (IMD)


<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#pysvgcsutj .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#pysvgcsutj .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pysvgcsutj .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#pysvgcsutj .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#pysvgcsutj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pysvgcsutj .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pysvgcsutj .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#pysvgcsutj .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#pysvgcsutj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#pysvgcsutj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#pysvgcsutj .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#pysvgcsutj .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#pysvgcsutj .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#pysvgcsutj .gt_from_md > :first-child {
  margin-top: 0;
}

#pysvgcsutj .gt_from_md > :last-child {
  margin-bottom: 0;
}

#pysvgcsutj .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#pysvgcsutj .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#pysvgcsutj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pysvgcsutj .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#pysvgcsutj .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pysvgcsutj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#pysvgcsutj .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#pysvgcsutj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pysvgcsutj .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pysvgcsutj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#pysvgcsutj .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pysvgcsutj .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#pysvgcsutj .gt_left {
  text-align: left;
}

#pysvgcsutj .gt_center {
  text-align: center;
}

#pysvgcsutj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#pysvgcsutj .gt_font_normal {
  font-weight: normal;
}

#pysvgcsutj .gt_font_bold {
  font-weight: bold;
}

#pysvgcsutj .gt_font_italic {
  font-style: italic;
}

#pysvgcsutj .gt_super {
  font-size: 65%;
}

#pysvgcsutj .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="pysvgcsutj" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="7" class="gt_heading gt_title gt_font_normal" style>Vaccine type</th>
    </tr>
    <tr>
      <th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">IMD</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Ox-AZ</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">P-B</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Unknown</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">1 least deprived</td>
      <td class="gt_row gt_center">115248</td>
      <td class="gt_row gt_right">15.1&percnt;</td>
      <td class="gt_row gt_center">246701</td>
      <td class="gt_row gt_right">13.5&percnt;</td>
      <td class="gt_row gt_center">210</td>
      <td class="gt_row gt_right">17.8&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">2</td>
      <td class="gt_row gt_center">134638</td>
      <td class="gt_row gt_right">17.6&percnt;</td>
      <td class="gt_row gt_center">317653</td>
      <td class="gt_row gt_right">17.4&percnt;</td>
      <td class="gt_row gt_center">203</td>
      <td class="gt_row gt_right">17.5&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">3</td>
      <td class="gt_row gt_center">167776</td>
      <td class="gt_row gt_right">21.9&percnt;</td>
      <td class="gt_row gt_center">396550</td>
      <td class="gt_row gt_right">21.7&percnt;</td>
      <td class="gt_row gt_center">210</td>
      <td class="gt_row gt_right">17.9&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">4</td>
      <td class="gt_row gt_center">168539</td>
      <td class="gt_row gt_right">22.0&percnt;</td>
      <td class="gt_row gt_center">414477</td>
      <td class="gt_row gt_right">22.7&percnt;</td>
      <td class="gt_row gt_center">196</td>
      <td class="gt_row gt_right">16.4&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">5 most deprived</td>
      <td class="gt_row gt_center">163821</td>
      <td class="gt_row gt_right">21.4&percnt;</td>
      <td class="gt_row gt_center">410018</td>
      <td class="gt_row gt_right">22.5&percnt;</td>
      <td class="gt_row gt_center">259</td>
      <td class="gt_row gt_right">21.8&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">(missing)</td>
      <td class="gt_row gt_center">15365</td>
      <td class="gt_row gt_right">2.0&percnt;</td>
      <td class="gt_row gt_center">38171</td>
      <td class="gt_row gt_right">2.1&percnt;</td>
      <td class="gt_row gt_center">98</td>
      <td class="gt_row gt_right">8.5&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="7">- indicates redacted values</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;


<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#hllianfpxy .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#hllianfpxy .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hllianfpxy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hllianfpxy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hllianfpxy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hllianfpxy .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hllianfpxy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hllianfpxy .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hllianfpxy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hllianfpxy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hllianfpxy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hllianfpxy .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#hllianfpxy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#hllianfpxy .gt_from_md > :first-child {
  margin-top: 0;
}

#hllianfpxy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hllianfpxy .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#hllianfpxy .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#hllianfpxy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hllianfpxy .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#hllianfpxy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hllianfpxy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#hllianfpxy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#hllianfpxy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hllianfpxy .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hllianfpxy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#hllianfpxy .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hllianfpxy .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#hllianfpxy .gt_left {
  text-align: left;
}

#hllianfpxy .gt_center {
  text-align: center;
}

#hllianfpxy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hllianfpxy .gt_font_normal {
  font-weight: normal;
}

#hllianfpxy .gt_font_bold {
  font-weight: bold;
}

#hllianfpxy .gt_font_italic {
  font-style: italic;
}

#hllianfpxy .gt_super {
  font-size: 65%;
}

#hllianfpxy .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="hllianfpxy" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="12" class="gt_heading gt_title gt_font_normal" style>Post-vaccination event rates at 14 days amongst those with sufficient follow-up</th>
    </tr>
    <tr>
      <th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">IMD</th>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">n</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">primary care case</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">positive test</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related admission</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related all-cause death</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">all-cause death</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">1 least deprived</td>
      <td class="gt_row gt_center">54047</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">546</td>
      <td class="gt_row gt_right">1.0&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">2</td>
      <td class="gt_row gt_center">67200</td>
      <td class="gt_row gt_center">70</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">644</td>
      <td class="gt_row gt_right">1.0&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">3</td>
      <td class="gt_row gt_center">83419</td>
      <td class="gt_row gt_center">77</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">763</td>
      <td class="gt_row gt_right">0.9&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">21</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">56</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">4</td>
      <td class="gt_row gt_center">90902</td>
      <td class="gt_row gt_center">77</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">742</td>
      <td class="gt_row gt_right">0.8&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">49</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">5 most deprived</td>
      <td class="gt_row gt_center">91672</td>
      <td class="gt_row gt_center">49</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">665</td>
      <td class="gt_row gt_right">0.7&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">63</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">(missing)</td>
      <td class="gt_row gt_center">8862</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">70</td>
      <td class="gt_row gt_right">0.8&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="12">Numbers are rounded to the nearest 7</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;

![](../released_outputs/output/tte/figures/plot_patch_imd.svg "outcomes by IMD"){width="80%"}



### Region

<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#oqkpdaubkr .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#oqkpdaubkr .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#oqkpdaubkr .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#oqkpdaubkr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#oqkpdaubkr .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#oqkpdaubkr .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#oqkpdaubkr .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#oqkpdaubkr .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#oqkpdaubkr .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#oqkpdaubkr .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#oqkpdaubkr .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#oqkpdaubkr .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#oqkpdaubkr .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#oqkpdaubkr .gt_from_md > :first-child {
  margin-top: 0;
}

#oqkpdaubkr .gt_from_md > :last-child {
  margin-bottom: 0;
}

#oqkpdaubkr .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#oqkpdaubkr .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#oqkpdaubkr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#oqkpdaubkr .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#oqkpdaubkr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#oqkpdaubkr .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#oqkpdaubkr .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#oqkpdaubkr .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#oqkpdaubkr .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#oqkpdaubkr .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#oqkpdaubkr .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#oqkpdaubkr .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#oqkpdaubkr .gt_left {
  text-align: left;
}

#oqkpdaubkr .gt_center {
  text-align: center;
}

#oqkpdaubkr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#oqkpdaubkr .gt_font_normal {
  font-weight: normal;
}

#oqkpdaubkr .gt_font_bold {
  font-weight: bold;
}

#oqkpdaubkr .gt_font_italic {
  font-style: italic;
}

#oqkpdaubkr .gt_super {
  font-size: 65%;
}

#oqkpdaubkr .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="oqkpdaubkr" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="7" class="gt_heading gt_title gt_font_normal" style>Vaccine type</th>
    </tr>
    <tr>
      <th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">Region</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Ox-AZ</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">P-B</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">Unknown</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">East</td>
      <td class="gt_row gt_center">165186</td>
      <td class="gt_row gt_right">21.6&percnt;</td>
      <td class="gt_row gt_center">459886</td>
      <td class="gt_row gt_right">25.2&percnt;</td>
      <td class="gt_row gt_center">224</td>
      <td class="gt_row gt_right">19.3&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">East Midlands</td>
      <td class="gt_row gt_center">117817</td>
      <td class="gt_row gt_right">15.4&percnt;</td>
      <td class="gt_row gt_center">302519</td>
      <td class="gt_row gt_right">16.6&percnt;</td>
      <td class="gt_row gt_center">378</td>
      <td class="gt_row gt_right">32.2&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">London</td>
      <td class="gt_row gt_center">29862</td>
      <td class="gt_row gt_right">3.9&percnt;</td>
      <td class="gt_row gt_center">76034</td>
      <td class="gt_row gt_right">4.2&percnt;</td>
      <td class="gt_row gt_center">35</td>
      <td class="gt_row gt_right">2.9&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">North East</td>
      <td class="gt_row gt_center">32984</td>
      <td class="gt_row gt_right">4.3&percnt;</td>
      <td class="gt_row gt_center">86093</td>
      <td class="gt_row gt_right">4.7&percnt;</td>
      <td class="gt_row gt_center">21</td>
      <td class="gt_row gt_right">2.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">North West</td>
      <td class="gt_row gt_center">77658</td>
      <td class="gt_row gt_right">10.1&percnt;</td>
      <td class="gt_row gt_center">167881</td>
      <td class="gt_row gt_right">9.2&percnt;</td>
      <td class="gt_row gt_center">203</td>
      <td class="gt_row gt_right">17.4&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">South East</td>
      <td class="gt_row gt_center">54159</td>
      <td class="gt_row gt_right">7.1&percnt;</td>
      <td class="gt_row gt_center">131026</td>
      <td class="gt_row gt_right">7.2&percnt;</td>
      <td class="gt_row gt_center">77</td>
      <td class="gt_row gt_right">6.3&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">South West</td>
      <td class="gt_row gt_center">118342</td>
      <td class="gt_row gt_right">15.5&percnt;</td>
      <td class="gt_row gt_center">297045</td>
      <td class="gt_row gt_right">16.3&percnt;</td>
      <td class="gt_row gt_center">70</td>
      <td class="gt_row gt_right">6.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">West Midlands</td>
      <td class="gt_row gt_center">34832</td>
      <td class="gt_row gt_right">4.6&percnt;</td>
      <td class="gt_row gt_center">65660</td>
      <td class="gt_row gt_right">3.6&percnt;</td>
      <td class="gt_row gt_center">35</td>
      <td class="gt_row gt_right">2.8&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Yorkshire and The Humber</td>
      <td class="gt_row gt_center">134484</td>
      <td class="gt_row gt_right">17.6&percnt;</td>
      <td class="gt_row gt_center">237209</td>
      <td class="gt_row gt_right">13.0&percnt;</td>
      <td class="gt_row gt_center">126</td>
      <td class="gt_row gt_right">10.9&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">(missing)</td>
      <td class="gt_row gt_center">70</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">224</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="7">- indicates redacted values</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;


<!--html_preserve--><style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#qdmbtawxoz .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#qdmbtawxoz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qdmbtawxoz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qdmbtawxoz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qdmbtawxoz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qdmbtawxoz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#qdmbtawxoz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#qdmbtawxoz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#qdmbtawxoz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qdmbtawxoz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qdmbtawxoz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#qdmbtawxoz .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#qdmbtawxoz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#qdmbtawxoz .gt_from_md > :first-child {
  margin-top: 0;
}

#qdmbtawxoz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qdmbtawxoz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#qdmbtawxoz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#qdmbtawxoz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qdmbtawxoz .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#qdmbtawxoz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qdmbtawxoz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qdmbtawxoz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qdmbtawxoz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qdmbtawxoz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qdmbtawxoz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#qdmbtawxoz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#qdmbtawxoz .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#qdmbtawxoz .gt_left {
  text-align: left;
}

#qdmbtawxoz .gt_center {
  text-align: center;
}

#qdmbtawxoz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qdmbtawxoz .gt_font_normal {
  font-weight: normal;
}

#qdmbtawxoz .gt_font_bold {
  font-weight: bold;
}

#qdmbtawxoz .gt_font_italic {
  font-style: italic;
}

#qdmbtawxoz .gt_super {
  font-size: 65%;
}

#qdmbtawxoz .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="qdmbtawxoz" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="12" class="gt_heading gt_title gt_font_normal" style>Post-vaccination event rates at 14 days amongst those with sufficient follow-up</th>
    </tr>
    <tr>
      <th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">Region</th>
      <th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">n</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">primary care case</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">positive test</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related admission</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">covid-related all-cause death</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
        <span class="gt_column_spanner">all-cause death</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">n</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">East</td>
      <td class="gt_row gt_center">83531</td>
      <td class="gt_row gt_center">84</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">882</td>
      <td class="gt_row gt_right">1.1&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">East Midlands</td>
      <td class="gt_row gt_center">58366</td>
      <td class="gt_row gt_center">56</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">560</td>
      <td class="gt_row gt_right">1.0&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">28</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">London</td>
      <td class="gt_row gt_center">12481</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">203</td>
      <td class="gt_row gt_right">1.6&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">North East</td>
      <td class="gt_row gt_center">18543</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">119</td>
      <td class="gt_row gt_right">0.6&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">14</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">21</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">North West</td>
      <td class="gt_row gt_center">45927</td>
      <td class="gt_row gt_center">35</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">357</td>
      <td class="gt_row gt_right">0.8&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">South East</td>
      <td class="gt_row gt_center">30394</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">427</td>
      <td class="gt_row gt_right">1.4&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">28</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">South West</td>
      <td class="gt_row gt_center">67606</td>
      <td class="gt_row gt_center">42</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
      <td class="gt_row gt_center">476</td>
      <td class="gt_row gt_right">0.7&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">49</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">West Midlands</td>
      <td class="gt_row gt_center">17276</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">154</td>
      <td class="gt_row gt_right">0.9&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Yorkshire and The Humber</td>
      <td class="gt_row gt_center">61950</td>
      <td class="gt_row gt_center">28</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">259</td>
      <td class="gt_row gt_right">0.4&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">49</td>
      <td class="gt_row gt_right">0.1&percnt;</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">(missing)</td>
      <td class="gt_row gt_center">35</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">-</td>
      <td class="gt_row gt_right">-</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
      <td class="gt_row gt_center">0</td>
      <td class="gt_row gt_right">0.0&percnt;</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="12">Numbers are rounded to the nearest 7</td>
    </tr>
  </tfoot>
  
</table></div><!--/html_preserve-->

&nbsp;
&nbsp;

![](../released_outputs/output/tte/figures/plot_patch_region.svg "outcomes by Region"){width="80%"}
