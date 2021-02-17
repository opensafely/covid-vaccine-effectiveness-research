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
data extracted on 2021-02-16, with event dates censored on (occurring no
later than) 2021-01-19.

To minimise data disclosivity in frequency tables, counts are rounded to
the nearest 7 and percentages are derived from these rounded counts.

## Summary

As of 2021-01-19, there were 4617128 TPP-registered patients who had
received at least one vaccine dose. Of these, 2626706 received the
Pfizer-BioNTech (P-B) vaccine and 1988537 received the
Oxford-AstraZenica (Ox-AZ) vaccine. Brand is unknown for the remaining
1885 patients.

## Summaries by patient characteristics

The tables below show, for each characteristic:

-   Vaccine type, including those who have received both vaccine types
-   7-day post-vaccination event rates
-   Cumulative post-vaccination event rates over time
-   Estimated hazard rates over time.

### Sex

<!--html_preserve-->

<div id="tsfximfqtj" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
1135911
</td>
<td class="gt_row gt_right">
57.1%
</td>
<td class="gt_row gt_center">
1615579
</td>
<td class="gt_row gt_right">
61.5%
</td>
<td class="gt_row gt_center">
1176
</td>
<td class="gt_row gt_right">
62.4%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
Male
</td>
<td class="gt_row gt_center">
852628
</td>
<td class="gt_row gt_right">
42.9%
</td>
<td class="gt_row gt_center">
1011129
</td>
<td class="gt_row gt_right">
38.5%
</td>
<td class="gt_row gt_center">
707
</td>
<td class="gt_row gt_right">
37.6%
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

<div id="bxgaaoqbcn"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="14" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
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
<span class="gt_column_spanner">seconddose</span>
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
306936
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
448
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
4018
</td>
<td class="gt_row gt_right">
1.3%
</td>
<td class="gt_row gt_center">
35
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
56
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
<tr>
<td class="gt_row gt_center">
Male
</td>
<td class="gt_row gt_center">
184401
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
245
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
1624
</td>
<td class="gt_row gt_right">
0.9%
</td>
<td class="gt_row gt_center">
42
</td>
<td class="gt_row gt_right">
0.0%
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
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="14">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>

<img src="../released_outputs/output/tte/figures/plot_patch_sex.svg" title="outcomes by Sex" style="width:80.0%" />

### Age

<div id="jtwypddjfq" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
256242
</td>
<td class="gt_row gt_right">
12.9%
</td>
<td class="gt_row gt_center">
596638
</td>
<td class="gt_row gt_right">
22.7%
</td>
<td class="gt_row gt_center">
322
</td>
<td class="gt_row gt_right">
17.0%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
50s
</td>
<td class="gt_row gt_center">
162092
</td>
<td class="gt_row gt_right">
8.2%
</td>
<td class="gt_row gt_center">
289324
</td>
<td class="gt_row gt_right">
11.0%
</td>
<td class="gt_row gt_center">
189
</td>
<td class="gt_row gt_right">
10.0%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
60s
</td>
<td class="gt_row gt_center">
344680
</td>
<td class="gt_row gt_right">
17.3%
</td>
<td class="gt_row gt_center">
279188
</td>
<td class="gt_row gt_right">
10.6%
</td>
<td class="gt_row gt_center">
217
</td>
<td class="gt_row gt_right">
11.6%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
70s
</td>
<td class="gt_row gt_center">
954436
</td>
<td class="gt_row gt_right">
48.0%
</td>
<td class="gt_row gt_center">
763406
</td>
<td class="gt_row gt_right">
29.1%
</td>
<td class="gt_row gt_center">
567
</td>
<td class="gt_row gt_right">
30.2%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
80+
</td>
<td class="gt_row gt_center">
271082
</td>
<td class="gt_row gt_right">
13.6%
</td>
<td class="gt_row gt_center">
698145
</td>
<td class="gt_row gt_right">
26.6%
</td>
<td class="gt_row gt_center">
588
</td>
<td class="gt_row gt_right">
31.2%
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


