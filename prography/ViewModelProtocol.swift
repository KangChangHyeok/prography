//
//  ViewModelProtocol.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import Foundation

public protocol ViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Action
    associatedtype State

    var state: State { get set }
    func send(_ input: Input)
    func transform(_ input: Input) -> [Action]
    func perform(_ action: Action)
}

public extension ViewModelProtocol {
    
    func send(_ input: Input) {
        transform(input)
            .forEach { action in
                perform(action)
            }
    }
}
