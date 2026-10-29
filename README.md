# 🏡 Nashville Housing Market: End-to-End SQL Data Cleaning & Analytics

## 📌 Executive Summary

Raw administrative real estate datasets are notoriously noisy: unformatted text dates, missing parcel addresses, composite delimited text fields, inconsistent categorical entries, and duplicate records. 

This project bridges the gap between raw database engineering and commercial decision-making:
1. **Data Cleaning & Schema Evolution:** Methodically transformed unstandardized records into an analytics-ready dimensional model in MySQL.
2. **Exploratory Data Analysis (EDA):** Answered critical commercial questions around market appreciation, renovation ROI, distressed asset discounts, and institutional investor exposure.

---

### Column Profiling

| Column Name | Data Type | Description |
|:---|:---|:---|
| `UniqueID` | BIGINT | Unique surrogate key for each record |
| `ParcelID` | VARCHAR | Parcel identifier across sales |
| `LandUse` | VARCHAR | Zoning/property type (Single Family, Condo, etc.) |
| `PropertyAddress` | VARCHAR | Physical street address and city |
| `SaleDate` | VARCHAR | Date property was sold |
| `SalePrice` | VARCHAR | Recorded sale price in USD |
| `LegalReference` | VARCHAR | County deed/transfer legal filing code |
| `SoldAsVacant` | VARCHAR | Vacancy status flag (`Yes`/`No`) |
| `OwnerName` | VARCHAR | Property owner/entity name |
| `OwnerAddress` | VARCHAR | Tax mailing address of the owner |
| `Acreage` | DOUBLE | Lot size in acres |
| `TaxDistrict` | VARCHAR | Municipal tax jurisdiction |
| `LandValue` | DOUBLE | Assessed tax value of the land |
| `BuildingValue` | DOUBLE | Assessed tax value of the building/structure |
| `TotalValue` | DOUBLE | Total assessed tax value (`Land + Building`) |
| `YearBuilt` | DOUBLE | Year the structure was constructed |
| `Bedrooms` | DOUBLE | Bedroom count |
| `FullBath` | DOUBLE | Full bathroom count |
| `HalfBath` | DOUBLE | Half bathroom count |

---

### Concepts Used
- `Data Cleaning`
- `Aggregation`
- `Windows Function`
- `Exploratory Data Analysis`

---

### Data Cleaning Steps

- **Date Standardization:** Converted varied text formats ('%M %e, %Y') to ISO standard DATE objects (YYYY-MM-DD).
- **Adding Parcel Address:** Resolved missing PropertyAddress fields by performing a deterministic self-join matching on identical ParcelID records (COALESCE(a.PropertyAddress, b.PropertyAddress)).
- **Delimiter String Splitting:** Extracted atomic address, city, and state attributes from composite address strings using SUBSTRING_INDEX() and TRIM().
- **Categorical Normalization:** Cleaned binary SoldAsVacant flags by mapping non-standard 'Y'/'N' values into standard 'Yes'/'No'.

---

## 💼 Business Scenarios, Key Metrics & Analytical Findings

### 1. Market Momentum & Seasonality
* **Business Question:** How has overall market pricing expanded year-over-year, and what are the optimal calendar listing windows?
* **Analytical Finding:**
  * Average prices accelerated from $244,549.69 in 2013 to $398,622.37 in 2015, yielding consecutive YoY growth of +36.64% (2014) and +19.29% (2015).
  * Summer represents peak season, with June peaking at 6,593 sales. Winter transaction volume declines (February recorded just 2,778 sales), making late winter the optimal window for discounts.

### 2. Geographic Liquidity & Land Asset Share
* **Business Question:** Which submarkets dominate liquidity, and where does raw dirt comprise the highest asset value?
* **Analytical Finding:**
  * Nashville proper commands 71.3% of county transactions (40,280 sales; average price $366,246), where land accounts for 30.56% of assessed value.
  * Suburban enclave Brentwood commands large parcel acreage (1.32 acres avg) and elevated valuations ($312,258 avg), with land value driving 35.15% of the asset basis. Madison ($136,480 avg) serves as the primary budget entry market.

### 3. Room Configurations & Renovation Value-Add
* **Business Question:** Does capital investment generate higher returns by adding an extra bedroom or an additional full bathroom?
* **Analytical Finding:**
  * For standard single-family starter homes, upgrading from 3 Bed / 1 Bath ($172,973 avg) to 3 Bed / 2 Bath ($231,595 avg) produces a +$58,622 (+33.9%) price lift.
  * Adding a 4th bedroom without a bathroom upgrade (4 Bed / 1 Bath) ($ 197,306 avg) yields only +$24,333 (+14.06%). In the Nashville metro, bathroom capacity drives more than double the marginal value of raw bedroom partitioning.

### 4. Distressed Asset Arbitrage
* **Business Question:** Do vacant single-family properties trade at a measurable discount relative to tax appraisals?
* **Analytical Finding:**
  * Occupied single-family homes sold at an average of $281,691 (1.15x assessed value).
  * Vacant single-family homes sold at an average of $197,056 against an average assessed tax value of $431,099—a 30.1% discount against occupied stock and an acquisition ratio of 0.46x assessed value (liquidating at over 50% below municipal appraisal).

### 5. Private vs Corporate Property
* **Business Question:** What proportion of housing inventory is Private property?
* **Analytical Finding:**
  * 88.08% of all property are Private propwerties and only 11.92% is owned by corporate property.

---

### Top Ten Landlords and Developers Porfolio
- `HILL 33, LLC`
- `JRG PROPERTIES, LLC`
- `FED DEVELOPMENT, LLC`
- `SUMMEY, CLARENCE`
- `KHAZANOV, MAX`
- `KUDZU REAL ESTATE, INC.`
- `URBANGATE DEVELOPMENT GROUP, LLC`
- `WOODLAND STREET PARTNERS, LLC`
- `NASH 2 SF, LLC`
- `DEEP RIVER DEVELOPMENT, LLC`
