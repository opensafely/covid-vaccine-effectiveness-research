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

#tlzqbeyshc .gt_table {
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

#tlzqbeyshc .gt_heading {
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

#tlzqbeyshc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#tlzqbeyshc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#tlzqbeyshc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#tlzqbeyshc .gt_col_headings {
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

#tlzqbeyshc .gt_col_heading {
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

#tlzqbeyshc .gt_column_spanner_outer {
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

#tlzqbeyshc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#tlzqbeyshc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#tlzqbeyshc .gt_column_spanner {
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

#tlzqbeyshc .gt_group_heading {
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

#tlzqbeyshc .gt_empty_group_heading {
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

#tlzqbeyshc .gt_from_md > :first-child {
  margin-top: 0;
}

#tlzqbeyshc .gt_from_md > :last-child {
  margin-bottom: 0;
}

#tlzqbeyshc .gt_row {
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

#tlzqbeyshc .gt_stub {
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

#tlzqbeyshc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#tlzqbeyshc .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#tlzqbeyshc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#tlzqbeyshc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#tlzqbeyshc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#tlzqbeyshc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#tlzqbeyshc .gt_footnotes {
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

#tlzqbeyshc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#tlzqbeyshc .gt_sourcenotes {
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

#tlzqbeyshc .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#tlzqbeyshc .gt_left {
  text-align: left;
}

#tlzqbeyshc .gt_center {
  text-align: center;
}

#tlzqbeyshc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#tlzqbeyshc .gt_font_normal {
  font-weight: normal;
}

#tlzqbeyshc .gt_font_bold {
  font-weight: bold;
}

#tlzqbeyshc .gt_font_italic {
  font-style: italic;
}

#tlzqbeyshc .gt_super {
  font-size: 65%;
}

#tlzqbeyshc .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="tlzqbeyshc" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#aexdxbucon .gt_table {
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

#aexdxbucon .gt_heading {
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

#aexdxbucon .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#aexdxbucon .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#aexdxbucon .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#aexdxbucon .gt_col_headings {
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

#aexdxbucon .gt_col_heading {
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

#aexdxbucon .gt_column_spanner_outer {
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

#aexdxbucon .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#aexdxbucon .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#aexdxbucon .gt_column_spanner {
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

#aexdxbucon .gt_group_heading {
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

#aexdxbucon .gt_empty_group_heading {
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

#aexdxbucon .gt_from_md > :first-child {
  margin-top: 0;
}

#aexdxbucon .gt_from_md > :last-child {
  margin-bottom: 0;
}

#aexdxbucon .gt_row {
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

#aexdxbucon .gt_stub {
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

#aexdxbucon .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#aexdxbucon .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#aexdxbucon .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#aexdxbucon .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#aexdxbucon .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#aexdxbucon .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#aexdxbucon .gt_footnotes {
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

#aexdxbucon .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#aexdxbucon .gt_sourcenotes {
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

#aexdxbucon .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#aexdxbucon .gt_left {
  text-align: left;
}

#aexdxbucon .gt_center {
  text-align: center;
}

#aexdxbucon .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#aexdxbucon .gt_font_normal {
  font-weight: normal;
}

#aexdxbucon .gt_font_bold {
  font-weight: bold;
}

#aexdxbucon .gt_font_italic {
  font-style: italic;
}

#aexdxbucon .gt_super {
  font-size: 65%;
}

#aexdxbucon .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="aexdxbucon"
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
<span class="gt_column_spanner">covid-related all-cause death</span>
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

#ozfbcmnwgj .gt_table {
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

#ozfbcmnwgj .gt_heading {
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

#ozfbcmnwgj .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ozfbcmnwgj .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ozfbcmnwgj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ozfbcmnwgj .gt_col_headings {
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

#ozfbcmnwgj .gt_col_heading {
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

#ozfbcmnwgj .gt_column_spanner_outer {
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

#ozfbcmnwgj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ozfbcmnwgj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ozfbcmnwgj .gt_column_spanner {
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

#ozfbcmnwgj .gt_group_heading {
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

#ozfbcmnwgj .gt_empty_group_heading {
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

#ozfbcmnwgj .gt_from_md > :first-child {
  margin-top: 0;
}

