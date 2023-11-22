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
        
        if allWords.isEmpty{
            allWords.append("silkworm")
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addingNewWordAction))
        
        
        
        startGame()
        
        
    }
    func startGame(){
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
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
            
            guard let answer = alertController?.textFields?[0].text else { return }
            self?.submit(answer)
            
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true)
        
//        deinit{
//            print("addingNewWordAction was destroyed")
//        }
        
    }
    func submit(_ asnwer : String){
        
    }


}

