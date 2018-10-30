//
//  GameBrain.swift
//  LanguageGame
//
//  Created by Ana Calvo on 30/10/18.
//  Copyright © 2018 Ana Calvo. All rights reserved.
//

import Foundation

class GameBrain {
    
    var vocabularyEn: [String] = []
    var vocabularySpa: [String] = []
    var words: [Word] = []
    var scoreCounter = 0
    var indexEn = 0
    var indexSpa = 0
    var isCorrectTranslation = false
    var isCorrectAnswer = false
    let correctPercentage = 0.5
    
    func setWords(_ words: [Word]) {
        self.words = words
    }
    
    func generateWord() -> Word {
        var word = words[Int.random(in: 0..<words.count)]
        if Bool.random() {
            word.textSpa = words[Int.random(in: 0..<words.count)].textSpa
        }
        return word
    }
    
    func evaluateWord(word: Word) -> Bool {
        let correctWord = words.first(where: { $0 == word})
        return correctWord != nil
    }
    
}
