//
//  FruitManager.swift
//  whatFruit
//
//  Created by Nico Cobelo on 14/12/2020.
//

import Foundation
import Alamofire
import SwiftyJSON


struct FruitManager {
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    
    var parameters : [String:String] = [
         "format" : "json",
         "action" : "query",
         "prop" : "extracts|pageimages",
         "exintro" : "",
         "explaintext" : "",
         "titles" : "",
         "indexpageids" : "",
         "redirects" : "1",
        "pithumbsize" : "500"
         ]
    
    mutating func fetchFruitName(_ fruitName: String, completion: @escaping(String)->()) {
        
        parameters["titles"] = fruitName
        
        AF.request(wikipediaURL, parameters: parameters).response { response in
            
            debugPrint(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value!)
            
                let pageid = json["query"]["pageids"][0].stringValue
            
                if let wikipediaExtract = json["query"]["pages"][pageid]["extract"].string {
                        completion(wikipediaExtract)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    mutating func fetchFruitImage(_ fruitName: String, completion: @escaping (String)->()) {
        
        parameters["titles"] = fruitName
        
        AF.request(wikipediaURL, parameters: parameters).response { response in
            
            debugPrint(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value!)
            
                let pageid = json["query"]["pageids"][0].stringValue
                
                if let flowerImage = json["query"]["pages"][pageid]["thumbnail"]["source"].string {
                    completion(flowerImage)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
