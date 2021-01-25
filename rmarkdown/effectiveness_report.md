## Vaccine effectiveness in OpenSAFELY-TPP data

This report examines covid-related outcomes in TPP-registered patients
who have received a vaccine for SARS-CoV-2.

Outcomes include:

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

The dataset used for this report was created using the study definition
`/analysis/study_definition_delivery.py`, using codelists referenced in
`/codelists/codelists.txt`.

The dataset is based on OpenSAFELY-TPP data extracted on 2021-01-20,
with event dates occurring no later than 2021-01-31.

## Summary

As of 2021-01-31, there were 961580 TPP-registered patients who had
received at least one dose of a vaccine for covid. Of these, 961580
received the Pfizer vaccine and 961580 received the Oxford/AZ vaccine.

## Summaries by patient characteristics

The tables below show, for each characteristic:

-   Vaccine type, including those who have received both vaccine types
-   7-day post-vaccination event rates
-   Cumulative post-vaccination event rates over time.

### Age

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ideeeuslck .gt_table {
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

#ideeeuslck .gt_heading {
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

#ideeeuslck .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ideeeuslck .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ideeeuslck .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ideeeuslck .gt_col_headings {
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

#ideeeuslck .gt_col_heading {
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

#ideeeuslck .gt_column_spanner_outer {
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

#ideeeuslck .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ideeeuslck .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ideeeuslck .gt_column_spanner {
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

#ideeeuslck .gt_group_heading {
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

#ideeeuslck .gt_empty_group_heading {
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

#ideeeuslck .gt_from_md > :first-child {
  margin-top: 0;
}

#ideeeuslck .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ideeeuslck .gt_row {
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

#ideeeuslck .gt_stub {
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

#ideeeuslck .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ideeeuslck .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ideeeuslck .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ideeeuslck .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ideeeuslck .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ideeeuslck .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ideeeuslck .gt_footnotes {
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

#ideeeuslck .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ideeeuslck .gt_sourcenotes {
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

#ideeeuslck .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ideeeuslck .gt_left {
  text-align: left;
}

#ideeeuslck .gt_center {
  text-align: center;
}

#ideeeuslck .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ideeeuslck .gt_font_normal {
  font-weight: normal;
}

#ideeeuslck .gt_font_bold {
  font-weight: bold;
}

#ideeeuslck .gt_font_italic {
  font-style: italic;
}

#ideeeuslck .gt_super {
  font-size: 65%;
}

#ideeeuslck .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ideeeuslck" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
<span class="gt_column_spanner">Oxford/AZ</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Oxford/AZ and Pfizer</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Pfizer</span>
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
<td class="gt_row gt_center">
0-19
</td>
<td class="gt_row gt_center">
356
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
2913
</td>
<td class="gt_row gt_right">
0.3%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
20-29
</td>
<td class="gt_row gt_center">
3550
</td>
<td class="gt_row gt_right">
5.5%
</td>
<td class="gt_row gt_center">
22
</td>
<td class="gt_row gt_right">
7.4%
</td>
<td class="gt_row gt_center">
43360
</td>
<td class="gt_row gt_right">
4.8%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
30-39
</td>
<td class="gt_row gt_center">
4723
</td>
<td class="gt_row gt_right">
7.3%
</td>
<td class="gt_row gt_center">
36
</td>
<td class="gt_row gt_right">
12.1%
</td>
<td class="gt_row gt_center">
67397
</td>
<td class="gt_row gt_right">
7.5%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
40-49
</td>
<td class="gt_row gt_center">
5572
</td>
<td class="gt_row gt_right">
8.6%
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
14.1%
</td>
<td class="gt_row gt_center">
82333
</td>
<td class="gt_row gt_right">
9.2%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
50-59
</td>
<td class="gt_row gt_center">
7932
</td>
<td class="gt_row gt_right">
12.2%
</td>
<td class="gt_row gt_center">
57
</td>
<td class="gt_row gt_right">
19.1%
</td>
<td class="gt_row gt_center">
103234
</td>
<td class="gt_row gt_right">
11.5%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
60-69
</td>
<td class="gt_row gt_center">
4759
</td>
<td class="gt_row gt_right">
7.3%
</td>
<td class="gt_row gt_center">
30
</td>
<td class="gt_row gt_right">
10.1%
</td>
<td class="gt_row gt_center">
53567
</td>
<td class="gt_row gt_right">
6.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
70-79
</td>
<td class="gt_row gt_center">
8014
</td>
<td class="gt_row gt_right">
12.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
71607
</td>
<td class="gt_row gt_right">
8.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
80+
</td>
<td class="gt_row gt_center">
30117
</td>
<td class="gt_row gt_right">
46.3%
</td>
<td class="gt_row gt_center">
99
</td>
<td class="gt_row gt_right">
33.2%
</td>
<td class="gt_row gt_center">
471848
</td>
<td class="gt_row gt_right">
52.6%
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

