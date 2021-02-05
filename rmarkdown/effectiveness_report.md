## Vaccine effectiveness data in OpenSAFELY-TPP data

This document reports the frequency of covid-related outcomes in
TPP-registered patients who have received a vaccine for SARS-CoV-2. This
is a technical document to help inform the design of vaccine
effectiveness Studies in OpenSAFELY. Only patients who have received the
vaccine are included, and **no inferences should be made about the
comparative effectiveness between vaccinated and unvaccinated patient,
between vaccine brands, or across different patient groups**.

Measured outcomes include:

-   Positive Covid case identification in primary care, using the
    following clinical codes:
    -   [probable
        covid](https://codelists.opensafely.org/codelist/opensafely/covid-identification-in-primary-care-probable-covid-clinical-code/2020-07-16)
    -   [positive covid
        test](https://codelists.opensafely.org/codelist/opensafely/covid-identification-in-primary-care-probable-covid-positive-test/2020-07-16/)
    -   [covid
        sequelae](https://codelists.opensafely.org/codelist/opensafely/covid-identification-in-primary-care-probable-covid-sequelae/2020-07-16/)
-   Positive SARS-CoV-2 test, as reported via the Second Generation
    Surveillance System (SGSS)
-   Covid-related hospital admission, where
    [Covid](https://codelists.opensafely.org/codelist/opensafely/covid-identification/2020-06-03/)
    is listed as a reason for admission.
-   Covid-related death, where
    [Covid](https://codelists.opensafely.org/codelist/opensafely/covid-identification/2020-06-03/)
    is mentioned anywhere on the death certificate.
-   All-cause death.

### Data notes

The code and data for this report can be found at the
[covid-vaccine-effectiveness-research GitHub
repository](https://github.com/opensafely/covid-vaccine-effectiveness-research).

The dataset used for this report was created using the study definition
`/analysis/study_definition.py`, using codelists referenced in
`/codelists/codelists.txt`. It was extracted from the OpenSAFELY-TPP
data extracted on 2021-01-21, with event dates censored on (occurring no
later than) 2021-01-13.

To minimise data disclosivity in frequency tables, counts are rounded to
the nearest 7 and percentages are derived from these rounded counts.

## Summary

As of 2021-01-13, there were 2590143 TPP-registered patients who had
received at least one vaccine dose. Of these, 0 received the
Pfizer-BioNTech (P-B) vaccine and 0 received the Oxford-AstraZenica
(Ox-AZ) vaccine. Brand is unknown for the remaining 2590143 patients.

## Summaries by patient characteristics

The tables below show, for each characteristic:

-   Vaccine type, including those who have received both vaccine types
-   7-day post-vaccination event rates
-   Cumulative post-vaccination event rates over time
-   Estimated hazard rates over time.

### Sex

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#javnbllbhq .gt_table {
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

#javnbllbhq .gt_heading {
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

#javnbllbhq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#javnbllbhq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#javnbllbhq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#javnbllbhq .gt_col_headings {
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

#javnbllbhq .gt_col_heading {
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

#javnbllbhq .gt_column_spanner_outer {
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

#javnbllbhq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#javnbllbhq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#javnbllbhq .gt_column_spanner {
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

#javnbllbhq .gt_group_heading {
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

#javnbllbhq .gt_empty_group_heading {
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

#javnbllbhq .gt_from_md > :first-child {
  margin-top: 0;
}

#javnbllbhq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#javnbllbhq .gt_row {
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

#javnbllbhq .gt_stub {
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

#javnbllbhq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#javnbllbhq .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#javnbllbhq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#javnbllbhq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#javnbllbhq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#javnbllbhq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#javnbllbhq .gt_footnotes {
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

#javnbllbhq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#javnbllbhq .gt_sourcenotes {
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

#javnbllbhq .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#javnbllbhq .gt_left {
  text-align: left;
}

#javnbllbhq .gt_center {
  text-align: center;
}

#javnbllbhq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#javnbllbhq .gt_font_normal {
  font-weight: normal;
}

#javnbllbhq .gt_font_bold {
  font-weight: bold;
}

#javnbllbhq .gt_font_italic {
  font-style: italic;
}

#javnbllbhq .gt_super {
  font-size: 65%;
}

