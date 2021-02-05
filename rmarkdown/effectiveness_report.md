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

#ghntaseupb .gt_table {
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

#ghntaseupb .gt_heading {
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

#ghntaseupb .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ghntaseupb .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ghntaseupb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ghntaseupb .gt_col_headings {
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

#ghntaseupb .gt_col_heading {
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

#ghntaseupb .gt_column_spanner_outer {
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

#ghntaseupb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ghntaseupb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ghntaseupb .gt_column_spanner {
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

#ghntaseupb .gt_group_heading {
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

#ghntaseupb .gt_empty_group_heading {
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

#ghntaseupb .gt_from_md > :first-child {
  margin-top: 0;
}

#ghntaseupb .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ghntaseupb .gt_row {
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

#ghntaseupb .gt_stub {
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

#ghntaseupb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ghntaseupb .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ghntaseupb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ghntaseupb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ghntaseupb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ghntaseupb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ghntaseupb .gt_footnotes {
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

#ghntaseupb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ghntaseupb .gt_sourcenotes {
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

#ghntaseupb .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ghntaseupb .gt_left {
  text-align: left;
}

#ghntaseupb .gt_center {
  text-align: center;
}

#ghntaseupb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ghntaseupb .gt_font_normal {
  font-weight: normal;
}

#ghntaseupb .gt_font_bold {
  font-weight: bold;
}

#ghntaseupb .gt_font_italic {
  font-style: italic;
}

#ghntaseupb .gt_super {
  font-size: 65%;
}

#ghntaseupb .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ghntaseupb" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#bulqhrbfsw .gt_table {
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

#bulqhrbfsw .gt_heading {
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

#bulqhrbfsw .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#bulqhrbfsw .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#bulqhrbfsw .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bulqhrbfsw .gt_col_headings {
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

#bulqhrbfsw .gt_col_heading {
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

#bulqhrbfsw .gt_column_spanner_outer {
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

#bulqhrbfsw .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bulqhrbfsw .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bulqhrbfsw .gt_column_spanner {
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

#bulqhrbfsw .gt_group_heading {
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

#bulqhrbfsw .gt_empty_group_heading {
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

#bulqhrbfsw .gt_from_md > :first-child {
  margin-top: 0;
}

#bulqhrbfsw .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bulqhrbfsw .gt_row {
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

#bulqhrbfsw .gt_stub {
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

#bulqhrbfsw .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bulqhrbfsw .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#bulqhrbfsw .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bulqhrbfsw .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bulqhrbfsw .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bulqhrbfsw .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bulqhrbfsw .gt_footnotes {
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

#bulqhrbfsw .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#bulqhrbfsw .gt_sourcenotes {
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

#bulqhrbfsw .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#bulqhrbfsw .gt_left {
  text-align: left;
}

#bulqhrbfsw .gt_center {
  text-align: center;
}

#bulqhrbfsw .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bulqhrbfsw .gt_font_normal {
  font-weight: normal;
}

#bulqhrbfsw .gt_font_bold {
  font-weight: bold;
}

#bulqhrbfsw .gt_font_italic {
  font-style: italic;
}

#bulqhrbfsw .gt_super {
  font-size: 65%;
}

#bulqhrbfsw .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="bulqhrbfsw"
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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

#ckgzdgnqnv .gt_table {
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

#ckgzdgnqnv .gt_heading {
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

#ckgzdgnqnv .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ckgzdgnqnv .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ckgzdgnqnv .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ckgzdgnqnv .gt_col_headings {
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

#ckgzdgnqnv .gt_col_heading {
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

#ckgzdgnqnv .gt_column_spanner_outer {
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

#ckgzdgnqnv .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ckgzdgnqnv .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ckgzdgnqnv .gt_column_spanner {
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

#ckgzdgnqnv .gt_group_heading {
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

#ckgzdgnqnv .gt_empty_group_heading {
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

#ckgzdgnqnv .gt_from_md > :first-child {
  margin-top: 0;
}

#ckgzdgnqnv .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ckgzdgnqnv .gt_row {
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

#ckgzdgnqnv .gt_stub {
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

