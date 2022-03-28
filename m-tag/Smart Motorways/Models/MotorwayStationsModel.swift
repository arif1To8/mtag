//
//  MotorwayStationsModel.swift
//  Smart Motorways
//
//  Created by shayan on 09/12/2021.
//

import Foundation

public struct MotorwayStationsModel: Codable {
    let code: String?
    let data: [MotorwayStationsDataModel]?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case data = "Data"
        case message = "Message"
    }
}

public struct MotorwayStationsDataModel: Codable {
    let stationID: String?
    let stationName: String?
    
    enum CodingKeys: String, CodingKey {
        case stationID = "stid"
        case stationName = "stname"
    }
    
    func getStationID() -> String {
        return stationID ?? ""
    }
    
    func getStationName() -> String {
        return stationName ?? ""
    }
}
