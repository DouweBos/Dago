//
//  Optional+ALso.swift
//  DagoConstrained
//
//  Created by Douwe Bos on 15/10/20.
//

import Foundation

extension Optional {
    /// Mimics Kotlin's .also behavior. Safe un wraps and invokes the closure with the unwrapped value.
    func also(handler: ((Wrapped) -> Swift.Void)) {
        if case let Optional.some(value) = self {
            handler(value)
        }
    }
}
