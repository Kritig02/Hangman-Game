//
//  ViewController.swift
//  HangmanGame
//
//  Created by Kriti on 2024-02-04.
//

import UIKit

class ViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let getScore = HGLabels(text: "Score: ", backgroundColor: .systemRed)
    let currentAnswer = HGLabels(text: "?????", backgroundColor: .systemPurple, fontSize: 45)
    let answerTextField = HGTextField()
    let buttonsView = UIView()
    let characters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    var letterButton = [UIButton]()
    
    var showImage = 1 {
        didSet {
            logoImageView.image = UIImage(named: "hangman\(showImage)")
        }
    }
    
    var wordtoGuess = String()
    var wordToGuessLetters = [String]()
    var maskedWord = String()
    var maskedWordLetters = [String]()
    var incorrectLetters = [UIButton]()
    
    var gameInProgress: Bool = true {
        didSet {
            if gameInProgress == false {
                endGame()
            }
        }
    }
    
    var guessRemaining = 7 {
            didSet {
                if guessRemaining == 0 {
                    gameInProgress = false
                } else {
                    showImage += 1
                }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HANGMAN"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        configureLogoImage()
        configureAnswerField()
        configureButtonsView()
        startGame()
    }
    
    func configureLogoImage(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "hangman\(showImage)")
        logoImageView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func configureAnswerField(){
        view.addSubview(currentAnswer)
        
        NSLayoutConstraint.activate([
            currentAnswer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.heightAnchor.constraint(equalToConstant: 50),
            currentAnswer.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6, constant: 50)
        ])
    }
    
    func configureButtonsView(){
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = UIColor(red: 255/255, green: 240/255, blue: 245/255, alpha: 1.0)
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.systemPink.cgColor
        buttonsView.layer.cornerRadius = 10
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 10),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0, constant: 230),
            buttonsView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6, constant: 100),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 55
        let height = 45
        
        for row in 0..<5 {
            for col in 0..<6 {
                let index = row * 5 + col
                if index < 26 {
                    let characterButton = UIButton(type: .system)
                    characterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                    characterButton.setTitleColor(UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1.0), for: .normal)
                    characterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                    characterButton.frame = frame
                    buttonsView.addSubview(characterButton)
                    letterButton.append(characterButton)
                }
            }
        }
        
        for (index, letter) in characters.enumerated(){
            let strLetter = String(letter)
            letterButton[index].setTitle(strLetter, for: .normal)
        }
        
    }
    
    func startGame(){
        
        if let wordFile = Bundle.main.url(forResource: "words", withExtension: "txt"){
            if let wordFileContent = try? String(contentsOf: wordFile){
                let wordFileContents = wordFileContent.components(separatedBy: "\n")
                wordtoGuess = wordFileContents.randomElement()!
                if wordtoGuess == "" {
                    wordtoGuess = "dummy"
                }
                print("Word to guess: \(wordtoGuess)")
                
                for letter in wordtoGuess {
                    wordToGuessLetters.append(String(letter))
                }
                
                print("Word to guess letters: \(wordToGuessLetters)")
                
                for _ in 0..<wordtoGuess.count{
                    maskedWord += "?"
                    maskedWordLetters.append("?")
                }
                
                print("Masked word is: \(maskedWord)")
                print("Masked word letters are: \(maskedWordLetters)")
                
                currentAnswer.text = maskedWord
            } else {
                print("Failed to load contents of words.txt file")
                
            }
        } else {
            print("Failed to load words.txt file")
        }
    }
    
    @objc func letterTapped(_ sender: UIButton){
        
        print("button Tapped: \(sender.titleLabel!.text!)")
        
        let enteredLetter = sender.titleLabel!.text!
        
        if wordtoGuess.contains(enteredLetter.lowercased()) == true {
            print("contains same letter in the word")
            
            for (index, letter) in wordToGuessLetters.enumerated(){
                if enteredLetter.lowercased() == String(letter) {
                    maskedWordLetters[index] = letter.lowercased()
                }
            }
            
            maskedWord = maskedWordLetters.joined(separator: "")
            currentAnswer.text = maskedWord
            print(maskedWord)
            
        }else {
            incorrectLetters.append(sender)
            guessRemaining -= 1
        }
        
        sender.isHidden = true
        
        if maskedWord == wordtoGuess || guessRemaining == 0 {
            gameInProgress = false
            endGame()
        }
    }
    
    func endGame(){
        var alertTitle: String
        var alertMessage: String
        
        if guessRemaining == 0 {
            alertTitle = "Oh Nooooo!"
            alertMessage = "You've been HANGED!! 💀"
            
            let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again?", style: .default, handler: restartGame))
            present(ac, animated: true)
        }
        
        if maskedWordLetters == wordToGuessLetters {
            alertTitle = "Phew!"
            alertMessage = "You survied getting HANGED! 🙏"
            
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Play again?", style: .default, handler: restartGame))
            present(alertController, animated: true)
        }
    }
    
    func restartGame(_ alertAction: UIAlertAction){
        currentAnswer.text = ""
        maskedWord.removeAll()
        maskedWordLetters.removeAll()
        wordToGuessLetters.removeAll()
        wordtoGuess.removeAll()
        showImage = 0
        guessRemaining = 7
        for button in letterButton {
            button.isHidden = false
        }
        startGame()
    }

    
}
