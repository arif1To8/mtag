//
//  TransactionModel.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 14/06/2021.
//

import Foundation

enum TransactionType {
    case payment
    case recharge
}

public struct TransactionModel {
    let type: TransactionType
    let city: String
    let date: String
    let amount: Int
}
