//
//  GameViewController.swift
//  LanguageGame
//
//  Created by Ana Calvo on 17/10/18.
//  Copyright © 2018 Ana Calvo. All rights reserved.
//

import UIKit

struct Word: Decodable {
    var textEn: String
    var textSpa: String
    
    enum CodingKeys: String, CodingKey {
        case textEn = "text_eng"
        case textSpa = "text_spa"
    }
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var languageOne: UILabel!
    @IBOutlet weak var languageTwo: UILabel!
    
    var vocabularyEn: [String] = []
    var vocabularySpa: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData()  {
        
        var arrayOfWords = [Word]()
        
        guard let url = URL(string: "https://gist.githubusercontent.com/DroidCoder/7ac6cdb4bf5e032f4c737aaafe659b33/raw/baa9fe0d586082d85db71f346e2b039c580c5804/words.json") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                let decoder = JSONDecoder()
                arrayOfWords = try decoder.decode([Word].self, from: dataResponse)
                
                for i in arrayOfWords {
                    self.vocabularyEn.append(i.textEn)
                    self.vocabularySpa.append(i.textSpa)
                }
                
                DispatchQueue.main.async {
                    self.languageOne.text = self.vocabularyEn[0]
                    self.languageTwo.text = self.vocabularySpa[0]
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
}

