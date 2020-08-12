//
//  ResultsViewController.swift
//  PersonalityQuiz
//
//  Created by Arin Asawa on 6/25/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet var resultAnswerLabel: UILabel!
    @IBOutlet var resultDefinitionLabel: UILabel!
    var responses:[Answer]!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton=true
        calculatePersonalityResults()
    }
    
    func calculatePersonalityResults(){
        var frequencyOfAnswers:[AnimalType:Int]=[:]
        let responseTypes=responses.map{$0.type}
        for responseType in responseTypes{
            let newCount:Int
            if let oldCount=frequencyOfAnswers[responseType]{
               newCount=oldCount+1
            }else{
                newCount=1
            }
            frequencyOfAnswers[responseType]=newCount
        }
        let frequentAnswersSorted = frequencyOfAnswers.sorted(by:
        { (pair1, pair2) -> Bool in
            return pair1.value > pair2.value
        })
        let mostCommonAnswer = frequencyOfAnswers.sorted { $0.1 > $1.1 }.first!.key
        displayresult(result: mostCommonAnswer)
    }
    
    func displayresult(result:AnimalType){
        resultAnswerLabel.text=String("You are a \(result.rawValue)!")
        resultDefinitionLabel.text=result.definition
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
