# 📄 Project Overview – Hypothetical Sales Data Analysis

This document provides a detailed walkthrough of the Hypothetical Sales Data Analysis project. It supplements the summary in the README with expanded context, problem-solving approaches, technical decisions, and insights derived from structured analysis and visualization.

---

## 🧠 Project Background

The project is based on a hypothetical global electronics company that sells a wide variety of parts through both domestic and international channels. The data simulates real-world sales behavior and contains:

- Customer master data  
- Product master data (HPL/SOP/Status)  
- Sales invoice line items  

The original data was provided as three Excel sheets that needed to be ingested into a MySQL database, cleaned, structured, and analyzed.

---

## 🎯 Objectives

- **Database Modeling:** Design and implement a relational database schema using MySQL.  
- **Data Preparation:** Import and transform raw Excel data.  
- **Statistical Analysis:** Generate basic descriptive metrics (e.g. totals, unique counts).  
- **Insight Generation:** Use SQL queries to extract business insights.  
- **Data Visualization:** Build a Power BI dashboard using MySQL as the data source.  

---

## 🛠️ Tools & Technologies

| Tool     | Purpose                          |
|----------|----------------------------------|
| MySQL    | Database design and querying     |
| Power BI | Interactive dashboards & visuals |
| Excel    | Source data input                |

---

## 🧱 Database Design

A normalized schema was created to enable efficient analysis and avoid redundancy. It consists of the following main tables:

- `invoice_sheet`: Core sales data (site, customer, product, quantity, price, date)  
- `customer_master`: Customer metadata with country and type  
- `part_master`: Product metadata linking to SOP, HPL, and status  
- Supporting lookup tables: `cust_type`, `sop`, `hpl`, `part_status`  

Full schema available in [`database_schema.md`](./docs/database_schema.md).

---

## 📊 Key Findings

### 🏆 Top Customers

- **AVNET ASIA PTE LTD (TAIWAN BR)**: $7.91M  
- **TTI INC**: $6.62M  

> Together, the top 10 customers account for over **38% of total revenue**.

---

### 🌎 Geographic Performance

- **US** contributed $54.7M  
- Other major countries: Canada ($12.1M), Taiwan ($9.8M)  

> High dependency on a few key countries with opportunities for regional diversification.

---

### 📈 Monthly Trends

- Sales peaked in **January ($12.7M)** and **June ($10.1M)**  
- Notable decline in **December ($5.1M)**  

> Seasonality patterns detected; potential for planning inventory and marketing strategies.

---

### 📦 Profitability Insights

| Margin Tier     | Product Count | % Share |
|-----------------|----------------|---------|
| Very High > 75% | 69             | 1%      |
| High > 50%      | 144            | 3%      |
| Medium > 25%    | 2,078          | 35%     |
| Low ≤ 25%       | 3,611          | 61%     |

> Majority of products operate in tight-margin categories, which limits profitability.

---

### 🔢 HPL & SOP Analysis

- **HPL 627**: Contributed 19% of revenue and 28% of total profit  
- Most popular SOP: `SOP-5NPF` (719 transactions)

---

## 📊 Power BI Dashboard Highlights

The dashboard was developed using Power BI Desktop with live MySQL connection. It includes:

- **KPIs**: Total Revenue, YTD Profit, Quantity Purchased  
- **Visuals**: Bar charts, pie charts, line graphs, and profit distributions  
- **Filters**: Country, customer type, HPL, SOP, month, etc.  
- **Multi-page Layout**: Segmented views for sales, regions, customers, products  

> See the live visuals in [📂 Download Power BI Report](./ProjectPowerbi.pbix)

---

## 💡 Recommendations

- Focus on high-margin HPLs and optimize pricing for low-margin SKUs  
- Target top-performing customers for retention/upselling  
- Smooth seasonality dips with targeted promos during December  
- Diversify revenue away from heavily concentrated regions  

---

## 📁 Supporting Files

| File | Purpose |
|------|---------|
| [📊 Power BI Report](./ProjectPowerbi.pbix) | Interactive Power BI dashboard |
| [🧾 Amphenol_Script.sql](./sql/Amphenol_Script.sql) | Raw SQL + cleaning and setup script |
| [📘 database_schema.md](./docs/database_schema.md) | Data model and table-level structure |

---

## 🙋‍♂️ About the Author

I'm Ananth Ajith, a career switcher from UI/UX to data analytics. This project is part of my journey in mastering database-driven analysis and visual storytelling through Power BI.

---

Thank you for exploring the project in detail! 🙌
