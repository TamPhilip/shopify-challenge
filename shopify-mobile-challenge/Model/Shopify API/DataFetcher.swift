//
//  DataFetcher.swift
//  shopify-mobile-challenge
//
//  Created by Philip Tam on 2019-09-17.
//  Copyright © 2019 Philip Tam. All rights reserved.
//

import Foundation

class DataFetcher {
    
    // Key: Collection ID, Value: Product
    public var productList: ProductList = ProductList(products: [])
    
    // Singleton
    // a singleton is best because if the app is expanded into more than 2 views then it will be easier to access the products, collections, and collects.
    public static let shared: DataFetcher = DataFetcher()
    
    /*
     
     function: fetchProduct
     completionHandler: @escaping (Bool, Error) -> () -> For later
     Makes a single get request to get all of the productsID that is found in the URL. The reponse will send back a JSON and it will then be decoded in a productList. which will have a productArray inside.
     */
    
    public func fetchProduct(_ completionHandler: @escaping (Bool, Error?) -> () ) {
        guard let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") else {return}
        
        let session = URLSession.shared
        
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            // Check error is nil
            guard error == nil else {return
                completionHandler(false, error)
            }
            
            // Check data is not nil
            guard let data = data else {return
                completionHandler(false, nil)
            }
            
            self.decodeProduct(data: data, { (success, error) in
                completionHandler(success , error)
            })
        }).resume()
    }
    
    
    /*
     
     function: decodeProduct
     data: Data
     completionHandler: @escaping (Bool, Error) -> ()
     Decodes the JSON data
     */
    
    private func decodeProduct(data: Data, _ completionHandler: (Bool, Error?) -> () ) {
        do {
            let productList = try JSONDecoder().decode(ProductList.self, from: data)
            
            self.productList = productList
            
            // Remove the repeating product
            self.productList.products.removeAll { (product) -> Bool in
                return product.id == 2759168323
            }
            
            print(self.productList.products.count)
            completionHandler(true, nil)
        } catch {
            print("Error while decoding data \(error)")
            completionHandler(false, error)
        }
    }
}
