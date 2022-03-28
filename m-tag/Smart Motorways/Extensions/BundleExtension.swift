//
//  BundleExtension.swift
//  AddMee
//
//  Created by Abdul Wahab on 30/05/2021.
//

import Foundation

extension Bundle {
    var appName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
   
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
