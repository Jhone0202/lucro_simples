Map<int, String> lsMigrationScripts = {
  1: '''
      CREATE TABLE companies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  
        photoURL TEXT,                         
        name TEXT NOT NULL,                    
        userName TEXT NOT NULL          
      );
    ''',
  2: '''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        photoURL TEXT,                       
        name TEXT NOT NULL,                  
        costPrice REAL NOT NULL,             
        salePrice REAL NOT NULL              
      );
    ''',
  3: '''
        CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,   
        photoURL TEXT,                          
        name TEXT NOT NULL,  
        phoneNumber TEXT NOT NULL,                     
        type INTEGER NOT NULL                   
      );
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
      );
    ''',
  5: '''
      INSERT INTO customers (photoURL, name, phoneNumber, type) 
      VALUES (NULL, 'Consumidor Final', '+00 (00) 0 0000-0000', 1);
    '''
};