<div id="leofokcsks"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="14" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
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
<span class="gt_column_spanner">seconddose</span>
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
108689
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
161
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
2597
</td>
<td class="gt_row gt_right">
2.4%
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
55881
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
112
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
1113
</td>
<td class="gt_row gt_right">
2.0%
</td>
<td class="gt_row gt_center">
7
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
25025
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
0.2%
</td>
<td class="gt_row gt_center">
434
</td>
<td class="gt_row gt_right">
1.7%
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
40607
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
56
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
287
</td>
<td class="gt_row gt_right">
0.7%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
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
80+
</td>
<td class="gt_row gt_center">
261128
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
322
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
1204
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
63
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
77
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
343
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="14">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>


<img src="../released_outputs/output/tte/figures/plot_patch_ageband.svg" title="outcomes by Age" style="width:80.0%" />

### Ethnicity


<div id="aalgpghrhk" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
20146
</td>
<td class="gt_row gt_right">
1.0%
</td>
<td class="gt_row gt_center">
30604
</td>
<td class="gt_row gt_right">
1.2%
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
1.2%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
Mixed
</td>
<td class="gt_row gt_center">
8526
</td>
<td class="gt_row gt_right">
0.4%
</td>
<td class="gt_row gt_center">
14917
</td>
<td class="gt_row gt_right">
0.6%
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
1.0%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
South Asian
</td>
<td class="gt_row gt_center">
63931
</td>
<td class="gt_row gt_right">
3.2%
</td>
<td class="gt_row gt_center">
109144
</td>
<td class="gt_row gt_right">
4.2%
</td>
<td class="gt_row gt_center">
98
</td>
<td class="gt_row gt_right">
5.3%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
White
</td>
<td class="gt_row gt_center">
1442091
</td>
<td class="gt_row gt_right">
72.5%
</td>
<td class="gt_row gt_center">
1841217
</td>
<td class="gt_row gt_right">
70.1%
</td>
<td class="gt_row gt_center">
1344
</td>
<td class="gt_row gt_right">
71.4%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
Other
</td>
<td class="gt_row gt_center">
13307
</td>
<td class="gt_row gt_right">
0.7%
</td>
<td class="gt_row gt_center">
23877
</td>
<td class="gt_row gt_right">
0.9%
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.8%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
(missing)
</td>
<td class="gt_row gt_center">
440531
</td>
<td class="gt_row gt_right">
22.2%
</td>
<td class="gt_row gt_center">
606942
</td>
<td class="gt_row gt_right">
23.1%
</td>
<td class="gt_row gt_center">
385
</td>
<td class="gt_row gt_right">
20.4%
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


<div id="vatvrbhwfa"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="14" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
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
<span class="gt_column_spanner">seconddose</span>
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
4389
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
0.2%
</td>
<td class="gt_row gt_center">
105
</td>
<td class="gt_row gt_right">
2.4%
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
2786
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
0.2%
</td>
<td class="gt_row gt_center">
63
</td>
<td class="gt_row gt_right">
2.3%
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
23618
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
0.2%
</td>
<td class="gt_row gt_center">
518
</td>
<td class="gt_row gt_right">
2.2%
</td>
<td class="gt_row gt_center">
7
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
333858
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
462
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
3486
</td>
<td class="gt_row gt_right">
1.0%
</td>
<td class="gt_row gt_center">
56
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
63
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
287
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
5075
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
0.2%
</td>
<td class="gt_row gt_center">
112
</td>
<td class="gt_row gt_right">
2.2%
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
121611
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
161
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
1358
</td>
<td class="gt_row gt_right">
1.1%
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
35
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
112
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="14">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>



<img src="../released_outputs/output/tte/figures/plot_patch_ethnicity.svg" title="outcomes by Ethnicity" style="width:80.0%" />

### Index of Multiple Deprivation (IMD)