## 

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ymbvyvdyfl .gt_table {
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

#ymbvyvdyfl .gt_heading {
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

#ymbvyvdyfl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ymbvyvdyfl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ymbvyvdyfl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ymbvyvdyfl .gt_col_headings {
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

#ymbvyvdyfl .gt_col_heading {
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

#ymbvyvdyfl .gt_column_spanner_outer {
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

#ymbvyvdyfl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ymbvyvdyfl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ymbvyvdyfl .gt_column_spanner {
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

#ymbvyvdyfl .gt_group_heading {
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

#ymbvyvdyfl .gt_empty_group_heading {
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

#ymbvyvdyfl .gt_from_md > :first-child {
  margin-top: 0;
}

#ymbvyvdyfl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ymbvyvdyfl .gt_row {
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

#ymbvyvdyfl .gt_stub {
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

#ymbvyvdyfl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ymbvyvdyfl .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ymbvyvdyfl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ymbvyvdyfl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ymbvyvdyfl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ymbvyvdyfl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ymbvyvdyfl .gt_footnotes {
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

#ymbvyvdyfl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ymbvyvdyfl .gt_sourcenotes {
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

#ymbvyvdyfl .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ymbvyvdyfl .gt_left {
  text-align: left;
}

#ymbvyvdyfl .gt_center {
  text-align: center;
}

#ymbvyvdyfl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ymbvyvdyfl .gt_font_normal {
  font-weight: normal;
}

#ymbvyvdyfl .gt_font_bold {
  font-weight: bold;
}

#ymbvyvdyfl .gt_font_italic {
  font-style: italic;
}

#ymbvyvdyfl .gt_super {
  font-size: 65%;
}

#ymbvyvdyfl .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="ymbvyvdyfl" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 7-days
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
<td class="gt_row gt_center">
0-19
</td>
<td class="gt_row gt_center">
3271
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
33
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
20-29
</td>
<td class="gt_row gt_center">
46932
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
468
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
30-39
</td>
<td class="gt_row gt_center">
72156
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
634
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
40-49
</td>
<td class="gt_row gt_center">
87947
</td>
<td class="gt_row gt_center">
15
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
646
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
50-59
</td>
<td class="gt_row gt_center">
111223
</td>
<td class="gt_row gt_center">
41
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
763
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
60-69
</td>
<td class="gt_row gt_center">
58356
</td>
<td class="gt_row gt_center">
11
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
368
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
70-79
</td>
<td class="gt_row gt_center">
79631
</td>
<td class="gt_row gt_center">
8
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
124
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
80+
</td>
<td class="gt_row gt_center">
502064
</td>
<td class="gt_row gt_center">
92
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
697
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
10
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

## 

<img src="C:/Users/whulme/Documents/repos/covid-vaccine-preliminary-study/released_output/tte/figures/plot_patch_ageband.svg" width="90%" />

### Sex

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#xbtngskeax .gt_table {
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

#xbtngskeax .gt_heading {
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

#xbtngskeax .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#xbtngskeax .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#xbtngskeax .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xbtngskeax .gt_col_headings {
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

#xbtngskeax .gt_col_heading {
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

#xbtngskeax .gt_column_spanner_outer {
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

#xbtngskeax .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#xbtngskeax .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#xbtngskeax .gt_column_spanner {
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

#xbtngskeax .gt_group_heading {
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

#xbtngskeax .gt_empty_group_heading {
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

#xbtngskeax .gt_from_md > :first-child {
  margin-top: 0;
}

#xbtngskeax .gt_from_md > :last-child {
  margin-bottom: 0;
}

#xbtngskeax .gt_row {
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

#xbtngskeax .gt_stub {
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

#xbtngskeax .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbtngskeax .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#xbtngskeax .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#xbtngskeax .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#xbtngskeax .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#xbtngskeax .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#xbtngskeax .gt_footnotes {
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

#xbtngskeax .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#xbtngskeax .gt_sourcenotes {
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

#xbtngskeax .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#xbtngskeax .gt_left {
  text-align: left;
}

#xbtngskeax .gt_center {
  text-align: center;
}

#xbtngskeax .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#xbtngskeax .gt_font_normal {
  font-weight: normal;
}

#xbtngskeax .gt_font_bold {
  font-weight: bold;
}

#xbtngskeax .gt_font_italic {
  font-style: italic;
}

#xbtngskeax .gt_super {
  font-size: 65%;
}

