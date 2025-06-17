//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Wannipa Reya on 20/6/2568 BE.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
