//
//  CalculateTollModel.swift
//  Smart Motorways
//
//  Created by shayan on 10/12/2021.
//

import Foundation

public struct CalculateTollModel: Codable {
    let code: String?
    let data: [CalculateTollDataModel]?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case data = "Data"
        case message = "Message"
    }
}

public struct CalculateTollDataModel: Codable {
    let toll: String?
}