#ozfbcmnwgj .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ozfbcmnwgj .gt_row {
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

#ozfbcmnwgj .gt_stub {
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

#ozfbcmnwgj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ozfbcmnwgj .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ozfbcmnwgj .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ozfbcmnwgj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ozfbcmnwgj .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ozfbcmnwgj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ozfbcmnwgj .gt_footnotes {
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

#ozfbcmnwgj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ozfbcmnwgj .gt_sourcenotes {
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

#ozfbcmnwgj .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ozfbcmnwgj .gt_left {
  text-align: left;
}

#ozfbcmnwgj .gt_center {
  text-align: center;
}

#ozfbcmnwgj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ozfbcmnwgj .gt_font_normal {
  font-weight: normal;
}

#ozfbcmnwgj .gt_font_bold {
  font-weight: bold;
}

#ozfbcmnwgj .gt_font_italic {
  font-style: italic;
}

#ozfbcmnwgj .gt_super {
  font-size: 65%;
}

#ozfbcmnwgj .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ozfbcmnwgj" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#xrncsdjmnf .gt_table {
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

#xrncsdjmnf .gt_heading {
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

#xrncsdjmnf .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#xrncsdjmnf .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#xrncsdjmnf .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xrncsdjmnf .gt_col_headings {
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

#xrncsdjmnf .gt_col_heading {
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

#xrncsdjmnf .gt_column_spanner_outer {
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

#xrncsdjmnf .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xrncsdjmnf .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xrncsdjmnf .gt_column_spanner {
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

#xrncsdjmnf .gt_group_heading {
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

#xrncsdjmnf .gt_empty_group_heading {
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

#xrncsdjmnf .gt_from_md > :first-child {
  margin-top: 0;
}

#xrncsdjmnf .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xrncsdjmnf .gt_row {
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

#xrncsdjmnf .gt_stub {
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

#xrncsdjmnf .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xrncsdjmnf .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#xrncsdjmnf .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xrncsdjmnf .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xrncsdjmnf .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xrncsdjmnf .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xrncsdjmnf .gt_footnotes {
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

#xrncsdjmnf .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#xrncsdjmnf .gt_sourcenotes {
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

#xrncsdjmnf .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#xrncsdjmnf .gt_left {
  text-align: left;
}

#xrncsdjmnf .gt_center {
  text-align: center;
}

#xrncsdjmnf .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xrncsdjmnf .gt_font_normal {
  font-weight: normal;
}

#xrncsdjmnf .gt_font_bold {
  font-weight: bold;
}

#xrncsdjmnf .gt_font_italic {
  font-style: italic;
}

#xrncsdjmnf .gt_super {
  font-size: 65%;
}

#xrncsdjmnf .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="xrncsdjmnf"
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
<span class="gt_column_spanner">covid-related all-cause death</span>
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

#etyfsuwaus .gt_table {
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

#etyfsuwaus .gt_heading {
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

#etyfsuwaus .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#etyfsuwaus .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#etyfsuwaus .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#etyfsuwaus .gt_col_headings {
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

#etyfsuwaus .gt_col_heading {
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

#etyfsuwaus .gt_column_spanner_outer {
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

#etyfsuwaus .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#etyfsuwaus .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#etyfsuwaus .gt_column_spanner {
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

#etyfsuwaus .gt_group_heading {
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

#etyfsuwaus .gt_empty_group_heading {
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

#etyfsuwaus .gt_from_md > :first-child {
  margin-top: 0;
}

#etyfsuwaus .gt_from_md > :last-child {
  margin-bottom: 0;
}

#etyfsuwaus .gt_row {
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

#etyfsuwaus .gt_stub {
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

#etyfsuwaus .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#etyfsuwaus .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#etyfsuwaus .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#etyfsuwaus .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#etyfsuwaus .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#etyfsuwaus .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#etyfsuwaus .gt_footnotes {
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

#etyfsuwaus .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#etyfsuwaus .gt_sourcenotes {
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

#etyfsuwaus .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#etyfsuwaus .gt_left {
  text-align: left;
}

#etyfsuwaus .gt_center {
  text-align: center;
}

#etyfsuwaus .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#etyfsuwaus .gt_font_normal {
  font-weight: normal;
}

