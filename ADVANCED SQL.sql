USE subquery;
Create Table Products(
 productID INT PRIMARY KEY,
 Productname VARCHAR(50),
 Category VARCHAR(50),
 Price Decimal(10,2)
 );
 
 INSERT INTO Products VALUES 
 (1, "Keyboard", "electronics", 1200),
 (2, "Mouse", "Electronics", 800),
 (3, "Chair", "Furniture", 2500),
 (4, "Desk", "Furniture", 5500);
 
 Select * from products;
 
 Create table Saless(
 SaleID INT PRIMARY KEY,
 ProductID INT,
 Quantity INT,
 SaleDate DATE,
 FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
 );
 
 INSERT INTO Saless VALUES
 (1,1,4, "2024-01-05"),
 (2,2,10, "2024-01-06"),
 (3,3,2, "2024-01-10"),
 (4,4,1, "2024-01-11");
 
 Select * from saless;
 
 ##Q6. Write a CTE to calculate the total revenue for each product(Revenues = Price × Quantity), and return only products where  revenue > 3000.
 WITH ProductRevenue AS (
    SELECT 
        p.ProductID,
        p.Productname,
        SUM(p.Price * s.Quantity) AS Revenue
    FROM Products p
    JOIN Saless s
        ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.Productname
)
SELECT *
FROM ProductRevenue
WHERE REVENUE > 3000;

##Q7. Q7. Create a view named that shows: Category, TotalProducts, AveragePr
CREATE VIEW CategorySummary AS
SELECT 
    Category,
    COUNT(*) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

##Q8. Create an updatable view containing ProductID, ProductName, and Price. Then update the price of ProductID = 1 using the view.
CREATE VIEW ProductView AS
SELECT 
    ProductID,
    Productname,
    Price
FROM Products;

## STEP 2
UPDATE ProductView
SET Price = 1500
WHERE ProductID = 1;

## FINAL
SELECT * FROM Products WHERE ProductID = 1;

## Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category
DELIMITER // 
CREATE PROCEDURE GetProductsByCategory(IN cat_name VARCHAR(50))
BEGIN
    SELECT 
        ProductID,
        Productname,
        Category,
        Price
    FROM Products
    WHERE Category = cat_name;
END//


DELIMITER ;

CALL GetProductsByCategory('Electronics');

##Q10. Create an AFTER DELETE trigger on the table that archives deleted product rows into a new
##table . The archive should store ProductID, ProductName, Category, Price, and DeletedAt
##timestamp. Products ProductArchiv
CREATE TABLE ProductArchive (
    ProductID INT,
    Productname VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP
);
DELIMITER //
CREATE TRIGGER after_product_deleteS
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive (
        ProductID,
        Productname,
        Category,
        Price,
        DeletedAt
    )
    VALUES (
        OLD.ProductID,
        OLD.Productname,
        OLD.Category,
        OLD.Price,
        NOW()
    );
END//

DELETE FROM Products WHERE ProductID = 1;