//
//  MotorwayModel.swift
//  Smart Motorways
//
//  Created by shayan on 07/12/2021.
//

import Foundation

struct CalculateTollTypeModel {
    private let name: String
    private let id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    func getName() -> String {
        return name
    }
    
    func getID() -> Int {
        return id
    }
}