#etyfsuwaus .gt_font_bold {
  font-weight: bold;
}

#etyfsuwaus .gt_font_italic {
  font-style: italic;
}

#etyfsuwaus .gt_super {
  font-size: 65%;
}

#etyfsuwaus .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="etyfsuwaus" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#ktbestxovq .gt_table {
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

#ktbestxovq .gt_heading {
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

#ktbestxovq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ktbestxovq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ktbestxovq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ktbestxovq .gt_col_headings {
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

#ktbestxovq .gt_col_heading {
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

#ktbestxovq .gt_column_spanner_outer {
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

#ktbestxovq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ktbestxovq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ktbestxovq .gt_column_spanner {
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

#ktbestxovq .gt_group_heading {
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

#ktbestxovq .gt_empty_group_heading {
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

#ktbestxovq .gt_from_md > :first-child {
  margin-top: 0;
}

#ktbestxovq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ktbestxovq .gt_row {
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

#ktbestxovq .gt_stub {
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

#ktbestxovq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ktbestxovq .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ktbestxovq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ktbestxovq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ktbestxovq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ktbestxovq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ktbestxovq .gt_footnotes {
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

#ktbestxovq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ktbestxovq .gt_sourcenotes {
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

#ktbestxovq .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ktbestxovq .gt_left {
  text-align: left;
}

#ktbestxovq .gt_center {
  text-align: center;
}

#ktbestxovq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ktbestxovq .gt_font_normal {
  font-weight: normal;
}

#ktbestxovq .gt_font_bold {
  font-weight: bold;
}

#ktbestxovq .gt_font_italic {
  font-style: italic;
}

#ktbestxovq .gt_super {
  font-size: 65%;
}

#ktbestxovq .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="ktbestxovq"
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
<span class="gt_column_spanner">covid-related all-cause death</span>
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

#bklcubbtap .gt_table {
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

#bklcubbtap .gt_heading {
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

#bklcubbtap .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#bklcubbtap .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#bklcubbtap .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bklcubbtap .gt_col_headings {
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

#bklcubbtap .gt_col_heading {
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

#bklcubbtap .gt_column_spanner_outer {
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

#bklcubbtap .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bklcubbtap .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bklcubbtap .gt_column_spanner {
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

#bklcubbtap .gt_group_heading {
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

#bklcubbtap .gt_empty_group_heading {
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

#bklcubbtap .gt_from_md > :first-child {
  margin-top: 0;
}

#bklcubbtap .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bklcubbtap .gt_row {
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

#bklcubbtap .gt_stub {
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

#bklcubbtap .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bklcubbtap .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#bklcubbtap .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bklcubbtap .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bklcubbtap .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bklcubbtap .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bklcubbtap .gt_footnotes {
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

#bklcubbtap .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#bklcubbtap .gt_sourcenotes {
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

#bklcubbtap .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#bklcubbtap .gt_left {
  text-align: left;
}

#bklcubbtap .gt_center {
  text-align: center;
}

#bklcubbtap .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bklcubbtap .gt_font_normal {
  font-weight: normal;
}

#bklcubbtap .gt_font_bold {
  font-weight: bold;
}

#bklcubbtap .gt_font_italic {
  font-style: italic;
}

#bklcubbtap .gt_super {
  font-size: 65%;
}

#bklcubbtap .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="bklcubbtap" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#fqyxdnstsl .gt_table {
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

#fqyxdnstsl .gt_heading {
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

#fqyxdnstsl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#fqyxdnstsl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#fqyxdnstsl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fqyxdnstsl .gt_col_headings {
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

#fqyxdnstsl .gt_col_heading {
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

#fqyxdnstsl .gt_column_spanner_outer {
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

#fqyxdnstsl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#fqyxdnstsl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#fqyxdnstsl .gt_column_spanner {
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

#fqyxdnstsl .gt_group_heading {
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

#fqyxdnstsl .gt_empty_group_heading {
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

#fqyxdnstsl .gt_from_md > :first-child {
  margin-top: 0;
}

#fqyxdnstsl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#fqyxdnstsl .gt_row {
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

#fqyxdnstsl .gt_stub {
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

