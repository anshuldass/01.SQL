WITH BOM AS (
		SELECT 
			ProductAssemblyID, 
			ComponentID, 
			PerAssemblyQty, 
			1 AS Level
		FROM Production.BillOfMaterials
		WHERE ProductAssemblyID = 800 -- Example product
		UNION ALL
		SELECT 
			b.ProductAssemblyID, 
			b.ComponentID, 
			b.PerAssemblyQty, 
			Level + 1
		FROM Production.BillOfMaterials b
		JOIN BOM c
		ON b.ProductAssemblyID = c.ComponentID
)
SELECT * FROM BOM ORDER BY Level;