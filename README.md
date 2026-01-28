# Impact-of-the-Universal-Two-Child-Policy-on-Maternal-Health-in-China
Project Overview
This project evaluates the causal impact of China’s Universal Two-Child Policy (2016) on women's health outcomes. Using a large-scale longitudinal dataset from the China Family Panel Studies (CFPS), 
I employ a Difference-in-Differences (DID) framework to identify how the policy shift affected demographic trends and maternal health indicators.

Research Methodology
To address potential endogeneity and provide a rigorous causal estimate, the analysis includes:

Difference-in-Differences(DID): The difference in fertility and maternal health between one-child women and multi-child women before and after the implementation of policy.

Balance & Placebo Tests: Conducting rigorous robustness checks to validate the Parallel Trend Assumption.

Data Cleaning & Integration: Processing multi-year waves of CFPS data (2012–2020), managing missing values, and recoding complex health indicators.

Key Technical Implementation (Stata)
The provided .do file covers the entire analytical pipeline:

Data Preprocessing: Merging multiple CFPS modules and cleaning demographic variables (age, education, urban/rural status).

Econometric Modeling: Running fixed-effects regressions (xtreg) with clustered standard errors at the individual level.

Heterogeneity Analysis: Exploring how policy impacts vary across different socioeconomic groups.

Visualization: Generating coefficient plots and summary tables for academic-level reporting.

Dataset
Source: China Family Panel Studies (CFPS), a nationally representative, biennial longitudinal survey.

Scope: Covers multiple waves, focusing on women of childbearing age before and after the 2016 policy implementation.