#javnbllbhq .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="javnbllbhq" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="7" class="gt_heading gt_title gt_font_normal" style>
Vaccine type
</th>
</tr>
<tr>
<th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
Sex
</th>
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
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_left">
Female
</td>
<td class="gt_row gt_center">
469938
</td>
<td class="gt_row gt_right">
61.4%
</td>
<td class="gt_row gt_center">
1153866
</td>
<td class="gt_row gt_right">
63.3%
</td>
<td class="gt_row gt_center">
763
</td>
<td class="gt_row gt_right">
65.2%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
Male
</td>
<td class="gt_row gt_center">
295456
</td>
<td class="gt_row gt_right">
38.6%
</td>
<td class="gt_row gt_center">
669704
</td>
<td class="gt_row gt_right">
36.7%
</td>
<td class="gt_row gt_center">
406
</td>
<td class="gt_row gt_right">
34.8%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="7">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

   

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#lfwqzcqptq .gt_table {
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

#lfwqzcqptq .gt_heading {
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

#lfwqzcqptq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#lfwqzcqptq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#lfwqzcqptq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lfwqzcqptq .gt_col_headings {
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

#lfwqzcqptq .gt_col_heading {
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

#lfwqzcqptq .gt_column_spanner_outer {
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

#lfwqzcqptq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#lfwqzcqptq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#lfwqzcqptq .gt_column_spanner {
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

#lfwqzcqptq .gt_group_heading {
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

#lfwqzcqptq .gt_empty_group_heading {
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

#lfwqzcqptq .gt_from_md > :first-child {
  margin-top: 0;
}

#lfwqzcqptq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#lfwqzcqptq .gt_row {
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

#lfwqzcqptq .gt_stub {
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

#lfwqzcqptq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lfwqzcqptq .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#lfwqzcqptq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#lfwqzcqptq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#lfwqzcqptq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#lfwqzcqptq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#lfwqzcqptq .gt_footnotes {
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

#lfwqzcqptq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#lfwqzcqptq .gt_sourcenotes {
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

#lfwqzcqptq .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#lfwqzcqptq .gt_left {
  text-align: left;
}

#lfwqzcqptq .gt_center {
  text-align: center;
}

#lfwqzcqptq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#lfwqzcqptq .gt_font_normal {
  font-weight: normal;
}

#lfwqzcqptq .gt_font_bold {
  font-weight: bold;
}

#lfwqzcqptq .gt_font_italic {
  font-style: italic;
}

#lfwqzcqptq .gt_super {
  font-size: 65%;
}

#lfwqzcqptq .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="lfwqzcqptq"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
Sex
</th>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
n
</th>
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
<span class="gt_column_spanner">covid-related death</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">all-cause death</span>
</th>
</tr>
<tr>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_center">
Female
</td>
<td class="gt_row gt_center">
241136
</td>
<td class="gt_row gt_center">
189
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
2408
</td>
<td class="gt_row gt_right">
1.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
35
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
126
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
Male
</td>
<td class="gt_row gt_center">
154966
</td>
<td class="gt_row gt_center">
126
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
1022
</td>
<td class="gt_row gt_right">
0.7%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
28
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
140
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>

<!--/html_preserve-->

   

<img src="../released_outputs/output/tte/figures/plot_patch_sex.svg" title="outcomes by Sex" style="width:80.0%" />

### Age

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#fcqpjvacmb .gt_table {
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

#fcqpjvacmb .gt_heading {
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

#fcqpjvacmb .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#fcqpjvacmb .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#fcqpjvacmb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fcqpjvacmb .gt_col_headings {
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

#fcqpjvacmb .gt_col_heading {
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

#fcqpjvacmb .gt_column_spanner_outer {
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

#fcqpjvacmb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#fcqpjvacmb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#fcqpjvacmb .gt_column_spanner {
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

#fcqpjvacmb .gt_group_heading {
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

#fcqpjvacmb .gt_empty_group_heading {
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

#fcqpjvacmb .gt_from_md > :first-child {
  margin-top: 0;
}

#fcqpjvacmb .gt_from_md > :last-child {
  margin-bottom: 0;
}

#fcqpjvacmb .gt_row {
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

#fcqpjvacmb .gt_stub {
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

#fcqpjvacmb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fcqpjvacmb .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#fcqpjvacmb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fcqpjvacmb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#fcqpjvacmb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#fcqpjvacmb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fcqpjvacmb .gt_footnotes {
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

#fcqpjvacmb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#fcqpjvacmb .gt_sourcenotes {
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

#fcqpjvacmb .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#fcqpjvacmb .gt_left {
  text-align: left;
}

#fcqpjvacmb .gt_center {
  text-align: center;
}

