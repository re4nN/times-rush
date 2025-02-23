//
//  TimerBar.swift
//  Times Rush
//
//  Created by Ryan Rouxinol on 16/01/25.
//

import Foundation
import UIKit

class TimerBar {
    var timerBar: UIProgressView
    var timer: Timer?
    let totalTime: Float
    var startTime: Date?
    
    init(totalTime: Float){
        self.totalTime = totalTime
        self.timerBar = UIProgressView(progressViewStyle: .default)
        self.timerBar.progress = 1.0
        self.timerBar.tintColor = UIColor.yellowMainColorAsset
    }
    
    
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateTimerBar), userInfo: nil, repeats: true)
       }
    
    @objc func updateTimerBar() {
        guard let startTime = startTime else { return }
        
        let elapsedTime = Float(Date().timeIntervalSince(startTime))
        let remainingTime = max(totalTime - elapsedTime, 0)

        
        let progress = remainingTime / totalTime
        timerBar.setProgress(progress, animated: true)
        
        if remainingTime <= 0 {
            timer?.invalidate()
            timer = nil
            timerBar.setProgress(0.0, animated: true)
            print("Tempo acabou!")
        }
    }

    
}
