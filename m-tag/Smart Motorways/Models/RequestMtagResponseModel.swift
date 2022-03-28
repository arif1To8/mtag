//
//  RequestMtagResponseModel.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 19/06/2021.
//

import Foundation

public struct RequestMtagResponseModel: Codable {
    let Code: String?
    let Data: RequestMtagResponseObject?
    let Message: String?
}

public struct RequestMtagResponseObject: Codable {
    let Pending_MTAG_Detail: [RequestMtagResponse]?
}

public struct RequestMtagResponse: Codable {
    let ADDRESS: String?
    let CNICNUMBER: String?
    let FULLNAME: String?
    let MOBILENUMBER: String?
    let REF_NO: Int?
    let REQ_TYPE: Int?
    let VEHICLEMAKEMODEL: String?
    let VEHICLEREGISTRATIONNUMBER: String?
    let VEHICLETYPE: String?
    let access_token: String?
}


public struct RechargeSummaryResponseModel: Codable {
    let code: String?
    let data: [RechargeSummaryDataResponseModel]?
    let message: String?
    
    
    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case data = "Data"
        case message = "Message"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        data = try values.decodeIfPresent([RechargeSummaryDataResponseModel].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

public struct RechargeSummaryDataResponseModel: Codable {
    let charges_Taxes_FED: String?
    let m_Tag_Balance: String?
    let total_Recharge_Amount: Double?
    
    enum CodingKeys: String, CodingKey {
        case charges_Taxes_FED = "Charges,Taxes,FED Rs."
        case m_Tag_Balance = "M-Tag Balance Rs."
        case total_Recharge_Amount = "Total Recharge Amount Rs."

    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        charges_Taxes_FED = try values.decodeIfPresent(String.self, forKey: .charges_Taxes_FED)
        m_Tag_Balance = try values.decodeIfPresent(String.self, forKey: .m_Tag_Balance)
        total_Recharge_Amount = try values.decodeIfPresent(Double.self, forKey: .total_Recharge_Amount)
    }
}