#ckgzdgnqnv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ckgzdgnqnv .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ckgzdgnqnv .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ckgzdgnqnv .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ckgzdgnqnv .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ckgzdgnqnv .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ckgzdgnqnv .gt_footnotes {
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

#ckgzdgnqnv .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ckgzdgnqnv .gt_sourcenotes {
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

#ckgzdgnqnv .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ckgzdgnqnv .gt_left {
  text-align: left;
}

#ckgzdgnqnv .gt_center {
  text-align: center;
}

#ckgzdgnqnv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ckgzdgnqnv .gt_font_normal {
  font-weight: normal;
}

#ckgzdgnqnv .gt_font_bold {
  font-weight: bold;
}

#ckgzdgnqnv .gt_font_italic {
  font-style: italic;
}

#ckgzdgnqnv .gt_super {
  font-size: 65%;
}

#ckgzdgnqnv .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ckgzdgnqnv" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#qckqzsdwcm .gt_table {
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

#qckqzsdwcm .gt_heading {
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

#qckqzsdwcm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qckqzsdwcm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qckqzsdwcm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qckqzsdwcm .gt_col_headings {
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

#qckqzsdwcm .gt_col_heading {
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

#qckqzsdwcm .gt_column_spanner_outer {
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

#qckqzsdwcm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qckqzsdwcm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qckqzsdwcm .gt_column_spanner {
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

#qckqzsdwcm .gt_group_heading {
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

#qckqzsdwcm .gt_empty_group_heading {
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

#qckqzsdwcm .gt_from_md > :first-child {
  margin-top: 0;
}

#qckqzsdwcm .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qckqzsdwcm .gt_row {
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

#qckqzsdwcm .gt_stub {
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

#qckqzsdwcm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qckqzsdwcm .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#qckqzsdwcm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qckqzsdwcm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qckqzsdwcm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qckqzsdwcm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qckqzsdwcm .gt_footnotes {
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

#qckqzsdwcm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#qckqzsdwcm .gt_sourcenotes {
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

#qckqzsdwcm .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#qckqzsdwcm .gt_left {
  text-align: left;
}

#qckqzsdwcm .gt_center {
  text-align: center;
}

#qckqzsdwcm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qckqzsdwcm .gt_font_normal {
  font-weight: normal;
}

#qckqzsdwcm .gt_font_bold {
  font-weight: bold;
}

#qckqzsdwcm .gt_font_italic {
  font-style: italic;
}

#qckqzsdwcm .gt_super {
  font-size: 65%;
}

#qckqzsdwcm .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="qckqzsdwcm"
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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

#vkormtxwwm .gt_table {
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

#vkormtxwwm .gt_heading {
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

#vkormtxwwm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#vkormtxwwm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#vkormtxwwm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vkormtxwwm .gt_col_headings {
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

#vkormtxwwm .gt_col_heading {
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

#vkormtxwwm .gt_column_spanner_outer {
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

#vkormtxwwm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#vkormtxwwm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#vkormtxwwm .gt_column_spanner {
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

#vkormtxwwm .gt_group_heading {
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

#vkormtxwwm .gt_empty_group_heading {
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

#vkormtxwwm .gt_from_md > :first-child {
  margin-top: 0;
}

#vkormtxwwm .gt_from_md > :last-child {
  margin-bottom: 0;
}

#vkormtxwwm .gt_row {
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

#vkormtxwwm .gt_stub {
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

#vkormtxwwm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vkormtxwwm .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#vkormtxwwm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vkormtxwwm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#vkormtxwwm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#vkormtxwwm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vkormtxwwm .gt_footnotes {
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

#vkormtxwwm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#vkormtxwwm .gt_sourcenotes {
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

#vkormtxwwm .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#vkormtxwwm .gt_left {
  text-align: left;
}

#vkormtxwwm .gt_center {
  text-align: center;
}

#vkormtxwwm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#vkormtxwwm .gt_font_normal {
  font-weight: normal;
}

#vkormtxwwm .gt_font_bold {
  font-weight: bold;
}

#vkormtxwwm .gt_font_italic {
  font-style: italic;
}

#vkormtxwwm .gt_super {
  font-size: 65%;
}

#vkormtxwwm .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="vkormtxwwm" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#mfajbwchxm .gt_table {
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

