//
//  TimesServices.swift
//  Times Rush
//
//  Created by Ryan Rouxinol on 20/01/25.
//

class TimesServices {
    
    func genTimes() -> (Int, Int) {
        let multiplicand = Int.random(in: 1...10)
        let multiplier = Int.random(in: 1...10)
        return (multiplicand, multiplier)
    }
    
    func genAnswer(multiplicand: Int, multiplier: Int) -> [Int] {
        let correctAnswer =  multiplicand * multiplier
        var answer: Set<Int> = [correctAnswer]
        
        while answer.count < 4 {
            let randomValue = Int.random(in: 1...6)
            let newValue = Bool.random() ? correctAnswer + randomValue : max(1, correctAnswer - randomValue)
            
            answer.insert(newValue)
        }
        return Array(answer).shuffled()
    }
}
