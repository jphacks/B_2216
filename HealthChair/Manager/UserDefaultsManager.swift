//
//  UserDefaultsManager.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/21.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    let userDefaults = UserDefaults.standard
    func getUserId() -> Int {
        UserDefaults.standard.register(defaults: ["userid": -1])
        var userid = UserDefaults.standard.integer(forKey: "userid")
        if userid == -1 {
            userid = Int.random(in: 0 ..< 1000000)
            UserDefaults.standard.set(userid, forKey: "userid")
        }
        return userid
    }
}
