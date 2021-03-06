//
//  Body.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 06.01.19.
//  Copyright © 2019 Falko Schumann. All rights reserved.
//

import Foundation

// TODO: Activity Log als Domain Object
//   Erste Aktivität: Ja/Nein -> Fragen
//   Selbe Aktivität: Ja/Nein -> Letzte merken

// TODO: Activity Log Provider
// TODO: Preferences Provider
// TODO: Contribution: DMG mit Alias zum Programme-Ordner

class Body {
    
    private let period = Period()
    private let activityLog: ActivityLog
    private var preferences: Preferences
    
    var periodDelegate: PeriodDelegate? {
        get { return period.delegate }
        set { period.delegate = newValue }
    }
    
    var periodDuration: TimeInterval {
        get { return preferences.periodDuration }
        set {
            preferences.periodDuration = newValue
            period.duration = newValue
        }
    }
    
    init(activityLog: ActivityLog, preferences: Preferences) {
        self.activityLog = activityLog
        self.preferences = preferences
        
        period.duration = preferences.periodDuration
    }
    
    func check(currentTime: Date) {
        period.check(currentTime: currentTime)
    }
    
    func write(activity: Activity) {
        activityLog.write(activity: activity)
    }
    
}
