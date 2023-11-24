//
//  ViewController.swift
//  Project6
//
//  Created by Павел Чвыров on 20.11.2023.
//

import UIKit

class TableViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let allWordsLongString = try? String(contentsOf: startWordsUrl){
                allWords = allWordsLongString.components(separatedBy: "\n")
            }
        }

//        allWords.append("Экперимент")

        
//        if allWords.isEmpty{
//            allWords.append("silkworm")
//        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addingNewWordAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        
        
        startGame()
        
        
    }
    @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = usedWords[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    
    @objc func addingNewWordAction(){
        let alertController = UIAlertController(title: "Напишите слово, состоящее из букв изначального слова", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Отправить", style: .default) { [weak self, weak alertController] action in
            
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer)
            
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true)
        
//        deinit{
//            print("addingNewWordAction was destroyed")
//        }
        
    }
    
    
    func submit(_ answer : String){
        
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        
        
        let lowerAnswer = answer.lowercased()
        //        if isPossible(word: lowerAnswer) && isReal(word: lowerAnswer) && isOriginal(word: lowerAnswer) && isMore3Char(word: lowerAnswer) && isStartWord(word: lowerAnswer){
        //            usedWords.insert(answer, at: 0)
        //
        //
        //            let indexPath = IndexPath(row: 0, section: 0)
        //            tableView.insertRows(at: [indexPath], with: .automatic)
        //        }
        if isStartWord(word: lowerAnswer){
            print(lowerAnswer)
            print(title!)
            alertController.title = "Это изначальное слово.\nНапишите другое слово."
            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alertController, animated: true)
            return
        }
        if isNotOriginal(word: lowerAnswer){
            alertController.title = "Это слово уже в списке.\nНапишите другое слово."
            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alertController, animated: true)
            return
        }
        if isLess3Char(word: lowerAnswer){
            alertController.title = "Нельзя писать слова в которых нет хотя-бы трех букв.\nНапишите другое слово."
            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alertController, animated: true)
            return
        }
        if isNotPossible(word: lowerAnswer){
            alertController.title = "Некоторые буквы отсутствуют в изначальном слове.\nНапишите другое слово."
            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alertController, animated: true)
            return
        }
        if isNotReal(word: lowerAnswer){
            alertController.title = "Такого слова не существует.\nНапишите другое слово."
            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alertController, animated: true)
            return
        }
        
        usedWords.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        
    }
    
    func isStartWord (word : String) -> Bool{
        if word == title!.lowercased(){
            return true
        }
        else{
            return false
        }
    }
    
    func isNotOriginal(word : String) -> Bool{
        return usedWords.contains(word.lowercased())
    }
    
    
    func isNotPossible(word : String) -> Bool{
        guard var titleWord = title?.lowercased()  else { return false }
        
        for letter in word{
            if titleWord.contains(letter){
                titleWord.remove(at: titleWord.firstIndex(of: letter)!)
            }
            else {
                return true
            }
        }
        return false
    }
    
    func isLess3Char (word  : String) -> Bool{
        if word.count < 3{
            return true
        }
        return false
    }
    
    
    func isNotReal(word : String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false , language: "en")
        
        return misspelledRange.location != NSNotFound
    }
    
    
    


}