#fcqpjvacmb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#fcqpjvacmb .gt_font_normal {
  font-weight: normal;
}

#fcqpjvacmb .gt_font_bold {
  font-weight: bold;
}

#fcqpjvacmb .gt_font_italic {
  font-style: italic;
}

#fcqpjvacmb .gt_super {
  font-size: 65%;
}

#fcqpjvacmb .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="fcqpjvacmb" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="7" class="gt_heading gt_title gt_font_normal" style>
Vaccine type
</th>
</tr>
<tr>
<th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
Age
</th>
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
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_left">
18-49
</td>
<td class="gt_row gt_center">
115696
</td>
<td class="gt_row gt_right">
15.1%
</td>
<td class="gt_row gt_center">
443149
</td>
<td class="gt_row gt_right">
24.3%
</td>
<td class="gt_row gt_center">
210
</td>
<td class="gt_row gt_right">
18.1%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
50s
</td>
<td class="gt_row gt_center">
60739
</td>
<td class="gt_row gt_right">
7.9%
</td>
<td class="gt_row gt_center">
208376
</td>
<td class="gt_row gt_right">
11.4%
</td>
<td class="gt_row gt_center">
112
</td>
<td class="gt_row gt_right">
9.6%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
60s
</td>
<td class="gt_row gt_center">
54824
</td>
<td class="gt_row gt_right">
7.2%
</td>
<td class="gt_row gt_center">
111790
</td>
<td class="gt_row gt_right">
6.1%
</td>
<td class="gt_row gt_center">
56
</td>
<td class="gt_row gt_right">
4.7%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
70s
</td>
<td class="gt_row gt_center">
331744
</td>
<td class="gt_row gt_right">
43.3%
</td>
<td class="gt_row gt_center">
385042
</td>
<td class="gt_row gt_right">
21.1%
</td>
<td class="gt_row gt_center">
273
</td>
<td class="gt_row gt_right">
23.0%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
80+
</td>
<td class="gt_row gt_center">
202391
</td>
<td class="gt_row gt_right">
26.4%
</td>
<td class="gt_row gt_center">
675213
</td>
<td class="gt_row gt_right">
37.0%
</td>
<td class="gt_row gt_center">
525
</td>
<td class="gt_row gt_right">
44.5%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="7">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

   

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#eyamjrdlih .gt_table {
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

#eyamjrdlih .gt_heading {
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

#eyamjrdlih .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#eyamjrdlih .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#eyamjrdlih .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#eyamjrdlih .gt_col_headings {
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

#eyamjrdlih .gt_col_heading {
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

#eyamjrdlih .gt_column_spanner_outer {
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

#eyamjrdlih .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#eyamjrdlih .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#eyamjrdlih .gt_column_spanner {
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

#eyamjrdlih .gt_group_heading {
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

#eyamjrdlih .gt_empty_group_heading {
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

#eyamjrdlih .gt_from_md > :first-child {
  margin-top: 0;
}

#eyamjrdlih .gt_from_md > :last-child {
  margin-bottom: 0;
}

#eyamjrdlih .gt_row {
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

#eyamjrdlih .gt_stub {
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

#eyamjrdlih .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#eyamjrdlih .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#eyamjrdlih .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#eyamjrdlih .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#eyamjrdlih .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#eyamjrdlih .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#eyamjrdlih .gt_footnotes {
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

#eyamjrdlih .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#eyamjrdlih .gt_sourcenotes {
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

#eyamjrdlih .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#eyamjrdlih .gt_left {
  text-align: left;
}

#eyamjrdlih .gt_center {
  text-align: center;
}

#eyamjrdlih .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#eyamjrdlih .gt_font_normal {
  font-weight: normal;
}

#eyamjrdlih .gt_font_bold {
  font-weight: bold;
}

#eyamjrdlih .gt_font_italic {
  font-style: italic;
}

#eyamjrdlih .gt_super {
  font-size: 65%;
}

#eyamjrdlih .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="eyamjrdlih"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
Age
</th>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
n
</th>
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
<span class="gt_column_spanner">covid-related death</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">all-cause death</span>
</th>
</tr>
<tr>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_center">
18-49
</td>
<td class="gt_row gt_center">
72478
</td>
<td class="gt_row gt_center">
56
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
1456
</td>
<td class="gt_row gt_right">
2.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
50s
</td>
<td class="gt_row gt_center">
38934
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
665
</td>
<td class="gt_row gt_right">
1.7%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
60s
</td>
<td class="gt_row gt_center">
17724
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
287
</td>
<td class="gt_row gt_right">
1.6%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
70s
</td>
<td class="gt_row gt_center">
33061
</td>
<td class="gt_row gt_center">
28
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
189
</td>
<td class="gt_row gt_right">
0.6%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
35
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
80+
</td>
<td class="gt_row gt_center">
233905
</td>
<td class="gt_row gt_center">
182
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
847
</td>
<td class="gt_row gt_right">
0.4%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
49
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
224
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>