#xbtngskeax .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="xbtngskeax" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
<span class="gt_column_spanner">Oxford/AZ</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Oxford/AZ and Pfizer</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Pfizer</span>
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
<td class="gt_row gt_center">
F
</td>
<td class="gt_row gt_center">
44788
</td>
<td class="gt_row gt_right">
68.9%
</td>
<td class="gt_row gt_center">
200
</td>
<td class="gt_row gt_right">
67.1%
</td>
<td class="gt_row gt_center">
568026
</td>
<td class="gt_row gt_right">
63.4%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
M
</td>
<td class="gt_row gt_center">
20235
</td>
<td class="gt_row gt_right">
31.1%
</td>
<td class="gt_row gt_center">
98
</td>
<td class="gt_row gt_right">
32.9%
</td>
<td class="gt_row gt_center">
328224
</td>
<td class="gt_row gt_right">
36.6%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
I
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
U
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
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

## 

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#swceoitnhb .gt_table {
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

#swceoitnhb .gt_heading {
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

#swceoitnhb .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#swceoitnhb .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#swceoitnhb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#swceoitnhb .gt_col_headings {
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

#swceoitnhb .gt_col_heading {
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

#swceoitnhb .gt_column_spanner_outer {
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

#swceoitnhb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#swceoitnhb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#swceoitnhb .gt_column_spanner {
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

#swceoitnhb .gt_group_heading {
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

#swceoitnhb .gt_empty_group_heading {
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

#swceoitnhb .gt_from_md > :first-child {
  margin-top: 0;
}

#swceoitnhb .gt_from_md > :last-child {
  margin-bottom: 0;
}

#swceoitnhb .gt_row {
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

#swceoitnhb .gt_stub {
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

#swceoitnhb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#swceoitnhb .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#swceoitnhb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#swceoitnhb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#swceoitnhb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#swceoitnhb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#swceoitnhb .gt_footnotes {
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

#swceoitnhb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#swceoitnhb .gt_sourcenotes {
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

#swceoitnhb .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#swceoitnhb .gt_left {
  text-align: left;
}

#swceoitnhb .gt_center {
  text-align: center;
}

#swceoitnhb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#swceoitnhb .gt_font_normal {
  font-weight: normal;
}

#swceoitnhb .gt_font_bold {
  font-weight: bold;
}

#swceoitnhb .gt_font_italic {
  font-style: italic;
}

#swceoitnhb .gt_super {
  font-size: 65%;
}

#swceoitnhb .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="swceoitnhb" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 7-days
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
<td class="gt_row gt_center">
F
</td>
<td class="gt_row gt_center">
613014
</td>
<td class="gt_row gt_center">
121
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
2676
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
I
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
M
</td>
<td class="gt_row gt_center">
348557
</td>
<td class="gt_row gt_center">
76
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
1057
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
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
</tr>
<tr>
<td class="gt_row gt_center">
U
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

## 

<img src="C:/Users/whulme/Documents/repos/covid-vaccine-preliminary-study/released_output/tte/figures/plot_patch_sex.svg" width="90%" />

### Ethnicity

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#pruhbyuskr .gt_table {
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

#pruhbyuskr .gt_heading {
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

#pruhbyuskr .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#pruhbyuskr .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#pruhbyuskr .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pruhbyuskr .gt_col_headings {
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

#pruhbyuskr .gt_col_heading {
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

#pruhbyuskr .gt_column_spanner_outer {
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

#pruhbyuskr .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#pruhbyuskr .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#pruhbyuskr .gt_column_spanner {
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

#pruhbyuskr .gt_group_heading {
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

#pruhbyuskr .gt_empty_group_heading {
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

#pruhbyuskr .gt_from_md > :first-child {
  margin-top: 0;
}

#pruhbyuskr .gt_from_md > :last-child {
  margin-bottom: 0;
}

#pruhbyuskr .gt_row {
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

#pruhbyuskr .gt_stub {
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

#pruhbyuskr .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pruhbyuskr .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#pruhbyuskr .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pruhbyuskr .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#pruhbyuskr .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#pruhbyuskr .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pruhbyuskr .gt_footnotes {
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

#pruhbyuskr .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#pruhbyuskr .gt_sourcenotes {
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

#pruhbyuskr .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#pruhbyuskr .gt_left {
  text-align: left;
}

#pruhbyuskr .gt_center {
  text-align: center;
}

#pruhbyuskr .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#pruhbyuskr .gt_font_normal {
  font-weight: normal;
}

#pruhbyuskr .gt_font_bold {
  font-weight: bold;
}

#pruhbyuskr .gt_font_italic {
  font-style: italic;
}

#pruhbyuskr .gt_super {
  font-size: 65%;
}

