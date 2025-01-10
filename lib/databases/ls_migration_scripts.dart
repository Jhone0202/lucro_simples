Map<int, String> lsMigrationScripts = {
  1: '''
      CREATE TABLE companies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  
        photoURL TEXT,                         
        name TEXT NOT NULL,                    
        userName TEXT NOT NULL          
      )
    ''',
  2: '''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        photoURL TEXT,                       
        name TEXT NOT NULL,                  
        costPrice REAL NOT NULL,             
        salePrice REAL NOT NULL              
      )
    ''',
  3: '''
        CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,   
        photoURL TEXT,                          
        name TEXT NOT NULL,  
        phoneNumber TEXT NOT NULL,                     
        type INTEGER NOT NULL                   
      )
    ''',
  4: '''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,          
        productId INTEGER NOT NULL,                    
        customerId INTEGER NOT NULL,                   
        companyId INTEGER NOT NULL,                    
        saleDate INTEGER NOT NULL,                     
        deliveryDate INTEGER NOT NULL,                 
        quantity INTEGER NOT NULL,                     
        discount REAL NOT NULL,                        
        subtotal REAL NOT NULL,                        
        total REAL NOT NULL,                           
        profit REAL NOT NULL,                          
        deliveryType TEXT NOT NULL,                    
        deliveryCost REAL NOT NULL,                    
        FOREIGN KEY (productId) REFERENCES products(id),    
        FOREIGN KEY (customerId) REFERENCES customers(id),  
        FOREIGN KEY (companyId) REFERENCES companies(id)     
      )
    ''',
  5: '''
      INSERT INTO customers (photoURL, name, phoneNumber, type) 
      VALUES (NULL, 'Consumidor Final', '+00 (00) 0 0000-0000', 1)
    ''',
  6: 'ALTER TABLE sales ADD COLUMN productName TEXT DEFAULT ""',
  7: 'ALTER TABLE sales ADD COLUMN productPhotoURL',
  8: 'ALTER TABLE sales ADD COLUMN customerName TEXT DEFAULT ""',
  9: 'ALTER TABLE sales ADD COLUMN customerPhotoURL',
  10: '''
      UPDATE sales 
      SET productPhotoURL = (SELECT photoURL FROM products WHERE products.id = sales.productId),
          productName = (SELECT name FROM products WHERE products.id = sales.productId),
          customerName = (SELECT name FROM customers WHERE customers.id = sales.customerId)
    ''',
  11: 'ALTER TABLE sales ADD COLUMN increase REAL DEFAULT 0',
  12: '''
        CREATE TABLE payment_methods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,   
        name TEXT NOT NULL,                          
        increasePercent REAL NOT NULL,  
        discountPercent REAL NOT NULL,
        maxInstallments INTEGER NOT NULL
      )
    ''',
  13: '''
      INSERT INTO payment_methods (name, increasePercent, discountPercent, maxInstallments) 
      VALUES
        ('Dinheiro', 0, 0, 1),
        ('Pix', 0, 0, 1), 
        ('Cartão de Crédito', 5, 0, 12),
        ('Cartão de Débito', 2, 0, 1)
    ''',
  14: '''
      CREATE TABLE sale_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,          
        productId INTEGER NOT NULL,                    
        saleId INTEGER NOT NULL,          
        productName TEXT NOT NULL,                     
        productPhotoURL TEXT,                               
        quantity INTEGER NOT NULL,                     
        productPrice REAL NOT NULL,                        
        total REAL NOT NULL,                           
        profit REAL NOT NULL,                                             
        FOREIGN KEY (productId) REFERENCES products(id),    
        FOREIGN KEY (saleId) REFERENCES sales(id)
      )
    ''',
  15: '''
      ALTER TABLE sales ADD COLUMN paymentMethodId INTEGER DEFAULT 1
    ''',
  16: '''
      INSERT INTO sale_items (
        saleId, productId, productName, productPhotoURL, quantity, productPrice, total, profit
      )
      SELECT 
        id AS saleId,
        productId,
        productName,
        productPhotoURL,
        quantity,
        subtotal / quantity AS productPrice,
        subtotal AS total,
        profit
      FROM sales
    ''',
  17: '''
  CREATE TABLE sales_temp AS
  SELECT 
    id,
    customerId,
    customerName,
    customerPhotoURL,
    companyId,
    saleDate,
    deliveryDate,
    discount,
    subtotal,
    total,
    profit,
    deliveryType,
    deliveryCost,
    increase,
    paymentMethodId
  FROM sales
''',
  18: 'PRAGMA foreign_keys = OFF',
  19: 'DROP TABLE sales',
  20: 'PRAGMA foreign_keys = ON',
  21: 'ALTER TABLE sales_temp RENAME TO sales',
  22: '''
      CREATE TABLE sales_temp (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER NOT NULL,
        customerName TEXT NOT NULL,
        customerPhotoURL TEXT,
        companyId INTEGER NOT NULL,
        saleDate INTEGER NOT NULL,
        deliveryDate INTEGER NOT NULL,
        discount REAL NOT NULL,
        subtotal REAL NOT NULL,
        total REAL NOT NULL,
        profit REAL NOT NULL,
        deliveryType TEXT NOT NULL,
        deliveryCost REAL NOT NULL,
        increase REAL NOT NULL,
        paymentMethodId INTEGER NOT NULL,
        FOREIGN KEY (customerId) REFERENCES customers(id),
        FOREIGN KEY (companyId) REFERENCES companies(id),
        FOREIGN KEY (paymentMethodId) REFERENCES payment_methods(id)
      )
  ''',
  23: '''
    INSERT INTO sales_temp (id, customerId, customerName, customerPhotoURL, companyId, saleDate, deliveryDate, discount, subtotal, total, profit, deliveryType, deliveryCost, increase, paymentMethodId)
    SELECT id, customerId, customerName, customerPhotoURL, companyId, saleDate, deliveryDate, discount, subtotal, total, profit, deliveryType, deliveryCost, increase, paymentMethodId
    FROM sales;
''',
  24: 'DROP TABLE sales',
  25: 'ALTER TABLE sales_temp RENAME TO sales',
};
