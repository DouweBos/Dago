//
//  Tracked.swift
//  DagoConstrained
//
//  Created by Douwe Bos on 20/10/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public protocol TrackedEvent {
    associatedtype TrackedEventProperties
    
    var eventTitle: String { get }
    var eventProperties: TrackedEventProperties { get }
    
    func post()
}

public struct Tracked<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has constrained extensions.
public protocol TrackedCompatible {
    /// Extended type
    associatedtype TrackedBase

    /// Reactive extensions.
    static var tracked: Tracked<TrackedBase>.Type { get set }

    /// Reactive extensions.
    var tracked: Tracked<TrackedBase> { get set }
}

extension TrackedCompatible {
    /// Reactive extensions.
    public static var tracked: Tracked<Self>.Type {
        get {
            return Tracked<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base type
        }
    }

    /// Reactive extensions.
    public var tracked: Tracked<Self> {
        get {
            return Tracked(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

import class Foundation.NSObject

extension NSObject: TrackedCompatible { }

extension Tracked where Base: UIButton {
    public func tap<Event: TrackedEvent>(_ event: Event, block: @escaping (() -> Swift.Void)) -> Disposable {
        return self.base.rx.tap
            .subscribe(
                onNext: {
                    event.post()
                    
                    block()
                }
            )
    }
    
    public func tap<Event: TrackedEvent>(block: @escaping (() -> Swift.Void), event: @escaping (() -> Event)) -> Disposable {
        return self.base.rx.tap
            .subscribe(
                onNext: {
                    event().post()
                    
                    block()
                }
            )
    }
}