#pruhbyuskr .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="pruhbyuskr" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
<span class="gt_column_spanner">Oxford/AZ</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Oxford/AZ and Pfizer</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Pfizer</span>
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
<td class="gt_row gt_center">
Black
</td>
<td class="gt_row gt_center">
753
</td>
<td class="gt_row gt_right">
1.2%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
8361
</td>
<td class="gt_row gt_right">
0.9%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
Mixed
</td>
<td class="gt_row gt_center">
315
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
4933
</td>
<td class="gt_row gt_right">
0.6%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
South Asian
</td>
<td class="gt_row gt_center">
2013
</td>
<td class="gt_row gt_right">
3.1%
</td>
<td class="gt_row gt_center">
23
</td>
<td class="gt_row gt_right">
7.7%
</td>
<td class="gt_row gt_center">
40014
</td>
<td class="gt_row gt_right">
4.5%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
White
</td>
<td class="gt_row gt_center">
45779
</td>
<td class="gt_row gt_right">
70.4%
</td>
<td class="gt_row gt_center">
199
</td>
<td class="gt_row gt_right">
66.8%
</td>
<td class="gt_row gt_center">
613254
</td>
<td class="gt_row gt_right">
68.4%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
Other
</td>
<td class="gt_row gt_center">
494
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
8785
</td>
<td class="gt_row gt_right">
1.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
15669
</td>
<td class="gt_row gt_right">
24.1%
</td>
<td class="gt_row gt_center">
64
</td>
<td class="gt_row gt_right">
21.5%
</td>
<td class="gt_row gt_center">
220912
</td>
<td class="gt_row gt_right">
24.6%
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

## 

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#bgwwrjwflh .gt_table {
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

#bgwwrjwflh .gt_heading {
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

#bgwwrjwflh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#bgwwrjwflh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#bgwwrjwflh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bgwwrjwflh .gt_col_headings {
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

#bgwwrjwflh .gt_col_heading {
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

#bgwwrjwflh .gt_column_spanner_outer {
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

#bgwwrjwflh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#bgwwrjwflh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#bgwwrjwflh .gt_column_spanner {
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

#bgwwrjwflh .gt_group_heading {
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

#bgwwrjwflh .gt_empty_group_heading {
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

#bgwwrjwflh .gt_from_md > :first-child {
  margin-top: 0;
}

#bgwwrjwflh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#bgwwrjwflh .gt_row {
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

#bgwwrjwflh .gt_stub {
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

#bgwwrjwflh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bgwwrjwflh .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#bgwwrjwflh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#bgwwrjwflh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#bgwwrjwflh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#bgwwrjwflh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#bgwwrjwflh .gt_footnotes {
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

#bgwwrjwflh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#bgwwrjwflh .gt_sourcenotes {
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

#bgwwrjwflh .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#bgwwrjwflh .gt_left {
  text-align: left;
}

#bgwwrjwflh .gt_center {
  text-align: center;
}

#bgwwrjwflh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#bgwwrjwflh .gt_font_normal {
  font-weight: normal;
}

#bgwwrjwflh .gt_font_bold {
  font-weight: bold;
}

#bgwwrjwflh .gt_font_italic {
  font-style: italic;
}

#bgwwrjwflh .gt_super {
  font-size: 65%;
}

#bgwwrjwflh .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="bgwwrjwflh" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 7-days
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
<td class="gt_row gt_center">
Black
</td>
<td class="gt_row gt_center">
9119
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
62
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
Mixed
</td>
<td class="gt_row gt_center">
5253
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
33
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
South Asian
</td>
<td class="gt_row gt_center">
42050
</td>
<td class="gt_row gt_center">
17
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
294
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
White
</td>
<td class="gt_row gt_center">
659232
</td>
<td class="gt_row gt_center">
129
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
2349
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
Other
</td>
<td class="gt_row gt_center">
9281
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
69
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
236645
</td>
<td class="gt_row gt_center">
51
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
926
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

## 

<img src="C:/Users/whulme/Documents/repos/covid-vaccine-preliminary-study/released_output/tte/figures/plot_patch_ethnicity.svg" width="90%" />

### Index of Multiple Deprivation (IMD)

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#dlssbrxpvd .gt_table {
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

#dlssbrxpvd .gt_heading {
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

#dlssbrxpvd .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dlssbrxpvd .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dlssbrxpvd .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dlssbrxpvd .gt_col_headings {
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

#dlssbrxpvd .gt_col_heading {
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

#dlssbrxpvd .gt_column_spanner_outer {
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

#dlssbrxpvd .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dlssbrxpvd .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dlssbrxpvd .gt_column_spanner {
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

#dlssbrxpvd .gt_group_heading {
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

#dlssbrxpvd .gt_empty_group_heading {
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

#dlssbrxpvd .gt_from_md > :first-child {
  margin-top: 0;
}

#dlssbrxpvd .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dlssbrxpvd .gt_row {
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

