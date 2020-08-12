//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Arin Asawa on 6/25/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    var answersChosen:[Answer]=[]
    @IBOutlet var questionProgressView: UIProgressView!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButton1: UIButton!
    @IBOutlet var singleButton2: UIButton!
    @IBOutlet var singleButton3: UIButton!
    @IBOutlet var singleButton4: UIButton!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabel1: UILabel!
    @IBOutlet var multipleLabel2: UILabel!
    @IBOutlet var multipleLabel3: UILabel!
    @IBOutlet var multipleLabel4: UILabel!
    @IBOutlet var multipleStackViewSwitches:[UISwitch]!
    
    @IBOutlet var rangeStackView: UIStackView!
    @IBOutlet var rangeLabel1: UILabel!
    @IBOutlet var rangeLabel2: UILabel!
    @IBOutlet var rangeSlider: UISlider!
    
    var questionIndex=0
    var questions: [Question] = [
        Question(text: "Which food do you like the most?",
                 type:.single,
                 answers: [
                    Answer(text: "Steak", type: .dog),
                    Answer(text: "Fish", type: .cat),
                    Answer(text: "Carrots", type: .rabbit),
                    Answer(text: "Corn", type: .turtle)
                          ]),
        Question(text: "Which activities do you enjoy?",
                                       type: .multiple,
                                       answers: [
                                          Answer(text: "Swimming", type: .turtle),
                                          Answer(text: "Sleeping", type: .cat),
                                          Answer(text: "Cuddling", type: .rabbit),
                                          Answer(text: "Eating", type: .dog)
                                                ]),
        Question(text: "How much do you enjoy car rides?",
                                       type: .ranged,
                                       answers: [
                                          Answer(text: "I dislike them", type: .cat),
                                          Answer(text: "I get a little nervous",
                                                type: .rabbit),
                                          Answer(text: "I barely notice them",
                                                type: .turtle),
                                          Answer(text: "I love them", type: .dog)
                                               ])
                              ]
    
    
 


    override func viewDidLoad() {
        super.viewDidLoad()
        randomize()
        updateUI()
    }
    
    func updateUI(){
        singleStackView.isHidden=true
        multipleStackView.isHidden=true
        rangeStackView.isHidden=true
        
        let currentQuestion=questions[questionIndex]
        let currentAnswers=currentQuestion.answers
        let currentProgress=Float(questionIndex)/Float(questions.count)
        
        navigationItem.title="Question #\(questionIndex+1)"
        questionLabel.text=currentQuestion.text
        questionProgressView.setProgress(currentProgress, animated: true)
        
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswers)
        case .multiple:
            updateMultipleStack(using: currentAnswers)
        case .ranged:
            updateRangedStack(using: currentAnswers)
        }
    }
    
    
    func updateSingleStack(using answers:[Answer]){
        singleStackView.isHidden=false
        singleButton1.setTitle(answers[0].text, for: .normal)
        singleButton2.setTitle(answers[1].text, for: .normal)
        singleButton3.setTitle(answers[2].text, for: .normal)
        singleButton4.setTitle(answers[3].text, for: .normal)
    }
    
    func updateMultipleStack(using answers:[Answer]){
        multipleStackView.isHidden=false
        for Switch in multipleStackViewSwitches{
            Switch.isOn=false
        }
        multipleLabel1.text=answers[0].text
        multipleLabel2.text=answers[1].text
        multipleLabel3.text=answers[2].text
        multipleLabel4.text=answers[3].text

    }
    
    func updateRangedStack(using answers:[Answer]){
        rangeStackView.isHidden=false
        rangeSlider.setValue(0.5, animated: false)
        rangeLabel1.text=answers.first?.text
        rangeLabel2.text=answers.last?.text
    }
    
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        switch sender{
        case singleButton1:
            answersChosen.append(questions[questionIndex].answers[0])
        case singleButton2:
               answersChosen.append(questions[questionIndex].answers[1])
        case singleButton3:
               answersChosen.append(questions[questionIndex].answers[2])
        case singleButton4:
               answersChosen.append(questions[questionIndex].answers[3])
            
        default:
            break
        }
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed(_ sender: Any) {
        
        for (index,Switch) in multipleStackViewSwitches.enumerated(){
            if Switch.isOn{
                answersChosen.append(questions[questionIndex].answers[index])
            }
        }
       
        nextQuestion()
    }
    @IBAction func rangeAnswerButtonPressed(_ sender: Any) {
        let currentAnswers=questions[questionIndex].answers
        let index=Int(round(rangeSlider.value*Float(currentAnswers.count-1)))
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
    func nextQuestion(){
        questionIndex+=1
        if questionIndex<questions.count{
        updateUI()
        }else{
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
    
    @IBAction func rangeSliderValueChanged(_ sender: Any) {
        let currentAnswers=questions[questionIndex].answers
               let index=Int(round(rangeSlider.value*Float(currentAnswers.count-1)))
        print("The index is \(index) and the slider value is \(rangeSlider.value)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="ResultsSegue"{
            let resultsViewController=segue.destination as! ResultsViewController
            resultsViewController.responses=answersChosen
        }
    }
    
    func randomize(){
        questions.shuffle()
        var i=0
        while(i<questions.count){
            questions[i].randomizeanswers()
            i+=1
        }
    }
}
