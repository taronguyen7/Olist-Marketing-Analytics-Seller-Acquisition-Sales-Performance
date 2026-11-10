
# Olist Marketing Analytics: Seller Acquisition & Sales Performance

## Project Overview

In this project, I wanted to answer three main questions:

1. Which marketing channels convert the most qualified leads into sellers?
2. Which channels generate the most sales value?
3. Which marketing channels should Olist prioritize based on the findings?

I analyzed Olist's marketing and marketplace data to understand how different acquisition channels performed in attracting qualified leads, converting them into sellers, and generating delivered sales value.

I used MySQL to clean and connect five datasets, calculate marketing KPIs, and compare channel performance. I then built a four-page Power BI dashboard to visualize the results and develop recommendations based on the findings.

## Tools Used

- **MySQL** – Data cleaning, transformation, joining datasets, and KPI analysis.
- **Power BI** – Data modeling, DAX calculations, interactive dashboards, and data visualization.

## Dashboard Overview

The Power BI report contains four pages covering marketing performance, acquisition and conversion, seller sales value, and strategic recommendations.

### 1. Executive Overview

![Executive Overview](Olist%20I%20Marketing%20Performance%20Overview.png)

Provides an overview of qualified leads, closed deals, conversion rates, and attributed delivered sales value.

### 2. Acquisition & Conversion

![Acquisition and Conversion](Olist%20Acquisition%20%26%20Conversion%20Analysis.png)

Compares marketing channels using lead volume, conversion rates, closed deals, and monthly conversion trends.

### 3. Seller Value & Strategy

![Seller Value and Strategy](Olist%20Seller%20Value%20and%20Strategy.png)

Analyzes delivered sales value by marketing channel, average sales value per active seller, and seller activity.

### 4. Strategic Recommendations

![Strategic Recommendations](Olist%20Strategic%20Marketing%20Recommendations.png)

Presents four business recommendations supported by the SQL analysis and Power BI findings.

## Key Insights

- **Organic search generated the most closed deals among identifiable channels:** It produced 2,296 qualified leads, 271 closed deals, and an 11.80% conversion rate.

- **Paid search achieved a slightly higher conversion rate:** Paid search converted 12.30% of its 1,586 qualified leads, generating 195 closed deals.

- **Organic search led identifiable channels in delivered sales value:** Sellers acquired through organic search generated 204,509.79 in attributed delivered sales value, followed by paid search at 151,444.15.

- **Social media attracted leads but converted fewer of them:** Social generated 1,350 qualified leads but converted only 5.56%, below the overall conversion rate of 10.53%.

- **Marketing attribution was incomplete:** Of 8,000 qualified leads, 1,159 (14.49%) had unknown or blank acquisition sources, making channel-level performance comparisons less reliable.

## Strategic Recommendations

Based on the analysis, I developed four recommendations:

1. **Prioritize organic search:** Test expanding SEO and relevant content efforts while monitoring lead conversion and seller sales performance.

2. **Maintain and optimize paid search:** Continue paid search campaigns while testing improvements to audience targeting and evaluating acquisition costs before increasing spending.

3. **Investigate social media conversion performance:** Examine lead quality, targeting, and sales follow-up processes to understand why social media has a lower conversion rate.

4. **Improve marketing attribution:** Investigate missing acquisition-source information and improve tracking to support more reliable marketing decisions.

## Limitations

- **Marketing costs:** Acquisition costs were unavailable, so I could not calculate channel profitability or return on investment.
- **Seller matching:** Only 380 of 842 closed-deal sellers had matching order activity, limiting the sales value analysis.
- **Missing attribution:** 1,159 qualified leads had unknown or blank acquisition sources.
- **Sales measurement:** Delivered sales value represents merchandise value from matched sellers, not Olist's revenue or profit.

## SQL Analysis

I used MySQL to clean and prepare the datasets, standardize date fields, and connect marketing qualified leads with closed deals, sellers, order items, and orders.

I calculated total qualified leads, closed deals, conversion rates by marketing channel, delivered sales value, and average delivered sales value per active seller.

I also investigated missing acquisition-source information and compared the SQL results with the Power BI dashboard to support the final business recommendations.

The SQL script used for this project is available here:

[View SQL Analysis](olist_data_cleaning.sql)

## Power BI Report

The completed interactive Power BI report is available here:

[Download Power BI Dashboard](Olist%20Marketing%20Analytics.pbix)