#dlssbrxpvd .gt_stub {
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

#dlssbrxpvd .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dlssbrxpvd .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#dlssbrxpvd .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dlssbrxpvd .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dlssbrxpvd .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dlssbrxpvd .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dlssbrxpvd .gt_footnotes {
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

#dlssbrxpvd .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#dlssbrxpvd .gt_sourcenotes {
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

#dlssbrxpvd .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#dlssbrxpvd .gt_left {
  text-align: left;
}

#dlssbrxpvd .gt_center {
  text-align: center;
}

#dlssbrxpvd .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dlssbrxpvd .gt_font_normal {
  font-weight: normal;
}

#dlssbrxpvd .gt_font_bold {
  font-weight: bold;
}

#dlssbrxpvd .gt_font_italic {
  font-style: italic;
}

#dlssbrxpvd .gt_super {
  font-size: 65%;
}

#dlssbrxpvd .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="dlssbrxpvd" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
<span class="gt_column_spanner">Oxford/AZ</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Oxford/AZ and Pfizer</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Pfizer</span>
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
<td class="gt_row gt_center">
1 least deprived
</td>
<td class="gt_row gt_center">
10807
</td>
<td class="gt_row gt_right">
16.6%
</td>
<td class="gt_row gt_center">
59
</td>
<td class="gt_row gt_right">
19.8%
</td>
<td class="gt_row gt_center">
123159
</td>
<td class="gt_row gt_right">
13.7%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
2
</td>
<td class="gt_row gt_center">
12065
</td>
<td class="gt_row gt_right">
18.6%
</td>
<td class="gt_row gt_center">
63
</td>
<td class="gt_row gt_right">
21.1%
</td>
<td class="gt_row gt_center">
153009
</td>
<td class="gt_row gt_right">
17.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
3
</td>
<td class="gt_row gt_center">
14188
</td>
<td class="gt_row gt_right">
21.8%
</td>
<td class="gt_row gt_center">
67
</td>
<td class="gt_row gt_right">
22.5%
</td>
<td class="gt_row gt_center">
187933
</td>
<td class="gt_row gt_right">
21.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
4
</td>
<td class="gt_row gt_center">
13447
</td>
<td class="gt_row gt_right">
20.7%
</td>
<td class="gt_row gt_center">
51
</td>
<td class="gt_row gt_right">
17.1%
</td>
<td class="gt_row gt_center">
204795
</td>
<td class="gt_row gt_right">
22.8%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
5 most deprived
</td>
<td class="gt_row gt_center">
13197
</td>
<td class="gt_row gt_right">
20.3%
</td>
<td class="gt_row gt_center">
48
</td>
<td class="gt_row gt_right">
16.1%
</td>
<td class="gt_row gt_center">
207346
</td>
<td class="gt_row gt_right">
23.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
1319
</td>
<td class="gt_row gt_right">
2.0%
</td>
<td class="gt_row gt_center">
10
</td>
<td class="gt_row gt_right">
3.4%
</td>
<td class="gt_row gt_center">
20017
</td>
<td class="gt_row gt_right">
2.2%
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

## 

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#mqwkwuhrre .gt_table {
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

#mqwkwuhrre .gt_heading {
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

#mqwkwuhrre .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#mqwkwuhrre .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#mqwkwuhrre .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mqwkwuhrre .gt_col_headings {
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

#mqwkwuhrre .gt_col_heading {
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

#mqwkwuhrre .gt_column_spanner_outer {
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

#mqwkwuhrre .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#mqwkwuhrre .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#mqwkwuhrre .gt_column_spanner {
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

#mqwkwuhrre .gt_group_heading {
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

#mqwkwuhrre .gt_empty_group_heading {
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

#mqwkwuhrre .gt_from_md > :first-child {
  margin-top: 0;
}

#mqwkwuhrre .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mqwkwuhrre .gt_row {
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

#mqwkwuhrre .gt_stub {
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

#mqwkwuhrre .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mqwkwuhrre .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#mqwkwuhrre .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mqwkwuhrre .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#mqwkwuhrre .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#mqwkwuhrre .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mqwkwuhrre .gt_footnotes {
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

#mqwkwuhrre .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#mqwkwuhrre .gt_sourcenotes {
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

#mqwkwuhrre .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#mqwkwuhrre .gt_left {
  text-align: left;
}

#mqwkwuhrre .gt_center {
  text-align: center;
}

#mqwkwuhrre .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mqwkwuhrre .gt_font_normal {
  font-weight: normal;
}

#mqwkwuhrre .gt_font_bold {
  font-weight: bold;
}

#mqwkwuhrre .gt_font_italic {
  font-style: italic;
}

#mqwkwuhrre .gt_super {
  font-size: 65%;
}

