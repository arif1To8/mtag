//
//  MtagDetailResponse.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 14/06/2021.
//

import Foundation

public struct MtagDetailResponse: Codable {
    let Code: String?
    let Data: MtagDetailResponseObject?
    let Message: String?
}

public struct MtagDetailResponseObject: Codable {
    let TagDetail: TagDetailObject?
}

public struct TagDetailObject: Codable {
//    let MTAG_Detail: MtagDetailObject?
    let Transactions: TransactionDetailObject?
}

public struct MtagDetailObject: Codable {
    let BALANCE: Float?
    let CARFRONTPICTURE: String?
    let ITOKENNO: Float?
    let VEHCHASSISNO: String?
    let VEHCOLOR: String?
    let VEHENGINENO: String?
    let VEHICLEREGISTRATIONNUMBER: String?
    let VEHICLETYPE: String?
    let VEHMAKE: String?
    let VEHMODEL: String?
}

public struct TransactionDetailObject: Codable {
    let transactions: [TransactionObject]?
//    let Toll: [TollObject]?
}

public struct TransactionObject: Codable {
    
    let CAR_REGISTRATION: String?
    let CR: String?
    let ENTRY_STATION_NAME: String?
    let EXIT_STATION_NAME: String?
    let FARE: String?
    let ID: String?
    let ITOKKENNO: String?
    let TRANS_TIME: String?


}

//public struct TollObject: Codable {
//    let CREATEDAT: String?
//    //let ENTRY_STATION_ID: Int?
//    let ENTRY_STATION_NAME: String?
//    //let EXIT_STATION_ID: Int?
//    let EXIT_STATION_NAME: String?
//    //let ID: Int?
//    //let IPADDRESS: String?
//    //let LANEID: String?
//    //let MTAG_BAL_CURRENT: Int?
//    //let MTAG_BAL_REMAINING: Int?
//    let MTAG_ID: String?
//    //let OWNER_NAME: String?
//    //let STATUS: Bool?
//    let TOLL: String?
//    //let TRANS_TYPE_ID: Int?
//    //let VEH_ANPR: String?
//    //let VEH_AVC: String?
//    //let VEH_IMG: String?
//    //let XFLAG: Bool?
//    let FARE: String?
//    let CR: String?
//    let TRANS_TIME: String?
//
//}
