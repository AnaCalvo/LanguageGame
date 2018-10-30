//
//  Word.swift
//  LanguageGame
//
//  Created by Ana Calvo on 30/10/18.
//  Copyright © 2018 Ana Calvo. All rights reserved.
//

import Foundation

struct Word: Decodable, Equatable {
    var textEn: String
    var textSpa: String
    
    enum CodingKeys: String, CodingKey {
        case textEn = "text_eng"
        case textSpa = "text_spa"
    }
}