#mqwkwuhrre .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="mqwkwuhrre" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 7-days
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
<td class="gt_row gt_center">
1 least deprived
</td>
<td class="gt_row gt_center">
134025
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
587
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
2
</td>
<td class="gt_row gt_center">
165137
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
727
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
3
</td>
<td class="gt_row gt_center">
202188
</td>
<td class="gt_row gt_center">
54
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
884
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
4
</td>
<td class="gt_row gt_center">
218293
</td>
<td class="gt_row gt_center">
43
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
767
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
5 most deprived
</td>
<td class="gt_row gt_center">
220591
</td>
<td class="gt_row gt_center">
28
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
657
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
21346
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
111
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

## 

<img src="C:/Users/whulme/Documents/repos/covid-vaccine-preliminary-study/released_output/tte/figures/plot_patch_imd.svg" width="90%" />

### STP

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#voziqaagmc .gt_table {
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

#voziqaagmc .gt_heading {
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

#voziqaagmc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#voziqaagmc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#voziqaagmc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#voziqaagmc .gt_col_headings {
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

#voziqaagmc .gt_col_heading {
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

#voziqaagmc .gt_column_spanner_outer {
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

#voziqaagmc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#voziqaagmc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#voziqaagmc .gt_column_spanner {
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

#voziqaagmc .gt_group_heading {
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

#voziqaagmc .gt_empty_group_heading {
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

#voziqaagmc .gt_from_md > :first-child {
  margin-top: 0;
}

#voziqaagmc .gt_from_md > :last-child {
  margin-bottom: 0;
}

#voziqaagmc .gt_row {
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

#voziqaagmc .gt_stub {
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

#voziqaagmc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#voziqaagmc .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#voziqaagmc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#voziqaagmc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#voziqaagmc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#voziqaagmc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#voziqaagmc .gt_footnotes {
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

#voziqaagmc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#voziqaagmc .gt_sourcenotes {
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

#voziqaagmc .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#voziqaagmc .gt_left {
  text-align: left;
}

#voziqaagmc .gt_center {
  text-align: center;
}

#voziqaagmc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#voziqaagmc .gt_font_normal {
  font-weight: normal;
}

#voziqaagmc .gt_font_bold {
  font-weight: bold;
}

#voziqaagmc .gt_font_italic {
  font-style: italic;
}

#voziqaagmc .gt_super {
  font-size: 65%;
}

