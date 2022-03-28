//
//  GetOwnerNameModel.swift
//  Smart Motorways
//
//  Created by shayan on 23/12/2021.
//

import Foundation

public struct GetOwnerNameModel: Codable {
    let code: String?
    let data: [GetOwnerNameDataModel]?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case data = "Data"
        case message = "Message"
    }
}

public struct GetOwnerNameDataModel: Codable {
    let isActive: String?
    let ownerName: String?
    
    enum CodingKeys: String, CodingKey {
        case isActive = "IS_ACTIVE"
        case ownerName = "OWNERNAME"
    }
}
