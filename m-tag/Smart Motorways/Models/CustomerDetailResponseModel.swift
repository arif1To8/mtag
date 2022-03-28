//
//  CustomerDetailResponseModel.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 13/06/2021.
//

import Foundation

public struct ActiveMtagResponseModel: Codable {
    let Code: String?
    let Data: [MtagDetailsObject]?
    let Message: String?
}

public struct CustomerDetailResponseModel: Codable {
    let Code: String?
    let Data: CustomerDetailDataResponseModel?
    let Message: String?
}

public struct CustomerDetailDataResponseModel: Codable {
    let Customer_Detail: CustomerDetailObject?
}

public struct CustomerDetailObject: Codable {
    let cnic: String?
    let fullname: String?
    let mobileNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case cnic = "CNIC"
        case fullname = "Full Name"
        case mobileNumber = "Mobile Number"
    }
}

public struct MtagDetailsObject: Codable {
    let balance: String?
    let cnic: String?
    let contactno: String?
    let expirydate: String?
    let isactive: String?
    let issuedate: String?
    let ownername: String?
    let registration: String?
    let tokenno: String?
    let veh_type: String?
//    let ADDRESS: String?
//    //let ADDRESS2: String?
//    let BALANCE: Float?
//    let CARFRONTPICTURE: String?
//    let CNIC: String?
//    let CNICBACKPICTURE: String?
//    let CNICFRONTPICTURE: String?
//    let CNICNUMBER: String?
//    let COMPANYID: Float?
//    let CONTACTNO: String?
//    //let CONTACTNO2: String?
//    //let CURRENTENTRYSTATION: String?
//    let ENTRYTIME: String?
//    let EXITSTATTION: Float?
//    let EXITTIME: String?
//    let EXPIRYDATE: String?
//    let FULLNAME: String?
//    //let INACTIVE_TOKEN: String?
//    let ISACTIVE: Float?
//    let ISSUEDATE: String?
//    //let ISSUED_BY: String?
//    let ITOKENNO: Float?
//    let MOBILENUMBER: String?
//    let MTAGISSUEDATE: String?
//    let OTP: String?
//    let REF_NO: Float?
//    let REGISTRATION: String?
//    //let REGWITHFWO: String?
//    //let REG_YEAR: String?
//    //let REMARKS: String?
//    let REQ_TYPE: Int?
//    let SMARTTAGID: String?
//    let STID: String?
//    //let TAGOWNER: String?
//    let TAGTYPE: Float?
//    //let TOLL_BALANCE: String?
//    let UPDATETIME: String?
//    //let VEHCOLOR: String?
//    //let VEHENGINENO: String?
//    let VEHICLEMAKEMODEL: String?
//    let VEHICLEREGISTRATIONNUMBER: String?
//    //let VEHICLETYPE: String?
//    //let VEHMAKE: String?
//    //let VEHMODEL: String?
//    let id: Int?
}