#voziqaagmc .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="voziqaagmc" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
STP
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Oxford/AZ</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Oxford/AZ and Pfizer</span>
</th>
<th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2">
<span class="gt_column_spanner">Pfizer</span>
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
<td class="gt_row gt_center">
E54000005
</td>
<td class="gt_row gt_center">
6465
</td>
<td class="gt_row gt_right">
9.9%
</td>
<td class="gt_row gt_center">
15
</td>
<td class="gt_row gt_right">
5.0%
</td>
<td class="gt_row gt_center">
87747
</td>
<td class="gt_row gt_right">
9.8%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000006
</td>
<td class="gt_row gt_center">
3396
</td>
<td class="gt_row gt_right">
5.2%
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
4.7%
</td>
<td class="gt_row gt_center">
48880
</td>
<td class="gt_row gt_right">
5.5%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000007
</td>
<td class="gt_row gt_center">
207
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
8
</td>
<td class="gt_row gt_right">
2.7%
</td>
<td class="gt_row gt_center">
4370
</td>
<td class="gt_row gt_right">
0.5%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000008
</td>
<td class="gt_row gt_center">
531
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
6069
</td>
<td class="gt_row gt_right">
0.7%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000009
</td>
<td class="gt_row gt_center">
4552
</td>
<td class="gt_row gt_right">
7.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
54706
</td>
<td class="gt_row gt_right">
6.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000010
</td>
<td class="gt_row gt_center">
272
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
3252
</td>
<td class="gt_row gt_right">
0.4%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000012
</td>
<td class="gt_row gt_center">
1375
</td>
<td class="gt_row gt_right">
2.1%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
29277
</td>
<td class="gt_row gt_right">
3.3%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000013
</td>
<td class="gt_row gt_center">
1750
</td>
<td class="gt_row gt_right">
2.7%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
25905
</td>
<td class="gt_row gt_right">
2.9%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000014
</td>
<td class="gt_row gt_center">
1048
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
27251
</td>
<td class="gt_row gt_right">
3.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000015
</td>
<td class="gt_row gt_center">
2163
</td>
<td class="gt_row gt_right">
3.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
31446
</td>
<td class="gt_row gt_right">
3.5%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000016
</td>
<td class="gt_row gt_center">
913
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
8794
</td>
<td class="gt_row gt_right">
1.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000017
</td>
<td class="gt_row gt_center">
2080
</td>
<td class="gt_row gt_right">
3.2%
</td>
<td class="gt_row gt_center">
6
</td>
<td class="gt_row gt_right">
2.0%
</td>
<td class="gt_row gt_center">
24387
</td>
<td class="gt_row gt_right">
2.7%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000020
</td>
<td class="gt_row gt_center">
686
</td>
<td class="gt_row gt_right">
1.1%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
2.3%
</td>
<td class="gt_row gt_center">
32917
</td>
<td class="gt_row gt_right">
3.7%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000021
</td>
<td class="gt_row gt_center">
863
</td>
<td class="gt_row gt_right">
1.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
18893
</td>
<td class="gt_row gt_right">
2.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000022
</td>
<td class="gt_row gt_center">
2077
</td>
<td class="gt_row gt_right">
3.2%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
32281
</td>
<td class="gt_row gt_right">
3.6%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000023
</td>
<td class="gt_row gt_center">
1169
</td>
<td class="gt_row gt_right">
1.8%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
16732
</td>
<td class="gt_row gt_right">
1.9%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000024
</td>
<td class="gt_row gt_center">
2591
</td>
<td class="gt_row gt_right">
4.0%
</td>
<td class="gt_row gt_center">
23
</td>
<td class="gt_row gt_right">
7.7%
</td>
<td class="gt_row gt_center">
26862
</td>
<td class="gt_row gt_right">
3.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000025
</td>
<td class="gt_row gt_center">
4613
</td>
<td class="gt_row gt_right">
7.1%
</td>
<td class="gt_row gt_center">
10
</td>
<td class="gt_row gt_right">
3.4%
</td>
<td class="gt_row gt_center">
31248
</td>
<td class="gt_row gt_right">
3.5%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000026
</td>
<td class="gt_row gt_center">
3500
</td>
<td class="gt_row gt_right">
5.4%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
36140
</td>
<td class="gt_row gt_right">
4.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000027
</td>
<td class="gt_row gt_center">
1914
</td>
<td class="gt_row gt_right">
2.9%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
2.3%
</td>
<td class="gt_row gt_center">
29186
</td>
<td class="gt_row gt_right">
3.3%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000029
</td>
<td class="gt_row gt_center">
113
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
2207
</td>
<td class="gt_row gt_right">
0.2%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000033
</td>
<td class="gt_row gt_center">
2582
</td>
<td class="gt_row gt_right">
4.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
33549
</td>
<td class="gt_row gt_right">
3.7%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000035
</td>
<td class="gt_row gt_center">
171
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
1939
</td>
<td class="gt_row gt_right">
0.2%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000036
</td>
<td class="gt_row gt_center">
1175
</td>
<td class="gt_row gt_right">
1.8%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
10693
</td>
<td class="gt_row gt_right">
1.2%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000037
</td>
<td class="gt_row gt_center">
1961
</td>
<td class="gt_row gt_right">
3.0%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
39931
</td>
<td class="gt_row gt_right">
4.5%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000040
</td>
<td class="gt_row gt_center">
2438
</td>
<td class="gt_row gt_right">
3.7%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
32278
</td>
<td class="gt_row gt_right">
3.6%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000041
</td>
<td class="gt_row gt_center">
2665
</td>
<td class="gt_row gt_right">
4.1%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
34724
</td>
<td class="gt_row gt_right">
3.9%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000042
</td>
<td class="gt_row gt_center">
3376
</td>
<td class="gt_row gt_right">
5.2%
</td>
<td class="gt_row gt_center">
17
</td>
<td class="gt_row gt_right">
5.7%
</td>
<td class="gt_row gt_center">
36858
</td>
<td class="gt_row gt_right">
4.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000043
</td>
<td class="gt_row gt_center">
1613
</td>
<td class="gt_row gt_right">
2.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
37730
</td>
<td class="gt_row gt_right">
4.2%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000044
</td>
<td class="gt_row gt_center">
67
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
298
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000049
</td>
<td class="gt_row gt_center">
6696
</td>
<td class="gt_row gt_right">
10.3%
</td>
<td class="gt_row gt_center">
147
</td>
<td class="gt_row gt_right">
49.3%
</td>
<td class="gt_row gt_center">
89634
</td>
<td class="gt_row gt_right">
10.0%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
75
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

## 

<!--html_preserve-->
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#qbcwkoyryc .gt_table {
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

#qbcwkoyryc .gt_heading {
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

#qbcwkoyryc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#qbcwkoyryc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#qbcwkoyryc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qbcwkoyryc .gt_col_headings {
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

#qbcwkoyryc .gt_col_heading {
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

#qbcwkoyryc .gt_column_spanner_outer {
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