<!--/html_preserve-->

   

<img src="../released_outputs/output/tte/figures/plot_patch_ageband.svg" title="outcomes by Age" style="width:80.0%" />

### Ethnicity

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#poedcvrgag .gt_table {
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

#poedcvrgag .gt_heading {
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

#poedcvrgag .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#poedcvrgag .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#poedcvrgag .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#poedcvrgag .gt_col_headings {
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

#poedcvrgag .gt_col_heading {
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

#poedcvrgag .gt_column_spanner_outer {
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

#poedcvrgag .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#poedcvrgag .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#poedcvrgag .gt_column_spanner {
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

#poedcvrgag .gt_group_heading {
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

#poedcvrgag .gt_empty_group_heading {
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

#poedcvrgag .gt_from_md > :first-child {
  margin-top: 0;
}

#poedcvrgag .gt_from_md > :last-child {
  margin-bottom: 0;
}

#poedcvrgag .gt_row {
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

#poedcvrgag .gt_stub {
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

#poedcvrgag .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#poedcvrgag .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#poedcvrgag .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#poedcvrgag .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#poedcvrgag .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#poedcvrgag .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#poedcvrgag .gt_footnotes {
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

#poedcvrgag .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#poedcvrgag .gt_sourcenotes {
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

#poedcvrgag .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#poedcvrgag .gt_left {
  text-align: left;
}

#poedcvrgag .gt_center {
  text-align: center;
}

#poedcvrgag .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#poedcvrgag .gt_font_normal {
  font-weight: normal;
}

#poedcvrgag .gt_font_bold {
  font-weight: bold;
}

#poedcvrgag .gt_font_italic {
  font-style: italic;
}

#poedcvrgag .gt_super {
  font-size: 65%;
}

#poedcvrgag .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="poedcvrgag" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="7" class="gt_heading gt_title gt_font_normal" style>
Vaccine type
</th>
</tr>
<tr>
<th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
Ethnicity
</th>
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
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_left">
Black
</td>
<td class="gt_row gt_center">
8617
</td>
<td class="gt_row gt_right">
1.1%
</td>
<td class="gt_row gt_center">
20643
</td>
<td class="gt_row gt_right">
1.1%
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
1.0%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
Mixed
</td>
<td class="gt_row gt_center">
3402
</td>
<td class="gt_row gt_right">
0.4%
</td>
<td class="gt_row gt_center">
10654
</td>
<td class="gt_row gt_right">
0.6%
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.9%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
South Asian
</td>
<td class="gt_row gt_center">
22757
</td>
<td class="gt_row gt_right">
3.0%
</td>
<td class="gt_row gt_center">
79814
</td>
<td class="gt_row gt_right">
4.4%
</td>
<td class="gt_row gt_center">
49
</td>
<td class="gt_row gt_right">
4.1%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
White
</td>
<td class="gt_row gt_center">
546007
</td>
<td class="gt_row gt_right">
71.3%
</td>
<td class="gt_row gt_center">
1257683
</td>
<td class="gt_row gt_right">
69.0%
</td>
<td class="gt_row gt_center">
812
</td>
<td class="gt_row gt_right">
68.9%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
Other
</td>
<td class="gt_row gt_center">
5628
</td>
<td class="gt_row gt_right">
0.7%
</td>
<td class="gt_row gt_center">
17374
</td>
<td class="gt_row gt_right">
1.0%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.9%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
(missing)
</td>
<td class="gt_row gt_center">
178983
</td>
<td class="gt_row gt_right">
23.4%
</td>
<td class="gt_row gt_center">
437402
</td>
<td class="gt_row gt_right">
24.0%
</td>
<td class="gt_row gt_center">
287
</td>
<td class="gt_row gt_right">
24.2%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="7">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

   

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#nsryzwujsn .gt_table {
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

#nsryzwujsn .gt_heading {
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

#nsryzwujsn .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#nsryzwujsn .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#nsryzwujsn .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nsryzwujsn .gt_col_headings {
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

#nsryzwujsn .gt_col_heading {
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

