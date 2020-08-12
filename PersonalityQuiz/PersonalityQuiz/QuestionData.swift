//
//  QuestionData.swift
//  PersonalityQuiz
//
//  Created by Arin Asawa on 6/26/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import Foundation

struct Answer{
    var text:String
    var type:AnimalType
}

enum AnimalType:Character{
    case dog = "🐶", cat = "🐱", rabbit = "🐰", turtle = "🐢"
    var definition:String{
        switch self{
        case .dog:
            return
                """
                You are incredibly outgoing.You surround yourself with the people you love and enjoy activities with your friends.
                """
        case .cat:
            return
                """
                Mischievous, yet mild-tempered, you enjoy doing things on your own terms.
                """
        case .rabbit:
             return
                """
                You love everything that's soft. You are healthy and full of energy.
                """
        case .turtle:
              return
                """
                You are wise beyond your years, and you focus on the details. Slow and steady wins the race.  
                """
        }
    }
}

struct Question{
    var text:String
    var type:ResponseType
    var answers:[Answer]
    mutating func randomizeanswers(){
        answers.shuffle()
    }
}

enum ResponseType{
    case single,multiple,ranged
}
