//
//  ReactiveTransforming.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 27/10/2020.
//

import Foundation

protocol ReactiveTransforming {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}

