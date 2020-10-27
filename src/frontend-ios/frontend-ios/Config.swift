//
//  Config.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 26/10/2020.
//

import Foundation

enum Env: String {
    case dev = "dev"
    case acc = "acc"
    case prod = "prod"
}

struct Config {
    static let env = Env(rawValue: ProcessInfo.processInfo.environment["ENV"]!)!
}
