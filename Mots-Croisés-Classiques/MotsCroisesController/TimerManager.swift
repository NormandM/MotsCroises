//
//  TimerManager.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2023-04-06.
//  Copyright © 2023 Normand Martin. All rights reserved.
//

import Foundation
class TimerManager {
    static let shared = TimerManager()
    var seconds = 0
    var isTimerRunning = false
    var timer: Timer?
    
    private init() {}
    
    func startTimer() {
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
        }
    }
    
    func stopTimer() {
        if isTimerRunning {
            timer?.invalidate()
            timer = nil
            isTimerRunning = false
        }
    }
    
    @objc private func updateTimer() {
        seconds += 1
    }
    
    func resetTimer() {
        stopTimer()
        seconds = 0
    }
}
