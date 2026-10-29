#  🏡 Nashville Housing Market: End-to-End SQL Data Cleaning & Analytics
## 📌 Executive Summary

Raw administrative real estate datasets are notoriously noisy: unformatted text dates, missing parcel addresses, composite delimited text fields, inconsistent categorical entries, and duplicate records. 

This project bridges the gap between raw database engineering and commercial decision-making:
1. **Data Cleaning & Schema Evolution:** Methodically transformed unstandardized records into an analytics-ready dimensional model in MySQL.
2. **Exploratory Data Analysis (EDA):** Answered critical commercial questions around market appreciation, renovation ROI, distressed asset discounts, and institutional investor exposure.

Column Profiling:
UniqueID
ParcelID
LandUse
PropertyAddress
SaleDate
SalePrice
LegalReference
SoldAsVacant
OwnerName
OwnerAddress
Acreage
TaxDistrict
LandValue
BuildingValue
TotalValue
YearBuilt
Bedrooms
FullBath
HalfBath

**Data Cleaning & Pipeline Steps**
Date Standardization: Converted varied text formats ('%M %e, %Y') to ISO standard DATE objects (YYYY-MM-DD).

Parcel Address Imputation: Resolved missing PropertyAddress fields by performing a deterministic self-join matching on identical ParcelID records (COALESCE(a.PropertyAddress, b.PropertyAddress)).

Delimiter String Splitting: Extracted atomic address, city, and state attributes from composite address strings using SUBSTRING_INDEX() and TRIM().

Categorical Normalization: Cleaned binary SoldAsVacant flags by mapping non-standard 'Y'/'N' values into standard 'Yes'/'No'.


**Business Scenarios, Key Metrics & Analytical Findings**
1. Market Momentum & Seasonality
Business Question: How has overall market pricing expanded year-over-year, and what are the optimal calendar listing windows?

Analytical Finding:

Average prices accelerated from $244,577 in 2013 to $398,653 in 2015, yielding consecutive YoY growth of +36.65% (2014) and +19.28% (2015).

Summer represents 31.3% of annual liquidity, with June peaking at 6,593 sales ($222,505 median). Winter transaction volume declines by >44% (February recorded just 2,778 sales), making late winter the optimal acquisition window for discounts.

2. Geographic Liquidity & Land Asset Share
Business Question: Which submarkets dominate liquidity, and where does raw dirt comprise the highest asset value?

Analytical Finding:

Nashville proper commands 71.3% of county transactions (40,270 sales; average price $366,349), where land accounts for 30.56% of assessed value.

Suburban enclave Brentwood commands large parcel acreage (1.32 acres avg) and elevated valuations ($312,258 avg), with land value driving 35.15% of the asset basis. Madison ($136,502 avg) serves as the primary budget entry market.

3. Room Configurations & Renovation Value-Add
Business Question: Does capital investment generate higher returns by adding an extra bedroom or an additional full bathroom?

Analytical Finding:

For standard single-family starter homes, upgrading from 3 Bed / 1 Bath ($172,973 avg) to 3 Bed / 2 Bath ($231,663 avg) produces a +$58,689 (+33.9%) price lift.

Adding a 4th bedroom without a bathroom upgrade (4 Bed / 1 Bath) yields only +$18,500 (+12.5%). In the Nashville metro, bathroom capacity drives more than double the marginal value of raw bedroom partitioning.

4. Distressed Asset Arbitrage 
Business Question: Do vacant single-family properties trade at a measurable discount relative to tax appraisals?

Analytical Finding:

Occupied single-family homes sold at an average of $281,716 (1.15x assessed value).

Vacant single-family homes sold at an average of $197,056 against an average assessed tax value of $431,099—a 30.1% discount against occupied stock and an acquisition ratio of 0.46x assessed value (liquidating at over 50% below municipal appraisal).

5. Institutional Penetration & Absentee Ownership
Business Question: What proportion of housing inventory is held by non-owner occupants and corporate institutions?

Analytical Finding:

19.52% of all single-family parcels are owned by absentee investors whose billing tax address differs from the physical property.

Absentee investors purchased properties at an average price of $310,846 vs. $273,506 for owner-occupiers (+13.65% price premium), confirming that investor capital actively targeted upper-tier, turn-key rental stock.
