//
//  Constrainable.swift
//  DagoConstrained
//
//  Created by Douwe Bos on 15/10/20.
//

import Foundation
import UIKit

public protocol ConstrainedCustomAddChildView {
    func addChild(view: UIView)
}

extension UIStackView: ConstrainedCustomAddChildView {
    public func addChild(view: UIView) {
        addArrangedSubview(view)
    }
}

public extension ConstrainedCompatible where Self: UIView {
    @discardableResult
    static func instance(
        initializer: (() -> Self)? = nil,
        _ block: (Self) throws -> Void
    ) rethrows -> Self {
        let instance = initializer?() ?? Self.init()
        try block(instance)
        return instance
    }
    
    @discardableResult
    static func with(
        initializer: (() -> Self)? = nil,
        parent parentView: UIView,
        handler: ((Self) throws -> Void)? = nil
    ) rethrows -> Self {
        return try Self.instance(initializer: initializer) { instance in
            if let parentStackview = parentView as? ConstrainedCustomAddChildView {
                parentStackview.addChild(view: instance)
            } else {
                parentView.addSubview(instance)
            }
            
            try handler?(instance)
        }
    }
}

public extension UIStackView {
    @discardableResult
    static func with(parent: UIView, arrangedSubviews: [UIView], handler: ((UIStackView) throws -> Void)? = nil) rethrows -> UIStackView {
        return try UIStackView.with(
            initializer: { return UIStackView(arrangedSubviews: arrangedSubviews) },
            parent: parent,
            handler: handler
        )
    }
}
public extension UIImageView {
    @discardableResult
    static func with(parent: UIView, image: UIImage?, handler: ((UIImageView) throws -> Void)? = nil) rethrows -> UIImageView {
        return try UIImageView.with(
            initializer: { return UIImageView(image: image) },
            parent: parent,
            handler: handler
        )
    }
}
