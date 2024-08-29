# Classification of Material Properties for Composites with Cluster Analysis

## Description
This repository implements a k-means clustering algorithm in MATLAB to classify composites with multiple material properties. 

## Dataset
`Material database (Materialbank.xlsx)`: The database consists of 118 materials with 11 features and can be expanded as desired. 

## Necessary metrics
### Metrics for clustering
- m: Desired feature vector to consider for clustering (e.g. m=[1 2])
- metrik: Distance metrik for k-means (e.g. metrik='sqeuclidean')
- a: Minimal value for k-value used by 'evalclusters' (e.g. a=2)
- b: Maximal value for k-value used by 'evalclusters' (e.g. b=10)
- n: Number of repetitions of Gaussian mixture models (GMM) (e.g. n=5)

### Boolean operators for desired diagrams
- b1: Activate for scatter plot (e.g. b1=1)
- b2: Activate for silhouette plot (e.g. b2=1)
- b3: Activate for GMM (e.g. b3=1)
- b4: Activate for normalized parallel coordinates (e.g. b4=1)
- b5: Activate for Pareto chart (e.g. b5=1)
