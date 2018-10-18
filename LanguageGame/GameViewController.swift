//
//  GameViewController.swift
//  LanguageGame
//
//  Created by Ana Calvo on 17/10/18.
//  Copyright © 2018 Ana Calvo. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    var audioPlayer = AVAudioPlayer()
    var vocabularyEn: [String] = []
    var vocabularySpa: [String] = []
    var indexEn = 0
    var indexSpa = 0
    var isCorrectTranslation = false
    var isCorrectAnswer = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    // MARK: - Data fetching from JSON
    
    func fetchData()  {
        var arrayOfWords = [Word]()
        
        guard let url = URL(string: "https://gist.githubusercontent.com/DroidCoder/7ac6cdb4bf5e032f4c737aaafe659b33/raw/baa9fe0d586082d85db71f346e2b039c580c5804/words.json") else { return }
        
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
                    self.showNextWord()
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    // MARK: - Game checking and answer reaction
    
    func checkTranslation() {
        if indexEn == indexSpa {
            isCorrectTranslation = true
        } else {
            isCorrectTranslation = false
        }
    }
    
    func playCorrectSfx() {
        let correctSfx = NSURL(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: correctSfx as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem in getting sound file")
        }
        audioPlayer.play()
    }
    
    func playWrongSfx() {
        let wrongSfx = NSURL(fileURLWithPath: Bundle.main.path(forResource: "wrong", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: wrongSfx as URL)
            audioPlayer.prepareToPlay()
        } catch {
            print("Problem in getting sound file")
        }
        audioPlayer.play()
    }
    
    func playSfx() {
        isCorrectAnswer ? playCorrectSfx() : playWrongSfx()
    }
    
    @objc func showNextWord() {
        animateTextSpa()
        
        if indexEn < vocabularyEn.count - 1 {
            let randomNumber = Int.random(in: 0 ... 500) // Avoids to create a pattern presenting the matching answers.
            indexEn += 1
            if randomNumber % 3 == 0 {
                indexSpa = Int(arc4random_uniform(UInt32(self.vocabularySpa.count)))
            } else {
                indexSpa = indexEn
            }
            languageOne.text = vocabularyEn[indexEn]
            languageTwo.text = vocabularySpa[indexSpa]
        } else {
            print("GAME OVER")
        }
    }
    
    // MARK: - Text animation
    
    func animateTextSpa() {
        languageTwo.center.y  -= view.bounds.height
        UIView.animate(withDuration: 3, delay: 0.1, options: [.curveEaseIn], animations: {
            self.languageTwo.center.y += self.view.bounds.height
        })
    }
    
    
    // MARK: - Buttons actions
    
    @IBAction func selectCorrect(_ sender: UIButton) {
        checkTranslation()
        isCorrectAnswer = isCorrectTranslation ? true : false
        playSfx()
        perform(#selector(showNextWord), with: nil, afterDelay: 0.5)
    }
    
    @IBAction func selectWrong(_ sender: UIButton) {
        checkTranslation()
        isCorrectAnswer = isCorrectTranslation ? false : true
        playSfx()
        perform(#selector(showNextWord), with: nil, afterDelay: 0.5)
    }
    
}