#nsryzwujsn .gt_column_spanner_outer {
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

#nsryzwujsn .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nsryzwujsn .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nsryzwujsn .gt_column_spanner {
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

#nsryzwujsn .gt_group_heading {
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

#nsryzwujsn .gt_empty_group_heading {
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

#nsryzwujsn .gt_from_md > :first-child {
  margin-top: 0;
}

#nsryzwujsn .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nsryzwujsn .gt_row {
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

#nsryzwujsn .gt_stub {
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

#nsryzwujsn .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nsryzwujsn .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#nsryzwujsn .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nsryzwujsn .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nsryzwujsn .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nsryzwujsn .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nsryzwujsn .gt_footnotes {
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

#nsryzwujsn .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#nsryzwujsn .gt_sourcenotes {
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

#nsryzwujsn .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#nsryzwujsn .gt_left {
  text-align: left;
}

#nsryzwujsn .gt_center {
  text-align: center;
}

#nsryzwujsn .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nsryzwujsn .gt_font_normal {
  font-weight: normal;
}

#nsryzwujsn .gt_font_bold {
  font-weight: bold;
}

#nsryzwujsn .gt_font_italic {
  font-style: italic;
}

#nsryzwujsn .gt_super {
  font-size: 65%;
}

#nsryzwujsn .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="nsryzwujsn"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
Ethnicity
</th>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
n
</th>
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
<span class="gt_column_spanner">covid-related death</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">all-cause death</span>
</th>
</tr>
<tr>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_center">
Black
</td>
<td class="gt_row gt_center">
3199
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
56
</td>
<td class="gt_row gt_right">
1.7%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
Mixed
</td>
<td class="gt_row gt_center">
1967
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
28
</td>
<td class="gt_row gt_right">
1.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
South Asian
</td>
<td class="gt_row gt_center">
17437
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
301
</td>
<td class="gt_row gt_right">
1.7%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
White
</td>
<td class="gt_row gt_center">
271313
</td>
<td class="gt_row gt_center">
217
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
2177
</td>
<td class="gt_row gt_right">
0.8%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
189
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
Other
</td>
<td class="gt_row gt_center">
3542
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
56
</td>
<td class="gt_row gt_right">
1.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
98644
</td>
<td class="gt_row gt_center">
77
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
826
</td>
<td class="gt_row gt_right">
0.8%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
77
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>

<!--/html_preserve-->

   

<img src="../released_outputs/output/tte/figures/plot_patch_ethnicity.svg" title="outcomes by Ethnicity" style="width:80.0%" />

### Index of Multiple Deprivation (IMD)

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#npbplvvnqi .gt_table {
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

#npbplvvnqi .gt_heading {
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

#npbplvvnqi .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#npbplvvnqi .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#npbplvvnqi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#npbplvvnqi .gt_col_headings {
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

#npbplvvnqi .gt_col_heading {
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

#npbplvvnqi .gt_column_spanner_outer {
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

#npbplvvnqi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#npbplvvnqi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#npbplvvnqi .gt_column_spanner {
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

#npbplvvnqi .gt_group_heading {
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

#npbplvvnqi .gt_empty_group_heading {
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

#npbplvvnqi .gt_from_md > :first-child {
  margin-top: 0;
}

#npbplvvnqi .gt_from_md > :last-child {
  margin-bottom: 0;
}

#npbplvvnqi .gt_row {
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

#npbplvvnqi .gt_stub {
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

#npbplvvnqi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#npbplvvnqi .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#npbplvvnqi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#npbplvvnqi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#npbplvvnqi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#npbplvvnqi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#npbplvvnqi .gt_footnotes {
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

#npbplvvnqi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#npbplvvnqi .gt_sourcenotes {
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

#npbplvvnqi .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#npbplvvnqi .gt_left {
  text-align: left;
}

#npbplvvnqi .gt_center {
  text-align: center;
}

#npbplvvnqi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#npbplvvnqi .gt_font_normal {
  font-weight: normal;
}

#npbplvvnqi .gt_font_bold {
  font-weight: bold;
}

#npbplvvnqi .gt_font_italic {
  font-style: italic;
}

#npbplvvnqi .gt_super {
  font-size: 65%;
}

