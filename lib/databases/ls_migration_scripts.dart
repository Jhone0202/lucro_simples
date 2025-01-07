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
          customerName = (SELECT name FROM customers WHERE customers.id = sales.customerId);
    ''',
  11: 'ALTER TABLE sales ADD COLUMN increase REAL DEFAULT 0',
};
