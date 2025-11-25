SELECT 
    SpecialOfferID,
    Description,
    DiscountPct,
    100 * (1 - DiscountPct) AS DiscountedPrice
FROM 
    Sales.SpecialOffer;