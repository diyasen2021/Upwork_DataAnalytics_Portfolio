# Clinical Trial Data Analysis: Statistical Testing and PCA
Overview:
This project involves analyzing clinical trial data, which contains multiple features (such as measurements of subjects at different timepoints). The goal was to perform statistical testing and dimensionality reduction to explore the relationships between timepoints and features, and to visualize patterns.

## Key Steps:

**Data Cleaning:**
The dataset is in a long format, meaning that each row represents a measurement at a specific timepoint for a subject.
The data is processed and prepared for analysis.

**Mann-Whitney U Test:**
This test compares the values of each feature (e.g., "Heart Rate") between different timepoints to see if there are significant differences.
For each feature, it compares values from two different timepoints (e.g., day 1 vs. day 5), calculates a statistic and a p-value to determine if the difference is statistically significant.

**Volcano Plot:**
A visualization tool (volcano plot) was created to display the results of the Mann-Whitney U test.
The plot highlights significant differences by showing statistical values on one axis and the significance (p-value) on the other.
This helps quickly spot features with significant changes between timepoints.

**PCA (Principal Component Analysis):**
PCA is a technique used to reduce the complexity of data while preserving as much information as possible.
The data was "pivoted" so that each subject's measurements at different timepoints were grouped together. PCA was then performed to reduce this data to two dimensions (PC1 and PC2) and visualize it on a scatter plot, helping identify patterns or groupings in the data based on timepoints.