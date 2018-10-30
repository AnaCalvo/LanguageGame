//
//  Networking.swift
//  LanguageGame
//
//  Created by Ana Calvo on 30/10/18.
//  Copyright © 2018 Ana Calvo. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noInternet
    case parsingError
    case urlError
    case custom(Error)
}

class Networking {
    
    func fetchData(completion: @escaping ([Word]?, ServiceError?) -> Void)  {
        guard let url = URL(string: "https://gist.githubusercontent.com/DroidCoder/7ac6cdb4bf5e032f4c737aaafe659b33/raw/baa9fe0d586082d85db71f346e2b039c580c5804/words.json") else {
            completion(nil, ServiceError.urlError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                   completion(nil, ServiceError.custom(error!))
                    return }
            do {
                let decoder = JSONDecoder()
                let arrayOfWords = try decoder.decode([Word].self, from: dataResponse)
                completion(arrayOfWords, nil)
                
            } catch {
                completion(nil, ServiceError.parsingError)
            }
        }
        task.resume()
    }
}
