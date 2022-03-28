//
//  versionCheck.swift
//  Smart Motorways
//
//  Created by fwo on 09/03/2022.
//

import Foundation


// MARK: - VersionCheck
struct VersionCheck: Codable {
    let code, data, message: String?

    enum CodingKeys: String, CodingKey {
        case code = "Code"
        case data = "Data"
        case message = "Message"
    }
}