#mfajbwchxm .gt_heading {
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

#mfajbwchxm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#mfajbwchxm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#mfajbwchxm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mfajbwchxm .gt_col_headings {
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

#mfajbwchxm .gt_col_heading {
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

#mfajbwchxm .gt_column_spanner_outer {
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

#mfajbwchxm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#mfajbwchxm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#mfajbwchxm .gt_column_spanner {
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

#mfajbwchxm .gt_group_heading {
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

#mfajbwchxm .gt_empty_group_heading {
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

#mfajbwchxm .gt_from_md > :first-child {
  margin-top: 0;
}

#mfajbwchxm .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mfajbwchxm .gt_row {
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

#mfajbwchxm .gt_stub {
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

#mfajbwchxm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mfajbwchxm .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#mfajbwchxm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mfajbwchxm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#mfajbwchxm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#mfajbwchxm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mfajbwchxm .gt_footnotes {
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

#mfajbwchxm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#mfajbwchxm .gt_sourcenotes {
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

#mfajbwchxm .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#mfajbwchxm .gt_left {
  text-align: left;
}

#mfajbwchxm .gt_center {
  text-align: center;
}

#mfajbwchxm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mfajbwchxm .gt_font_normal {
  font-weight: normal;
}

#mfajbwchxm .gt_font_bold {
  font-weight: bold;
}

#mfajbwchxm .gt_font_italic {
  font-style: italic;
}

#mfajbwchxm .gt_super {
  font-size: 65%;
}

#mfajbwchxm .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="mfajbwchxm"
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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

#wnjhipmyfw .gt_table {
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

#wnjhipmyfw .gt_heading {
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

#wnjhipmyfw .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#wnjhipmyfw .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#wnjhipmyfw .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wnjhipmyfw .gt_col_headings {
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

#wnjhipmyfw .gt_col_heading {
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

#wnjhipmyfw .gt_column_spanner_outer {
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

#wnjhipmyfw .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#wnjhipmyfw .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#wnjhipmyfw .gt_column_spanner {
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

#wnjhipmyfw .gt_group_heading {
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

#wnjhipmyfw .gt_empty_group_heading {
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

#wnjhipmyfw .gt_from_md > :first-child {
  margin-top: 0;
}

#wnjhipmyfw .gt_from_md > :last-child {
  margin-bottom: 0;
}

#wnjhipmyfw .gt_row {
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

#wnjhipmyfw .gt_stub {
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

#wnjhipmyfw .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wnjhipmyfw .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#wnjhipmyfw .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wnjhipmyfw .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#wnjhipmyfw .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#wnjhipmyfw .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wnjhipmyfw .gt_footnotes {
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

#wnjhipmyfw .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#wnjhipmyfw .gt_sourcenotes {
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

#wnjhipmyfw .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#wnjhipmyfw .gt_left {
  text-align: left;
}

#wnjhipmyfw .gt_center {
  text-align: center;
}

#wnjhipmyfw .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#wnjhipmyfw .gt_font_normal {
  font-weight: normal;
}

#wnjhipmyfw .gt_font_bold {
  font-weight: bold;
}

#wnjhipmyfw .gt_font_italic {
  font-style: italic;
}

#wnjhipmyfw .gt_super {
  font-size: 65%;
}

#wnjhipmyfw .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="wnjhipmyfw" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#nucmrnbtnf .gt_table {
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

#nucmrnbtnf .gt_heading {
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

#nucmrnbtnf .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#nucmrnbtnf .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#nucmrnbtnf .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nucmrnbtnf .gt_col_headings {
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

#nucmrnbtnf .gt_col_heading {
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

#nucmrnbtnf .gt_column_spanner_outer {
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

#nucmrnbtnf .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nucmrnbtnf .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nucmrnbtnf .gt_column_spanner {
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

#nucmrnbtnf .gt_group_heading {
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

#nucmrnbtnf .gt_empty_group_heading {
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

#nucmrnbtnf .gt_from_md > :first-child {
  margin-top: 0;
}

#nucmrnbtnf .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nucmrnbtnf .gt_row {
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

#nucmrnbtnf .gt_stub {
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

