//
//  GenerateOTPResponseModel.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 27/06/2021.
//

import Foundation

public struct GenerateOTPResponseModel: Codable {
    let Code: String?
    let Data: String?
    let Message: String?
}
