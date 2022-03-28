//
//  RegisterResponseModel.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 14/06/2021.
//

import Foundation

public struct RegisterResponseModel: Codable {
    let Code: String?
    let Data: RegisterResponseObject?
    let Message: String?
}

public struct RegisterResponseObject: Codable {
    let CNICNUMBER: String?
    let FULLNAME: String?
    let MOBILENUMBER: String?
    let REF_NO: Int?
    let access_token: String?
}