#nucmrnbtnf .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nucmrnbtnf .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#nucmrnbtnf .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nucmrnbtnf .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nucmrnbtnf .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nucmrnbtnf .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nucmrnbtnf .gt_footnotes {
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

#nucmrnbtnf .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#nucmrnbtnf .gt_sourcenotes {
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

#nucmrnbtnf .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#nucmrnbtnf .gt_left {
  text-align: left;
}

#nucmrnbtnf .gt_center {
  text-align: center;
}

#nucmrnbtnf .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nucmrnbtnf .gt_font_normal {
  font-weight: normal;
}

#nucmrnbtnf .gt_font_bold {
  font-weight: bold;
}

#nucmrnbtnf .gt_font_italic {
  font-style: italic;
}

#nucmrnbtnf .gt_super {
  font-size: 65%;
}

#nucmrnbtnf .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="nucmrnbtnf"
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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

#xjbokfmekl .gt_table {
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

#xjbokfmekl .gt_heading {
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

#xjbokfmekl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#xjbokfmekl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#xjbokfmekl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xjbokfmekl .gt_col_headings {
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

#xjbokfmekl .gt_col_heading {
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

#xjbokfmekl .gt_column_spanner_outer {
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

#xjbokfmekl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xjbokfmekl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xjbokfmekl .gt_column_spanner {
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

#xjbokfmekl .gt_group_heading {
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

#xjbokfmekl .gt_empty_group_heading {
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

#xjbokfmekl .gt_from_md > :first-child {
  margin-top: 0;
}

#xjbokfmekl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xjbokfmekl .gt_row {
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

#xjbokfmekl .gt_stub {
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

#xjbokfmekl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xjbokfmekl .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#xjbokfmekl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xjbokfmekl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xjbokfmekl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xjbokfmekl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xjbokfmekl .gt_footnotes {
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

#xjbokfmekl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#xjbokfmekl .gt_sourcenotes {
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

#xjbokfmekl .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#xjbokfmekl .gt_left {
  text-align: left;
}

#xjbokfmekl .gt_center {
  text-align: center;
}

#xjbokfmekl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xjbokfmekl .gt_font_normal {
  font-weight: normal;
}

#xjbokfmekl .gt_font_bold {
  font-weight: bold;
}

#xjbokfmekl .gt_font_italic {
  font-style: italic;
}

#xjbokfmekl .gt_super {
  font-size: 65%;
}

#xjbokfmekl .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="xjbokfmekl" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#iqyxmeyfdy .gt_table {
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

#iqyxmeyfdy .gt_heading {
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

#iqyxmeyfdy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#iqyxmeyfdy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#iqyxmeyfdy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#iqyxmeyfdy .gt_col_headings {
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

#iqyxmeyfdy .gt_col_heading {
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

#iqyxmeyfdy .gt_column_spanner_outer {
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

#iqyxmeyfdy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#iqyxmeyfdy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#iqyxmeyfdy .gt_column_spanner {
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

#iqyxmeyfdy .gt_group_heading {
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

#iqyxmeyfdy .gt_empty_group_heading {
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

#iqyxmeyfdy .gt_from_md > :first-child {
  margin-top: 0;
}

#iqyxmeyfdy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#iqyxmeyfdy .gt_row {
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

#iqyxmeyfdy .gt_stub {
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

#iqyxmeyfdy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#iqyxmeyfdy .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#iqyxmeyfdy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#iqyxmeyfdy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#iqyxmeyfdy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#iqyxmeyfdy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#iqyxmeyfdy .gt_footnotes {
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

#iqyxmeyfdy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#iqyxmeyfdy .gt_sourcenotes {
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

#iqyxmeyfdy .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#iqyxmeyfdy .gt_left {
  text-align: left;
}

#iqyxmeyfdy .gt_center {
  text-align: center;
}

#iqyxmeyfdy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#iqyxmeyfdy .gt_font_normal {
  font-weight: normal;
}

#iqyxmeyfdy .gt_font_bold {
  font-weight: bold;
}

#iqyxmeyfdy .gt_font_italic {
  font-style: italic;
}

#iqyxmeyfdy .gt_super {
  font-size: 65%;
}

#iqyxmeyfdy .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="iqyxmeyfdy"
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
<td class="gt_row gt_left">
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
