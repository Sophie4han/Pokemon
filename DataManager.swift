//
//  dataManager.swift
//  Pocketmon
//
//  Created by ios_starter on 4/24/25.
//
import Foundation

class Manager {
    
    static var savedContact: [contact] {
        get {
            guard let savingData = UserDefaults.standard.data(forKey: "saveContact") else { return [] }
            return (try? JSONDecoder().decode([contact].self, from: savingData)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "saveContact")
        }
        
    }
}
