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
}
