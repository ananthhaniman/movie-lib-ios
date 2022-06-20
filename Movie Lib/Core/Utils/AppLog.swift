//
//  AppLog.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-25.
//

import Foundation

class AppLog{
    
    static let shared = AppLog()
    private final let APP_LOG_KEY = "APP_ACCESS_TIME"
    
    // MARK: - Save current Timestamp in Local Storage memory
    func log(){
        let date = Date()
        UserDefaults.standard.set(date, forKey: APP_LOG_KEY)
    }
    
    // MARK: - Validate and Retrive Saved Timestamp in Well Formatted Text
    func getLastAccess() -> String?{
        if let acDate = (UserDefaults.standard.object(forKey: APP_LOG_KEY)  as? Date) {
            return acDate.timeAgoDisplay()
        }
        return nil
    }
}
