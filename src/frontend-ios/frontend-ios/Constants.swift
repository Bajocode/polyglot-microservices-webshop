//
//  Constants.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 18/11/2020.
//

import Foundation

internal enum Constants {
    internal enum UserDefaults {
        static let tokenKey = "token"
        static let tokenExpiryKey = "tokenExpiry"
    }

    internal enum Formatter {
        internal static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()

        internal static let priceFormatter: NumberFormatter = {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencyCode = "USD"
            return currencyFormatter
        }()
    }

    internal enum Format {
        internal static func dateString(timestamp: TimeInterval) -> String {
            let date = Date(timeIntervalSince1970: timestamp)
            return Constants.Formatter.dateFormatter.string(from: date)
        }

        internal static func price(cents: Int) -> String {
            let amount = NSNumber(value: Double(cents) / 100.0)

            return Formatter.priceFormatter.string(from: amount) ?? ""
        }
    }
}