#npbplvvnqi .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="npbplvvnqi" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="7" class="gt_heading gt_title gt_font_normal" style>
Vaccine type
</th>
</tr>
<tr>
<th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
IMD
</th>
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
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_left">
1 least deprived
</td>
<td class="gt_row gt_center">
115248
</td>
<td class="gt_row gt_right">
15.1%
</td>
<td class="gt_row gt_center">
246701
</td>
<td class="gt_row gt_right">
13.5%
</td>
<td class="gt_row gt_center">
210
</td>
<td class="gt_row gt_right">
17.8%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
2
</td>
<td class="gt_row gt_center">
134638
</td>
<td class="gt_row gt_right">
17.6%
</td>
<td class="gt_row gt_center">
317653
</td>
<td class="gt_row gt_right">
17.4%
</td>
<td class="gt_row gt_center">
203
</td>
<td class="gt_row gt_right">
17.5%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
3
</td>
<td class="gt_row gt_center">
167776
</td>
<td class="gt_row gt_right">
21.9%
</td>
<td class="gt_row gt_center">
396550
</td>
<td class="gt_row gt_right">
21.7%
</td>
<td class="gt_row gt_center">
210
</td>
<td class="gt_row gt_right">
17.9%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
4
</td>
<td class="gt_row gt_center">
168539
</td>
<td class="gt_row gt_right">
22.0%
</td>
<td class="gt_row gt_center">
414477
</td>
<td class="gt_row gt_right">
22.7%
</td>
<td class="gt_row gt_center">
196
</td>
<td class="gt_row gt_right">
16.4%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
5 most deprived
</td>
<td class="gt_row gt_center">
163821
</td>
<td class="gt_row gt_right">
21.4%
</td>
<td class="gt_row gt_center">
410018
</td>
<td class="gt_row gt_right">
22.5%
</td>
<td class="gt_row gt_center">
259
</td>
<td class="gt_row gt_right">
21.8%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
(missing)
</td>
<td class="gt_row gt_center">
15365
</td>
<td class="gt_row gt_right">
2.0%
</td>
<td class="gt_row gt_center">
38171
</td>
<td class="gt_row gt_right">
2.1%
</td>
<td class="gt_row gt_center">
98
</td>
<td class="gt_row gt_right">
8.5%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="7">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

   

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#scrufwuybc .gt_table {
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

#scrufwuybc .gt_heading {
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

#scrufwuybc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#scrufwuybc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#scrufwuybc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#scrufwuybc .gt_col_headings {
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

#scrufwuybc .gt_col_heading {
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

#scrufwuybc .gt_column_spanner_outer {
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

#scrufwuybc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#scrufwuybc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#scrufwuybc .gt_column_spanner {
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

#scrufwuybc .gt_group_heading {
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

#scrufwuybc .gt_empty_group_heading {
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

#scrufwuybc .gt_from_md > :first-child {
  margin-top: 0;
}

#scrufwuybc .gt_from_md > :last-child {
  margin-bottom: 0;
}

#scrufwuybc .gt_row {
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

#scrufwuybc .gt_stub {
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

#scrufwuybc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#scrufwuybc .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#scrufwuybc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#scrufwuybc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#scrufwuybc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#scrufwuybc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#scrufwuybc .gt_footnotes {
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

#scrufwuybc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#scrufwuybc .gt_sourcenotes {
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

#scrufwuybc .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#scrufwuybc .gt_left {
  text-align: left;
}

#scrufwuybc .gt_center {
  text-align: center;
}

#scrufwuybc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#scrufwuybc .gt_font_normal {
  font-weight: normal;
}

#scrufwuybc .gt_font_bold {
  font-weight: bold;
}

#scrufwuybc .gt_font_italic {
  font-style: italic;
}

#scrufwuybc .gt_super {
  font-size: 65%;
}

#scrufwuybc .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="scrufwuybc"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
IMD
</th>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
n
</th>
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
<span class="gt_column_spanner">covid-related death</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">all-cause death</span>
</th>
</tr>
<tr>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_center">
1 least deprived
</td>
<td class="gt_row gt_center">
54047
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
546
</td>
<td class="gt_row gt_right">
1.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
2
</td>
<td class="gt_row gt_center">
67200
</td>
<td class="gt_row gt_center">
70
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
644
</td>
<td class="gt_row gt_right">
1.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
3
</td>
<td class="gt_row gt_center">
83419
</td>
<td class="gt_row gt_center">
77
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
763
</td>
<td class="gt_row gt_right">
0.9%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
56
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
4
</td>
<td class="gt_row gt_center">
90902
</td>
<td class="gt_row gt_center">
77
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
742
</td>
<td class="gt_row gt_right">
0.8%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
49
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
5 most deprived
</td>
<td class="gt_row gt_center">
91672
</td>
<td class="gt_row gt_center">
49
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
665
</td>
<td class="gt_row gt_right">
0.7%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
63
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
8862
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
70
</td>
<td class="gt_row gt_right">
0.8%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>