#fqyxdnstsl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fqyxdnstsl .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#fqyxdnstsl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#fqyxdnstsl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#fqyxdnstsl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#fqyxdnstsl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#fqyxdnstsl .gt_footnotes {
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

#fqyxdnstsl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#fqyxdnstsl .gt_sourcenotes {
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

#fqyxdnstsl .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#fqyxdnstsl .gt_left {
  text-align: left;
}

#fqyxdnstsl .gt_center {
  text-align: center;
}

#fqyxdnstsl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#fqyxdnstsl .gt_font_normal {
  font-weight: normal;
}

#fqyxdnstsl .gt_font_bold {
  font-weight: bold;
}

#fqyxdnstsl .gt_font_italic {
  font-style: italic;
}

#fqyxdnstsl .gt_super {
  font-size: 65%;
}

#fqyxdnstsl .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="fqyxdnstsl"
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
<span class="gt_column_spanner">covid-related all-cause death</span>
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

#iktyonwjtl .gt_table {
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

#iktyonwjtl .gt_heading {
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

#iktyonwjtl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#iktyonwjtl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#iktyonwjtl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#iktyonwjtl .gt_col_headings {
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

#iktyonwjtl .gt_col_heading {
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

#iktyonwjtl .gt_column_spanner_outer {
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

#iktyonwjtl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#iktyonwjtl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#iktyonwjtl .gt_column_spanner {
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

#iktyonwjtl .gt_group_heading {
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

#iktyonwjtl .gt_empty_group_heading {
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

#iktyonwjtl .gt_from_md > :first-child {
  margin-top: 0;
}

#iktyonwjtl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#iktyonwjtl .gt_row {
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

#iktyonwjtl .gt_stub {
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

#iktyonwjtl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#iktyonwjtl .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#iktyonwjtl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#iktyonwjtl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#iktyonwjtl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#iktyonwjtl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#iktyonwjtl .gt_footnotes {
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

#iktyonwjtl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#iktyonwjtl .gt_sourcenotes {
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

#iktyonwjtl .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#iktyonwjtl .gt_left {
  text-align: left;
}

#iktyonwjtl .gt_center {
  text-align: center;
}

#iktyonwjtl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#iktyonwjtl .gt_font_normal {
  font-weight: normal;
}

#iktyonwjtl .gt_font_bold {
  font-weight: bold;
}

#iktyonwjtl .gt_font_italic {
  font-style: italic;
}

#iktyonwjtl .gt_super {
  font-size: 65%;
}

#iktyonwjtl .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="iktyonwjtl" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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

#byxoojovjp .gt_table {
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

#byxoojovjp .gt_heading {
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

#byxoojovjp .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#byxoojovjp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#byxoojovjp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#byxoojovjp .gt_col_headings {
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

#byxoojovjp .gt_col_heading {
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

#byxoojovjp .gt_column_spanner_outer {
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

#byxoojovjp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#byxoojovjp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#byxoojovjp .gt_column_spanner {
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

#byxoojovjp .gt_group_heading {
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

#byxoojovjp .gt_empty_group_heading {
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

#byxoojovjp .gt_from_md > :first-child {
  margin-top: 0;
}

#byxoojovjp .gt_from_md > :last-child {
  margin-bottom: 0;
}

#byxoojovjp .gt_row {
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

#byxoojovjp .gt_stub {
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

#byxoojovjp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#byxoojovjp .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#byxoojovjp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#byxoojovjp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#byxoojovjp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#byxoojovjp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#byxoojovjp .gt_footnotes {
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

#byxoojovjp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#byxoojovjp .gt_sourcenotes {
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

#byxoojovjp .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#byxoojovjp .gt_left {
  text-align: left;
}

#byxoojovjp .gt_center {
  text-align: center;
}

#byxoojovjp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#byxoojovjp .gt_font_normal {
  font-weight: normal;
}

#byxoojovjp .gt_font_bold {
  font-weight: bold;
}

#byxoojovjp .gt_font_italic {
  font-style: italic;
}

#byxoojovjp .gt_super {
  font-size: 65%;
}

#byxoojovjp .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>

<div id="byxoojovjp"
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
<span class="gt_column_spanner">covid-related all-cause death</span>
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
