import pandas as pd

df=pd.read_csv(r"C:\Users\DELL\Downloads\IBM_HR_Attrition_augmented.csv")
df = pd.read_csv("IBM_HR_Attrition_augmented.csv")

# 1.Dataset Exploaration

# print(df)
# print(df.shape)
# print(df.dtypes)
# print(df.columns)
# print(df.info())
# print(df.isnull().sum())
# print(df["EmployeeID"].duplicated().sum())
# print(df.isnull().sum())
# print(df["EmployeeID"].duplicated().sum())
# duplicates=df[df["EmployeeID"].duplicated(keep=False)]
# print(duplicates)
# print(df["EmployeeID"].nunique())
# print(len(df))

# 2. Data Cleaning in Python

df = df.drop_duplicates(subset="EmployeeID",keep="first")
# print("Duplicate EmployeeIDs:", df["EmployeeID"].duplicated().sum())
# print("Duplicate EmployeeID's before cleaning:",
#       df["EmployeeID"].duplicated().sum())
# print(df.drop_duplicates(subset="EmployeeID",keep="first"))
# print(df.dtypes)

df["MonthlyIncome"]=pd.to_numeric(df["MonthlyIncome"],errors="coerce")
# print(df["MonthlyIncome"].isna().sum())

# Numerical columns - fill missing values with median
df["Age"]=df["Age"].fillna(df["Age"].median())
# print(df.isnull().sum())
# pd.set_option("display.max_rows", None)
# print(df["Age"])

df["MonthlyIncome"]=df["MonthlyIncome"].fillna(df["MonthlyIncome"].median())
# print(df.isnull().sum())
# pd.set_option("display.max_rows",None)
# print(df["MonthlyIncome"])

df["YearsAtCompany"]=df["YearsAtCompany"].fillna(df["YearsAtCompany"].median())
# pd.set_option("display.max_rows",None)
# print(df["YearsAtCompany"])
# print(df.isnull().sum())


df["JobSatisfaction"]=df["JobSatisfaction"].fillna(df["JobSatisfaction"].median())
# pd.set_option("display.max_rows",None)
# print(df['JobSatisfaction'])
# print(df.isnull().sum())


# Categorical columns - fill missing values with mode

df["Gender"]=df["Gender"].fillna(df["Gender"].mode()[0])
# pd.set_option("display.max_rows",None)
# print(df["Gender"])
# print(df.isnull().sum())

df["Department"] = df["Department"].fillna(df["Department"].mode()[0])
# pd.set_option("display.max_rows",None)
# print(df["Department"])
# print(df.isnull().sum())

df["JobRole"] = df["JobRole"].fillna(df["JobRole"].mode()[0])
# pd.set_option("display.max_rows",None)
# print(df["JobRole"])
# print(df.isnull().sum())

df["OverTime"] = df["OverTime"].fillna(df["OverTime"].mode()[0])
# pd.set_option("display.max_rows",None)
# print(df["OverTime"])
# print(df.isnull().sum())

# pd.set_option("display.max_rows",None)
# print(df)


# Checking for negative values in numerical columns

# print(df[df["MonthlyIncome"]<0])

# print(df[df["Age"]<0])

# print(df[df['YearsAtCompany']<0])

# print(df[(df["JobSatisfaction"] < 1) |(df["JobSatisfaction"] > 4)])

#3 Feature Engineering

df["AttriationFlag"]=(df["Attrition"]=="Yes").astype(int) #Creating a new column "AttriationFlag"
# pd.set_option("display.max_rows",None)
# print(df)

# Creating a new column "TenureGroup"
def TenureGroup(years):
    if years <3:
        return "0-2 years"
    elif years <6:
        return "2-5 years"
    else:
        return "5+ years"

df["TenureGroup"]=df["YearsAtCompany"].apply(TenureGroup)
# print(df[["YearsAtCompany","TenureGroup"]].head(20))

# Created a new column "IncomeGroup"
df["IncomeGroup"]=pd.qcut(df["MonthlyIncome"],q=3,labels=["Low","Medium","High"])
# print(df[["MonthlyIncome","IncomeGroup"]].head(20))

# Created a new column "EstimatedAttritionCost"
df["EstimatedAttritionCost"] = (df["MonthlyIncome"].where(df["Attrition"] == "Yes", 0) * 3)
# print(df[["MonthlyIncome", "Attrition", "EstimatedAttritionCost"]].head(20))
# print("Total Estimated Attrition Cost:",df["EstimatedAttritionCost"].sum())


# Final Checking for any missing values,duplicate EmployeeIDs
# print("Final Shape:", df.shape)

# print("\nMissing Values:")
# print(df.isnull().sum())

# print("\nDuplicate EmployeeIDs:")
# print(df["EmployeeID"].duplicated().sum())

# print("\nColumns:")
# print(df.columns)

# Exporting the cleaned dataset to a new csv file called "hr_clean.csv"
df.to_csv("hr_clean.csv",index=False)
# print("\n hr_clean.csv exported sucessfully")

# To Know the path of the exported file("hr_clean.csv")
# import os
# print(os.path.abspath("hr_clean.csv"))