<!--/html_preserve-->

   

<img src="../released_outputs/output/tte/figures/plot_patch_imd.svg" title="outcomes by IMD" style="width:80.0%" />

### Region

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#fjeqgrinvc .gt_table {
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

#fjeqgrinvc .gt_heading {
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

#fjeqgrinvc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#fjeqgrinvc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#fjeqgrinvc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fjeqgrinvc .gt_col_headings {
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

#fjeqgrinvc .gt_col_heading {
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

#fjeqgrinvc .gt_column_spanner_outer {
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

#fjeqgrinvc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#fjeqgrinvc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#fjeqgrinvc .gt_column_spanner {
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

#fjeqgrinvc .gt_group_heading {
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

#fjeqgrinvc .gt_empty_group_heading {
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

#fjeqgrinvc .gt_from_md > :first-child {
  margin-top: 0;
}

#fjeqgrinvc .gt_from_md > :last-child {
  margin-bottom: 0;
}

#fjeqgrinvc .gt_row {
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

#fjeqgrinvc .gt_stub {
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

#fjeqgrinvc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fjeqgrinvc .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#fjeqgrinvc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fjeqgrinvc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#fjeqgrinvc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#fjeqgrinvc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fjeqgrinvc .gt_footnotes {
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

#fjeqgrinvc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#fjeqgrinvc .gt_sourcenotes {
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

#fjeqgrinvc .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#fjeqgrinvc .gt_left {
  text-align: left;
}

#fjeqgrinvc .gt_center {
  text-align: center;
}

#fjeqgrinvc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#fjeqgrinvc .gt_font_normal {
  font-weight: normal;
}

#fjeqgrinvc .gt_font_bold {
  font-weight: bold;
}

#fjeqgrinvc .gt_font_italic {
  font-style: italic;
}

#fjeqgrinvc .gt_super {
  font-size: 65%;
}

#fjeqgrinvc .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="fjeqgrinvc" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="7" class="gt_heading gt_title gt_font_normal" style>
Vaccine type
</th>
</tr>
<tr>
<th colspan="7" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
Region
</th>
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
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_left">
East
</td>
<td class="gt_row gt_center">
165186
</td>
<td class="gt_row gt_right">
21.6%
</td>
<td class="gt_row gt_center">
459886
</td>
<td class="gt_row gt_right">
25.2%
</td>
<td class="gt_row gt_center">
224
</td>
<td class="gt_row gt_right">
19.3%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
East Midlands
</td>
<td class="gt_row gt_center">
117817
</td>
<td class="gt_row gt_right">
15.4%
</td>
<td class="gt_row gt_center">
302519
</td>
<td class="gt_row gt_right">
16.6%
</td>
<td class="gt_row gt_center">
378
</td>
<td class="gt_row gt_right">
32.2%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
London
</td>
<td class="gt_row gt_center">
29862
</td>
<td class="gt_row gt_right">
3.9%
</td>
<td class="gt_row gt_center">
76034
</td>
<td class="gt_row gt_right">
4.2%
</td>
<td class="gt_row gt_center">
35
</td>
<td class="gt_row gt_right">
2.9%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
North East
</td>
<td class="gt_row gt_center">
32984
</td>
<td class="gt_row gt_right">
4.3%
</td>
<td class="gt_row gt_center">
86093
</td>
<td class="gt_row gt_right">
4.7%
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
2.0%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
North West
</td>
<td class="gt_row gt_center">
77658
</td>
<td class="gt_row gt_right">
10.1%
</td>
<td class="gt_row gt_center">
167881
</td>
<td class="gt_row gt_right">
9.2%
</td>
<td class="gt_row gt_center">
203
</td>
<td class="gt_row gt_right">
17.4%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
South East
</td>
<td class="gt_row gt_center">
54159
</td>
<td class="gt_row gt_right">
7.1%
</td>
<td class="gt_row gt_center">
131026
</td>
<td class="gt_row gt_right">
7.2%
</td>
<td class="gt_row gt_center">
77
</td>
<td class="gt_row gt_right">
6.3%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
South West
</td>
<td class="gt_row gt_center">
118342
</td>
<td class="gt_row gt_right">
15.5%
</td>
<td class="gt_row gt_center">
297045
</td>
<td class="gt_row gt_right">
16.3%
</td>
<td class="gt_row gt_center">
70
</td>
<td class="gt_row gt_right">
6.1%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
West Midlands
</td>
<td class="gt_row gt_center">
34832
</td>
<td class="gt_row gt_right">
4.6%
</td>
<td class="gt_row gt_center">
65660
</td>
<td class="gt_row gt_right">
3.6%
</td>
<td class="gt_row gt_center">
35
</td>
<td class="gt_row gt_right">
2.8%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
Yorkshire and The Humber
</td>
<td class="gt_row gt_center">
134484
</td>
<td class="gt_row gt_right">
17.6%
</td>
<td class="gt_row gt_center">
237209
</td>
<td class="gt_row gt_right">
13.0%
</td>
<td class="gt_row gt_center">
126
</td>
<td class="gt_row gt_right">
10.9%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
(missing)
</td>
<td class="gt_row gt_center">
70
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
224
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="7">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

   

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#apldnohmit .gt_table {
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

