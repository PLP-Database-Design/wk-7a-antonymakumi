-- ### Question 1 Achieving 1NF (First Normal Form) 🛠️
-- Task:
-- - You are given the following table **ProductDetail**:

-- | OrderID | CustomerName  | Products                        |
-- |---------|---------------|---------------------------------|
-- | 101     | John Doe      | Laptop, Mouse                   |
-- | 102     | Jane Smith    | Tablet, Keyboard, Mouse         |
-- | 103     | Emily Clark   | Phone                           |


-- - In the table above, the **Products column** contains multiple values, which violates **1NF**.
-- - **Write an SQL query** to transform this table into **1NF**, ensuring that each row represents a single product for an order

-- Transforming the ProductDetail table into 1NF
SELECT 
    OrderID,
    CustomerName,
    TRIM(value) AS Product
FROM 
    ProductDetail
CROSS APPLY 
    STRING_SPLIT(Products, ',');




-- ### Question 2 Achieving 2NF (Second Normal Form) 🛠️

-- - You are given the following table **OrderDetails**, which is already in **1NF** but still contains partial dependencies:

-- | OrderID | CustomerName  | Product      | Quantity |
-- |---------|---------------|--------------|----------|
-- | 101     | John Doe      | Laptop       | 2        |
-- | 101     | John Doe      | Mouse        | 1        |
-- | 102     | Jane Smith    | Tablet       | 3        |
-- | 102     | Jane Smith    | Keyboard     | 1        |
-- | 102     | Jane Smith    | Mouse        | 2        |
-- | 103     | Emily Clark   | Phone        | 1        |

-- - In the table above, the **CustomerName** column depends on **OrderID** (a partial dependency), which violates **2NF**. 

-- - Write an SQL query to transform this table into **2NF** by removing partial dependencies. Ensure that each non-key column fully depends on the entire primary key.

-- Transforming the OrderDetails table into 2NF
-- Step 1: Create a separate table for Orders to remove partial dependency
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Step 2: Populate the Orders table with distinct OrderID and CustomerName
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create a new table for OrderProducts to store product details
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Populate the OrderProducts table with product details
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