<div id="oaugkwhkqp" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
294525
</td>
<td class="gt_row gt_right">
14.8%
</td>
<td class="gt_row gt_center">
360801
</td>
<td class="gt_row gt_right">
13.7%
</td>
<td class="gt_row gt_center">
364
</td>
<td class="gt_row gt_right">
19.4%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
2
</td>
<td class="gt_row gt_center">
351281
</td>
<td class="gt_row gt_right">
17.7%
</td>
<td class="gt_row gt_center">
461104
</td>
<td class="gt_row gt_right">
17.6%
</td>
<td class="gt_row gt_center">
343
</td>
<td class="gt_row gt_right">
18.1%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
3
</td>
<td class="gt_row gt_center">
439425
</td>
<td class="gt_row gt_right">
22.1%
</td>
<td class="gt_row gt_center">
574581
</td>
<td class="gt_row gt_right">
21.9%
</td>
<td class="gt_row gt_center">
371
</td>
<td class="gt_row gt_right">
19.8%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
4
</td>
<td class="gt_row gt_center">
437885
</td>
<td class="gt_row gt_right">
22.0%
</td>
<td class="gt_row gt_center">
593061
</td>
<td class="gt_row gt_right">
22.6%
</td>
<td class="gt_row gt_center">
329
</td>
<td class="gt_row gt_right">
17.4%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
5 most deprived
</td>
<td class="gt_row gt_center">
426664
</td>
<td class="gt_row gt_right">
21.5%
</td>
<td class="gt_row gt_center">
582386
</td>
<td class="gt_row gt_right">
22.2%
</td>
<td class="gt_row gt_center">
364
</td>
<td class="gt_row gt_right">
19.4%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
(missing)
</td>
<td class="gt_row gt_center">
38759
</td>
<td class="gt_row gt_right">
1.9%
</td>
<td class="gt_row gt_center">
54775
</td>
<td class="gt_row gt_right">
2.1%
</td>
<td class="gt_row gt_center">
112
</td>
<td class="gt_row gt_right">
5.9%
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


<div id="henszsymut"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="14" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
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
<span class="gt_column_spanner">seconddose</span>
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
67494
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
119
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
903
</td>
<td class="gt_row gt_right">
1.3%
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.0%
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
<tr>
<td class="gt_row gt_center">
2
</td>
<td class="gt_row gt_center">
84119
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
147
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
1106
</td>
<td class="gt_row gt_right">
1.3%
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
70
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
103208
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
161
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
1253
</td>
<td class="gt_row gt_right">
1.2%
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
0.0%
</td>
<td class="gt_row gt_center">
91
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
112161
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
147
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
1190
</td>
<td class="gt_row gt_right">
1.1%
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
14
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
<tr>
<td class="gt_row gt_center">
5 most deprived
</td>
<td class="gt_row gt_center">
112938
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
112
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
1064
</td>
<td class="gt_row gt_right">
0.9%
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
14
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
91
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
11410
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
0.1%
</td>
<td class="gt_row gt_center">
133
</td>
<td class="gt_row gt_right">
1.1%
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
7
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="14">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>



<img src="../released_outputs/output/tte/figures/plot_patch_imd.svg" title="outcomes by IMD" style="width:80.0%" />

### Region

<div id="khzwlntvez" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
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
459242
</td>
<td class="gt_row gt_right">
23.1%
</td>
<td class="gt_row gt_center">
620599
</td>
<td class="gt_row gt_right">
23.6%
</td>
<td class="gt_row gt_center">
315
</td>
<td class="gt_row gt_right">
16.8%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
East Midlands
</td>
<td class="gt_row gt_center">
350770
</td>
<td class="gt_row gt_right">
17.6%
</td>
<td class="gt_row gt_center">
457086
</td>
<td class="gt_row gt_right">
17.4%
</td>
<td class="gt_row gt_center">
504
</td>
<td class="gt_row gt_right">
26.6%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
London
</td>
<td class="gt_row gt_center">
71470
</td>
<td class="gt_row gt_right">
3.6%
</td>
<td class="gt_row gt_center">
117894
</td>
<td class="gt_row gt_right">
4.5%
</td>
<td class="gt_row gt_center">
105
</td>
<td class="gt_row gt_right">
5.6%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
North East
</td>
<td class="gt_row gt_center">
93786
</td>
<td class="gt_row gt_right">
4.7%
</td>
<td class="gt_row gt_center">
122374
</td>
<td class="gt_row gt_right">
4.7%
</td>
<td class="gt_row gt_center">
49
</td>
<td class="gt_row gt_right">
2.4%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
North West
</td>
<td class="gt_row gt_center">
184135
</td>
<td class="gt_row gt_right">
9.3%
</td>
<td class="gt_row gt_center">
242235
</td>
<td class="gt_row gt_right">
9.2%
</td>
<td class="gt_row gt_center">
378
</td>
<td class="gt_row gt_right">
20.0%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
South East
</td>
<td class="gt_row gt_center">
141302
</td>
<td class="gt_row gt_right">
7.1%
</td>
<td class="gt_row gt_center">
192332
</td>
<td class="gt_row gt_right">
7.3%
</td>
<td class="gt_row gt_center">
112
</td>
<td class="gt_row gt_right">
5.8%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
South West
</td>
<td class="gt_row gt_center">
316750
</td>
<td class="gt_row gt_right">
15.9%
</td>
<td class="gt_row gt_center">
436177
</td>
<td class="gt_row gt_right">
16.6%
</td>
<td class="gt_row gt_center">
133
</td>
<td class="gt_row gt_right">
7.2%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
West Midlands
</td>
<td class="gt_row gt_center">
75341
</td>
<td class="gt_row gt_right">
3.8%
</td>
<td class="gt_row gt_center">
88158
</td>
<td class="gt_row gt_right">
3.4%
</td>
<td class="gt_row gt_center">
77
</td>
<td class="gt_row gt_right">
4.0%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
Yorkshire and The Humber
</td>
<td class="gt_row gt_center">
295547
</td>
<td class="gt_row gt_right">
14.9%
</td>
<td class="gt_row gt_center">
349454
</td>
<td class="gt_row gt_right">
13.3%
</td>
<td class="gt_row gt_center">
217
</td>
<td class="gt_row gt_right">
11.6%
</td>
</tr>
<tr>
<td class="gt_row gt_left">
(missing)
</td>
<td class="gt_row gt_center">
196
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
399
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


