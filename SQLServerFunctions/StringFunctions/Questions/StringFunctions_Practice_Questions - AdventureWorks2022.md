# AdventureWorks (2022) — String Functions Practice Problems

This set covers beginner → advanced string‑function challenges using the **AdventureWorks2022** database. No solutions are included unless you request them.

---

## 🟢 Beginner Level

### **1. Extract First Name Initial**

Return the **first letter** of each person's first name from `Person.Person`.

### **2. Uppercase Territory Names**

Convert all territory names from `Sales.SalesTerritory` to **UPPERCASE**.

### **3. Clean Extra Spaces**

Trim leading/trailing spaces from `AddressLine1` in `Person.Address`.

### **4. Find Names Containing "son"**

Retrieve all people whose last name contains the substring `son` (case‑insensitive).

### **5. Email Domain Extraction**

From `Person.EmailAddress`, extract the email domain (everything after `@`).

---

## 🟡 Intermediate Level

### **6. Proper Case Names**

Convert first and last names to "Proper Case" (first letter uppercase, rest lowercase).

### **7. Build Full Address Line**

Concatenate `AddressLine1`, `City`, and `PostalCode` into a single readable address.

### **8. Mask Credit Card Numbers**

In `Sales.CreditCard`, display only the last 4 digits of the card number, masking the rest.

### **9. Extract Product Color Code**

From `Production.Product`, extract the **Color** field's first three characters (e.g., "Red" → "Red", "Silver" → "Sil"). Return products where the Color field is not NULL.

### **10. Validate Phone Numbers**

Return phone numbers from `Person.PersonPhone` that contain exactly **10 digits** after removing special characters.

---

## 🔵 Advanced Level

### **11. Parse Product Numbers**

Split the `ProductNumber` (e.g., `BK-M68B-42`) into its components using string functions.

### **12. Standardize Territory Codes**

Format all territory codes as:
`TERR-<uppercase-first-three-letters>`
from `Sales.SalesTerritory.Name`.

### **13. Classify Cities by First Letter**

Group cities from `Person.Address` by their **starting letter** and return counts for each.

### **Question 14 — Detect Numeric Suffixes in Product Numbers**

**Identify products whose `ProductNumber` ends with a numeric suffix (for example: `…-42`, `…-300`, `…-700`). Extract the numeric ending and return it as a separate column.**

### **15. Generate URL Slugs for Product Names**

Turn product names into web-friendly slugs:

- lowercase
- spaces replaced with hyphens

### **16. Extract Model Series**

From `ProductNumber`, extract the **middle section** (e.g., `M68B` from `BK-M68B-42`).

### **17. Fuzzy Product Search Using SOUNDEX**

Find products whose names sound similar to a given input term (e.g., "helmet").

### **18. Detect Product Colors Embedded in Name**

Identify colors (e.g., red, black, silver) mentioned inside product names.

### **19. Reverse Customer Names**

Reverse each customer's full name using string functions only.

### **20. Generate Hashed Customer Identifier**

Create a SHA hash (using `HASHBYTES`) from concatenation of first name, last name, and business entity ID.

---
