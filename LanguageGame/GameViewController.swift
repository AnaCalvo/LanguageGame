//
//  GameViewController.swift
//  LanguageGame
//
//  Created by Ana Calvo on 17/10/18.
//  Copyright © 2018 Ana Calvo. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textEnLabel: UILabel!
    @IBOutlet weak var textSpaLabel: UILabel!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    var vocabularyEn: [String] = []
    var vocabularySpa: [String] = []
    var scoreCounter = 0
    var indexEn = 0
    var indexSpa = 0
    var isCorrectTranslation = false
    var isCorrectAnswer = false
    let service = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    // MARK: - Data fetching from JSON
    
    func fetchData()  {
        service.fetchData { (words, error) in
            guard let words = words else {
                if let error = error {
                    self.handleError(error)
                }
                return
            }
            for i in words {
                self.vocabularyEn.append(i.textEn)
                self.vocabularySpa.append(i.textSpa)
            }
            DispatchQueue.main.async {
                self.showNextWord()
            }
        }
    }
    
    func handleError(_ error: ServiceError) {
        switch error {
        case .parsingError, .noInternet, .urlError:
            print("Error")
        //TODO: Create an alert for error
        case .custom(let e):
            print(e.localizedDescription)
        }
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
        scoreCounter += 1
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
            counterLabel.text = "You scored: \(self.scoreCounter) points"
            textEnLabel.text = vocabularyEn[indexEn]
            textSpaLabel.text = vocabularySpa[indexSpa]
        } else {
            showResult()
        }
    }
    
    func showResult() {
        if scoreCounter >= 200 {
            counterLabel.text = "You scored \(scoreCounter) points.\nCongratulations 🎉 You nailed it!"
        }
        else if scoreCounter <= 100 {
            counterLabel.text = "You scored \(scoreCounter) points.\nYou need to study more 🤓"
        } else {
            counterLabel.text = "You scored \(scoreCounter) points.\nThat was average...come on!\nyou can do it better! 💪"
        }
        textEnLabel.isHidden = true
        textSpaLabel.isHidden = true
        correctButton.isHidden = true
        wrongButton.isHidden = true
        playAgainButton.isHidden = false
    }
    
    func startNewGame() {
        scoreCounter = 0
        indexEn = 0
        indexSpa = 0
        isCorrectTranslation = false
        isCorrectAnswer = false
        textEnLabel.isHidden = false
        textSpaLabel.isHidden = false
        correctButton.isHidden = false
        wrongButton.isHidden = false
        playAgainButton.isHidden = true
        fetchData()
    }
    
    // MARK: - Text animation
    
    func animateTextSpa() {
        textSpaLabel.center.y -= view.bounds.height
        UIView.animate(withDuration: 3,
                       delay: 0.1,
                       options: [.curveEaseIn],
                       animations: {
                        self.textSpaLabel.center.y += self.view.bounds.height
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
    
    @IBAction func playAgainAction(_ sender: Any) {
        startNewGame()
    }
    
}