<div id="dnezznfkie"
style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">

<table class="gt_table">
<thead class="gt_header">
<tr>
<th colspan="14" class="gt_heading gt_title gt_font_normal" style>
Post-vaccination event rates at 14 days amongst those with sufficient
follow-up
</th>
</tr>
<tr>
<th colspan="14" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>
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
<span class="gt_column_spanner">seconddose</span>
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
102627
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
168
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
1498
</td>
<td class="gt_row gt_right">
1.5%
</td>
<td class="gt_row gt_center">
14
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
<td class="gt_row gt_center">
77
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
72870
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
147
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
861
</td>
<td class="gt_row gt_right">
1.2%
</td>
<td class="gt_row gt_center">
14
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
42
</td>
<td class="gt_row gt_right">
0.1%
</td>
</tr>
<tr>
<td class="gt_row gt_center">
London
</td>
<td class="gt_row gt_center">
17395
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
0.1%
</td>
<td class="gt_row gt_center">
350
</td>
<td class="gt_row gt_right">
2.0%
</td>
<td class="gt_row gt_center">
7
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
21735
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
0.1%
</td>
<td class="gt_row gt_center">
161
</td>
<td class="gt_row gt_right">
0.8%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
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
58436
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
70
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
609
</td>
<td class="gt_row gt_right">
1.0%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
21
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
70
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
37191
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
70
</td>
<td class="gt_row gt_right">
0.2%
</td>
<td class="gt_row gt_center">
728
</td>
<td class="gt_row gt_right">
2.0%
</td>
<td class="gt_row gt_center">
7
</td>
<td class="gt_row gt_right">
0.0%
</td>
<td class="gt_row gt_center">
21
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
South West
</td>
<td class="gt_row gt_center">
86695
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
105
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
812
</td>
<td class="gt_row gt_right">
0.9%
</td>
<td class="gt_row gt_center">
7
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
<td class="gt_row gt_center">
77
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
20860
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
224
</td>
<td class="gt_row gt_right">
1.1%
</td>
<td class="gt_row gt_center">
7
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
73486
</td>
<td class="gt_row gt_center">
\-
</td>
<td class="gt_row gt_right">
\-
</td>
<td class="gt_row gt_center">
63
</td>
<td class="gt_row gt_right">
0.1%
</td>
<td class="gt_row gt_center">
392
</td>
<td class="gt_row gt_right">
0.5%
</td>
<td class="gt_row gt_center">
7
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
42
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
0
</td>
<td class="gt_row gt_right">
0.0%
</td>
</tr>
</tbody>
<tfoot class="gt_sourcenotes">
<tr>
<td class="gt_sourcenote" colspan="14">
Numbers are rounded to the nearest 7
</td>
</tr>
</tfoot>
</table>

</div>

<!--/html_preserve-->


<img src="../released_outputs/output/tte/figures/plot_patch_region.svg" title="outcomes by Region" style="width:80.0%" />
