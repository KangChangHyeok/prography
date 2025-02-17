//
//  Configurable.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

public protocol Configurable {}

public extension Configurable where Self: NSObject {
    func configure(configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }
}

extension NSObject: Configurable {}