#qbcwkoyryc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#qbcwkoyryc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#qbcwkoyryc .gt_column_spanner {
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

#qbcwkoyryc .gt_group_heading {
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

#qbcwkoyryc .gt_empty_group_heading {
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

#qbcwkoyryc .gt_from_md > :first-child {
  margin-top: 0;
}

#qbcwkoyryc .gt_from_md > :last-child {
  margin-bottom: 0;
}

#qbcwkoyryc .gt_row {
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

#qbcwkoyryc .gt_stub {
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

#qbcwkoyryc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qbcwkoyryc .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#qbcwkoyryc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#qbcwkoyryc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#qbcwkoyryc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#qbcwkoyryc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#qbcwkoyryc .gt_footnotes {
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

#qbcwkoyryc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#qbcwkoyryc .gt_sourcenotes {
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

#qbcwkoyryc .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#qbcwkoyryc .gt_left {
  text-align: left;
}

#qbcwkoyryc .gt_center {
  text-align: center;
}

#qbcwkoyryc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#qbcwkoyryc .gt_font_normal {
  font-weight: normal;
}

#qbcwkoyryc .gt_font_bold {
  font-weight: bold;
}

#qbcwkoyryc .gt_font_italic {
  font-style: italic;
}

#qbcwkoyryc .gt_super {
  font-size: 65%;
}

#qbcwkoyryc .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="qbcwkoyryc" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="12" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 7-days
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
STP
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
<td class="gt_row gt_center">
E54000005
</td>
<td class="gt_row gt_center">
94227
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
151
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000006
</td>
<td class="gt_row gt_center">
52290
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
134
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000007
</td>
<td class="gt_row gt_center">
4585
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000008
</td>
<td class="gt_row gt_center">
6604
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
13
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000009
</td>
<td class="gt_row gt_center">
59260
</td>
<td class="gt_row gt_center">
9
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
106
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000010
</td>
<td class="gt_row gt_center">
3524
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
16
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000012
</td>
<td class="gt_row gt_center">
30653
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
121
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000013
</td>
<td class="gt_row gt_center">
27655
</td>
<td class="gt_row gt_center">
24
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
102
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000014
</td>
<td class="gt_row gt_center">
28299
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
128
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000015
</td>
<td class="gt_row gt_center">
33612
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
111
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000016
</td>
<td class="gt_row gt_center">
9712
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
36
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000017
</td>
<td class="gt_row gt_center">
26473
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
114
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000020
</td>
<td class="gt_row gt_center">
33610
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
85
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000021
</td>
<td class="gt_row gt_center">
19756
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
84
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000022
</td>
<td class="gt_row gt_center">
34361
</td>
<td class="gt_row gt_center">
11
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
180
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000023
</td>
<td class="gt_row gt_center">
17905
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
129
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000024
</td>
<td class="gt_row gt_center">
29476
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
150
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000025
</td>
<td class="gt_row gt_center">
35871
</td>
<td class="gt_row gt_center">
8
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
185
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000026
</td>
<td class="gt_row gt_center">
39644
</td>
<td class="gt_row gt_center">
17
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
251
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000027
</td>
<td class="gt_row gt_center">
31107
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
157
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000029
</td>
<td class="gt_row gt_center">
2320
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
13
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000033
</td>
<td class="gt_row gt_center">
36136
</td>
<td class="gt_row gt_center">
10
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
210
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000035
</td>
<td class="gt_row gt_center">
2110
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000036
</td>
<td class="gt_row gt_center">
11872
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
38
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000037
</td>
<td class="gt_row gt_center">
41896
</td>
<td class="gt_row gt_center">
11
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
148
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000040
</td>
<td class="gt_row gt_center">
34717
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
131
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000041
</td>
<td class="gt_row gt_center">
37390
</td>
<td class="gt_row gt_center">
6
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
179
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000042
</td>
<td class="gt_row gt_center">
40251
</td>
<td class="gt_row gt_center">
16
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
296
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000043
</td>
<td class="gt_row gt_center">
39346
</td>
<td class="gt_row gt_center">
8
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
108
</td>
<td class="gt_row gt_right">
0.3%
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000044
</td>
<td class="gt_row gt_center">
365
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
E54000049
</td>
<td class="gt_row gt_center">
96477
</td>
<td class="gt_row gt_center">
27
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
344
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
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
<tr>
<td class="gt_row gt_center">
(missing)
</td>
<td class="gt_row gt_center">
76
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="12">

-   indicates redacted values
    </td>
    </tr>
    </tfoot>

</table>
</div>
<!--/html_preserve-->

## 

<img src="C:/Users/whulme/Documents/repos/covid-vaccine-preliminary-study/released_output/tte/figures/plot_patch_stp.svg" width="90%" />
