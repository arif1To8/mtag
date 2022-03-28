//
//  TransactionHistoryResponseModel.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 14/06/2021.
//

import Foundation

public struct TransactionHistoryResponseModel: Codable {
    let Code: String?
    let Data: TransactionHistoryObject?
    let Message: String?
}

public struct TransactionHistoryObject: Codable {
    let AllTransactions: [TransactionObject]?
//    let TollTransactions: [TollObject]?
}
