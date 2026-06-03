create DATABASE mutual_funtd_analysis;
USE mutual_funtd_analysis;

//1. Dimension Table: dim_fund
CREATE TABLE dim_fund (

    fund_key INTEGER PRIMARY KEY AUTO_INCREMENT,

    amfi_code BIGINT UNIQUE NOT NULL,

    scheme_name VARCHAR(255) NOT NULL,
    fund_house VARCHAR(255) NOT NULL,

    category VARCHAR(100),
    sub_category VARCHAR(100),

    plan VARCHAR(50),

    risk_category VARCHAR(50),
    sebi_category_code VARCHAR(20),

    benchmark VARCHAR(255),

    fund_manager VARCHAR(255),

    launch_date DATE,

    min_sip_amount DECIMAL(10,2),
    min_lumpsum_amount DECIMAL(10,2),

    expense_ratio_pct DECIMAL(5,2),
    exit_load_pct DECIMAL(5,2),

    CHECK (expense_ratio_pct >= 0),
    CHECK (exit_load_pct >= 0),
    CHECK (min_sip_amount >= 0),
    CHECK (min_lumpsum_amount >= 0)

);

select * from dim_fund;


//2. Dimension Table: dim_date
CREATE TABLE dim_date (

    date_key INTEGER PRIMARY KEY AUTO_INCREMENT,

    full_date DATE UNIQUE NOT NULL,

    day_number INTEGER,
    month_number INTEGER,
    quarter_number INTEGER,
    year_number INTEGER,

    weekday_name VARCHAR(20),
    month_name VARCHAR(20)

);

select * from dim_date;

//3. Fact Table: fact_nav
CREATE TABLE fact_nav (

    nav_key INTEGER PRIMARY KEY AUTO_INCREMENT,

    fund_key INTEGER NOT NULL,
    date_key INTEGER NOT NULL,

    nav_value DECIMAL(10,4) NOT NULL,

    FOREIGN KEY (fund_key)
        REFERENCES dim_fund(fund_key),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key)

);

//4. Fact Table: fact_transaction
CREATE TABLE fact_transaction (

    investor_id VARCHAR(50),

    transaction_date DATE,

    amfi_code BIGINT,

    transaction_type VARCHAR(50),

    amount_inr DECIMAL(15,2),

    state VARCHAR(100),
    city VARCHAR(100),
    city_tier VARCHAR(20),

    age_group VARCHAR(20),
    gender VARCHAR(20),

    annual_income_lakh DECIMAL(10,2),

    payment_mode VARCHAR(50),

    kyc_status VARCHAR(20)

);

//5. Fact Table: fact_performance

CREATE TABLE fact_performance (

    performance_key INTEGER PRIMARY KEY AUTO_INCREMENT,

    fund_key INTEGER NOT NULL,

    date_key INTEGER,

    return_1yr_pct DECIMAL(6,2),
    return_3yr_pct DECIMAL(6,2),
    return_5yr_pct DECIMAL(6,2),

    benchmark_3yr_pct DECIMAL(6,2),

    alpha_value DECIMAL(6,2),
    beta_value DECIMAL(6,2),

    sharpe_ratio DECIMAL(6,2),
    sortino_ratio DECIMAL(6,2),

    std_dev_ann_pct DECIMAL(6,2),

    max_drawdown_pct DECIMAL(6,2),

    aum_crore DECIMAL(15,2),

    expense_ratio_pct DECIMAL(5,2),

    morningstar_rating INTEGER,

    risk_grade VARCHAR(50),

    FOREIGN KEY (fund_key)
        REFERENCES dim_fund(fund_key),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key)

);


//6. Fact Table: fact_aum
CREATE TABLE fact_aum (

    aum_key INTEGER PRIMARY KEY AUTO_INCREMENT,

    date_key INTEGER NOT NULL,

    fund_house VARCHAR(255) NOT NULL,

    aum_lakh DECIMAL(15,2),

    aum_crore DECIMAL(15,2),

    num_schemes INTEGER,

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key)

);

