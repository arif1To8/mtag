//
//  FeedbackListResponse.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 14/09/2021.
//

import Foundation

public struct FeedbackListResponse: Codable {
    let Code: String?
    let Data: [FeedbackResponse]?
    let Message: String?
}

public struct FeedbackResponse: Codable {
    let CNIC: String?
    let DATEOFISSUE: String?
    let FULLNAME: String?
    let ITOKENNO: String?
    let MOBILENUMBER: String?
    let REMARKS: String?
    let STATUS: Bool?
    let SUBMSSIONDATE: String?
    let VEHICLECATEGORY: String?
    let VEHICLENUMBER: String?
}
