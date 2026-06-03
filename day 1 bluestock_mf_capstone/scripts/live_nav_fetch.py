# =====================================================
# LIVE NAV FETCH SCRIPT
# Mutual Fund Analytics Project
# =====================================================

# =====================================================
# IMPORT LIBRARIES
# =====================================================

import pandas as pd
import requests
import os

# =====================================================
# CREATE RAW DATA FOLDER
# =====================================================

os.makedirs("data/raw", exist_ok=True)

# =====================================================
# SCHEME CODES
# =====================================================

schemes = {
    "HDFC_Top100": 125497,
    "SBI_Bluechip": 119551,
    "ICICI_Bluechip": 120503,
    "Nippon_LargeCap": 118632,
    "Axis_Bluechip": 119092,
    "Kotak_Bluechip": 120841
}

# =====================================================
# EMPTY LIST FOR COMBINED NAV DATA
# =====================================================

all_nav_data = []

# =====================================================
# FETCH LIVE NAV DATA
# =====================================================

print("\n========== FETCHING LIVE NAV DATA ==========\n")

for fund_name, code in schemes.items():

    try:

        print(f"Fetching data for: {fund_name}")

        # API URL
        url = f"https://api.mfapi.in/mf/{code}"

        # API Request
        response = requests.get(url)

        # CHECK STATUS
        if response.status_code != 200:

            print(f"Failed to fetch data for {fund_name}")

            continue

        # CONVERT JSON
        data = response.json()

        # =================================================
        # META DATA
        # =================================================

        meta = data.get("meta", {})

        print("\nFund Details:")

        print("Fund House      :", meta.get("fund_house"))

        print("Scheme Name     :", meta.get("scheme_name"))

        print("Scheme Type     :", meta.get("scheme_type"))

        print("Scheme Category :", meta.get("scheme_category"))

        # =================================================
        # NAV HISTORY DATA
        # =================================================

        nav_df = pd.DataFrame(data['data'])

        # ADD EXTRA COLUMNS
        nav_df['scheme_code'] = code

        nav_df['fund_name'] = fund_name

        # =================================================
        # SAVE INDIVIDUAL CSV
        # =================================================

        file_name = f"data/raw/{fund_name}.csv"

        nav_df.to_csv(file_name, index=False)

        print(f"\n{fund_name}.csv saved successfully")

        # =================================================
        # STORE FOR COMBINED DATASET
        # =================================================

        all_nav_data.append(nav_df)

        print("-" * 60)

    except Exception as e:

        print(f"Error occurred for {fund_name}")

        print(e)

# =====================================================
# CREATE COMBINED NAV HISTORY FILE
# =====================================================

if len(all_nav_data) > 0:

    nav_history = pd.concat(all_nav_data, ignore_index=True)

    nav_history.to_csv("data/raw/nav_history.csv", index=False)

    print("\nnav_history.csv created successfully")

    print("\n========== DATA SUMMARY ==========\n")

    print(f"Total NAV Records : {nav_history.shape[0]}")

    print(f"Total Funds       : {len(schemes)}")

else:

    print("No NAV data fetched")

# =====================================================
# SCRIPT COMPLETED
# =====================================================

print("\nDay 1 Live NAV Fetch Completed Successfully")