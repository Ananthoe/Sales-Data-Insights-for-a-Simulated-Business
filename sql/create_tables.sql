
-- Create and use the database
drop database if exists amphenol;
create database amphenol;
use amphenol;

-- CUSTOMER TYPE
create table cust_type (
  Cust_Type INT PRIMARY KEY,
  Cust_Desc TEXT
);

-- CUSTOMER MASTER
create table customer_master (
  Custmast_CustNbr INT PRIMARY KEY,
  Custmast_Name TEXT,
  Custmast_GenAcc TEXT,
  Custmast_CtryCode TEXT,
  Custmast_type INT,
  FOREIGN KEY (Custmast_type) REFERENCES cust_type(Cust_Type)
);

-- HPL
create table hpl (
  HPL_code VARCHAR(255),
  HPL_desc TEXT,
  PRIMARY KEY (HPL_code)
);

-- PART STATUS
create table part_status (
  Partstatus_Status VARCHAR(255) PRIMARY KEY,
  Partstatus_desc VARCHAR(255)
);

-- SOP
create table sop (
  SOP_Nbr VARCHAR(255) PRIMARY KEY,
  SOP_desc TEXT
);

-- PART MASTER
create table part_master (
  Partmast_ItemNbr VARCHAR(255) PRIMARY KEY,
  Partmast_HPLcode VARCHAR(255) NOT NULL,
  Partmast_Status VARCHAR(255) NOT NULL,
  Partmast_SOP VARCHAR(255) NOT NULL,
  Partmast_UM TEXT,
  Partmast_Stdcost DOUBLE,
  FOREIGN KEY (Partmast_HPLcode) REFERENCES hpl(HPL_code),
  FOREIGN KEY (Partmast_Status) REFERENCES part_status(Partstatus_Status),
  FOREIGN KEY (Partmast_SOP) REFERENCES sop(SOP_Nbr)
);

-- INVOICE SHEET
create table invoice_sheet (
  Inv_Site INT,
  Inv_CustNbr INT,
  Inv_Nbr VARCHAR(255),
  Inv_Line INT,
  Inv_ItemNbr VARCHAR(255),
  Inv_UM TEXT,
  Inv_Qty BIGINT,
  Inv_Price DOUBLE,
  Inv_Date DATE,
  PRIMARY KEY (Inv_Site, Inv_Nbr, Inv_Line),
  FOREIGN KEY (Inv_CustNbr) REFERENCES customer_master(Custmast_CustNbr),
  FOREIGN KEY (Inv_ItemNbr) REFERENCES part_master(Partmast_ItemNbr)
);

Some column names in the Excel source required renaming due to encoding artifacts (like ï»¿).

You can find the full original script including data cleaning steps, constraint additions, and derived analysis in Amphenol_Script.sql.
