

# 📘 Database Schema

This document outlines the database schema created for the Hypothetical Sales Data Analysis project. The schema was implemented in **MySQL** using multiple normalized tables to support referential integrity and analytical queries.

---

## 🛠️ Tables Overview

### 1. Invoice Sheet

| Column Name  | Data Type    | Constraints                                       | Description                            |
| ------------ | ------------ | ------------------------------------------------- | -------------------------------------- |
| Inv_Site     | INT          | PRIMARY KEY, NOT NULL                             | Unique identifier for each transaction |
| Inv_CustNbr  | INT          | FOREIGN KEY → Customer_Master(custmast_CustNbr)   | Links to Customer_Master               |
| Inv_Nbr      | VARCHAR(255) | PRIMARY KEY, NOT NULL                             | Invoice number                         |
| Inv_Line     | INT          | PRIMARY KEY, NOT NULL                             | Line number of the invoice             |
| Inv_ItemNbr  | VARCHAR(255) | FOREIGN KEY → Part_Master(Partmast_ItemNbr)       | Links to Part_Master                   |
| Inv_UM       | TEXT         | NULLABLE                                          | Unit of measurement                    |
| Inc_Qty      | BIGINT       | NULLABLE                                          | Quantity invoiced                      |
| Inv_Price    | DOUBLE       | NULLABLE                                          | Price per unit                         |
| Inv_Date     | DATE         | NULLABLE                                          | Invoice date                           |

---

### 2. Customer_Master

| Column Name        | Data Type | Constraints                          | Description                         |
| ------------------ | --------- | ------------------------------------ | ----------------------------------- |
| Custmast_CustNbr   | INT       | PRIMARY KEY, NOT NULL                | Unique identifier for each customer |
| Custmast_Name      | TEXT      | NULLABLE                             | Customer name                       |
| Custmast_GenAcc    | TEXT      | NULLABLE                             | Generic account                     |
| Custmast_CtryCode  | TEXT      | NULLABLE                             | Country code                        |
| Custmast_type      | INT       | FOREIGN KEY → Cust_Type(Cust_Type)   | Links to Cust_Type table            |

---

### 3. Part_Master

| Column Name        | Data Type    | Constraints                                     | Description                  |
| ------------------ | ------------ | ----------------------------------------------- | ---------------------------- |
| Partmast_Itemnbr   | VARCHAR(255) | PRIMARY KEY, NOT NULL                           | Unique part number           |
| Partmast_HPLcode   | INT          | FOREIGN KEY → HPL(HPLNbr), NOT NULL             | Links to HPL table           |
| Partmast_Status    | TEXT         | FOREIGN KEY → Part_Status(Partstatus_Status)    | Links to Part_Status table   |
| Partmast_SOP       | VARCHAR(255) | FOREIGN KEY → SOP(SOP_nbr), NOT NULL            | Links to SOP table           |
| Partmast_UM        | TEXT         | NULLABLE                                        | Unit of measurement          |
| Partmast_Stdcost   | DOUBLE       | NULLABLE                                        | Standard cost                |

---

### 4. Part_Status

| Column Name        | Data Type    | Constraints           | Description        |
| ------------------ | ------------ | --------------------- | ------------------ |
| Partstatus_Status  | VARCHAR(255) | PRIMARY KEY, NOT NULL | Status code        |
| Partstatus_desc    | VARCHAR(255) | NULLABLE              | Status description |

---

### 5. SOP

| Column Name | Data Type    | Constraints           | Description     |
| ----------- | ------------ | --------------------- | --------------- |
| SOP_nbr     | VARCHAR(255) | PRIMARY KEY, NOT NULL | SOP number      |
| SOP_desc    | TEXT         | NULLABLE              | SOP description |

---

### 6. HPL

| Column Name | Data Type    | Constraints           | Description     |
| ----------- | ------------ | --------------------- | --------------- |
| HPL_nbr     | VARCHAR(255) | PRIMARY KEY, NOT NULL | HPL number      |
| HPL_desc    | TEXT         | NULLABLE              | HPL description |

---

### 7. Cust_Type

| Column Name | Data Type | Constraints           | Description        |
| ----------- | --------- | --------------------- | ------------------ |
| Cust_Type   | INT       | PRIMARY KEY, NOT NULL | Customer type code |
| Cust_Desc   | TEXT      | NULLABLE              | Type description   |

---

## 🧱 Entity Relationships

- **Invoice Sheet** connects Customers and Products.
- **Part_Master** relates each item to **HPL**, **SOP**, and **Status**.
- **Customer_Master** ties customers to types and regions.

This design allows clean, normalized analysis for sales, cost, geography, and customer behavior.

📌 See [SQL](../sql/create_tables.sql) for actual SQL schema creation.