#apldnohmit .gt_heading {
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

#apldnohmit .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#apldnohmit .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#apldnohmit .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#apldnohmit .gt_col_headings {
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

#apldnohmit .gt_col_heading {
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

#apldnohmit .gt_column_spanner_outer {
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

#apldnohmit .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#apldnohmit .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#apldnohmit .gt_column_spanner {
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

#apldnohmit .gt_group_heading {
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

#apldnohmit .gt_empty_group_heading {
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

#apldnohmit .gt_from_md > :first-child {
  margin-top: 0;
}

#apldnohmit .gt_from_md > :last-child {
  margin-bottom: 0;
}

#apldnohmit .gt_row {
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

#apldnohmit .gt_stub {
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

#apldnohmit .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#apldnohmit .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#apldnohmit .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#apldnohmit .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#apldnohmit .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#apldnohmit .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#apldnohmit .gt_footnotes {
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

#apldnohmit .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#apldnohmit .gt_sourcenotes {
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

#apldnohmit .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#apldnohmit .gt_left {
  text-align: left;
}

#apldnohmit .gt_center {
  text-align: center;
}

#apldnohmit .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#apldnohmit .gt_font_normal {
  font-weight: normal;
}

#apldnohmit .gt_font_bold {
  font-weight: bold;
}

#apldnohmit .gt_font_italic {
  font-style: italic;
}

#apldnohmit .gt_super {
  font-size: 65%;
}

#apldnohmit .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="apldnohmit"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="12" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
</th>
</tr>
</thead>
<thead class="gt_col_headings">
<tr>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
Region
</th>
<th class="gt_col_heading gt_center gt_columns_bottom_border" rowspan="2" colspan="1">
n
</th>
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
<span class="gt_column_spanner">covid-related death</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">all-cause death</span>
</th>
</tr>
<tr>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
n
</th>
<th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">
%
</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_center">
East
</td>
<td class="gt_row gt_center">
83531
</td>
<td class="gt_row gt_center">
84
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
882
</td>
<td class="gt_row gt_right">
1.1%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
East Midlands
</td>
<td class="gt_row gt_center">
58366
</td>
<td class="gt_row gt_center">
56
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
560
</td>
<td class="gt_row gt_right">
1.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
28
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
London
</td>
<td class="gt_row gt_center">
12481
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
203
</td>
<td class="gt_row gt_right">
1.6%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
North East
</td>
<td class="gt_row gt_center">
18543
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
119
</td>
<td class="gt_row gt_right">
0.6%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
North West
</td>
<td class="gt_row gt_center">
45927
</td>
<td class="gt_row gt_center">
35
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
357
</td>
<td class="gt_row gt_right">
0.8%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
South East
</td>
<td class="gt_row gt_center">
30394
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
427
</td>
<td class="gt_row gt_right">
1.4%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
28
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
South West
</td>
<td class="gt_row gt_center">
67606
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
476
</td>
<td class="gt_row gt_right">
0.7%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
49
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
West Midlands
</td>
<td class="gt_row gt_center">
17276
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
154
</td>
<td class="gt_row gt_right">
0.9%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
Yorkshire and The Humber
</td>
<td class="gt_row gt_center">
61950
</td>
<td class="gt_row gt_center">
28
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
259
</td>
<td class="gt_row gt_right">
0.4%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
49
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
35
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>

<!--/html_preserve-->

   

<img src="../released_outputs/output/tte/figures/plot_patch_region.svg" title="outcomes by Region" style="width:80.0%" />
