//
//  PendingMtagListResponseModel.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 16/06/2021.
//

import Foundation

public struct PendingMtagListResponseModel: Codable {
    let Code: String?
    let Data: PendingMtagListObject?
    let Message: String?
}

public struct PendingMtagListObject: Codable {
    let Pending_MTAG_Detail: [PendingMtagObject]?
}

public struct PendingMtagObject: Codable {
    let ADDRESS: String?
    let CARBACKPICTURE: String?
    let CARFRONTPICTURE: String?
    let CARREGISTRATIONDOC: String?
    let CNICBACKPICTURE: String?
    let CNICFRONTPICTURE: String?
    let CNICNUMBER: String?
    let FULLNAME: String?
    let MOBILENUMBER: String?
    let REF_NO: String?
    let REQ_TYPE: Int?
    let VEHICLEMAKEMODEL: String?
    let VEHICLEREGISTRATIONNUMBER: String?
    let VEHICLETYPE: String?
}
