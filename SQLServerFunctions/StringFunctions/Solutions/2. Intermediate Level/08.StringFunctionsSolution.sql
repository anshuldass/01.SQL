SELECT 
	CONCAT('**********',RIGHT(CardNumber,4)) AS MaskedCreditCard
FROM Sales.CreditCard;