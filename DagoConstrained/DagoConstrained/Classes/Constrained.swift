//
//  Constrained.swift
//  DagoConstrained
//
//  Created by Douwe Bos on 15/10/20.
//

import Foundation
import UIKit

public struct Constrained<Base> {
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
public protocol ConstrainedCompatible {
    /// Extended type
    associatedtype ConstrainedBase
    
    /// Constrained extensions.
    static var constrained: Constrained<ConstrainedBase>.Type { get set }
    
    /// Constrained extensions.
    var constrained: Constrained<ConstrainedBase> { get set }
}

extension ConstrainedCompatible {
    /// Constrained extensions.
    public static var constrained: Constrained<Self>.Type {
        get {
            return Constrained<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Constrained to "mutate" base type
        }
    }
    
    /// Constrained extensions.
    public var constrained: Constrained<Self> {
        get {
            return Constrained(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Constrained to "mutate" base object
        }
    }
}

import class Foundation.NSObject

extension NSObject: ConstrainedCompatible { }

extension UIView {
    /// Constrained extensions.
    public static var constrained: Constrained<UIView>.Type {
        get {
            return Constrained<UIView>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Constrained to "mutate" base type
        }
    }
    
    /// Constrained extensions.
    public var constrained: Constrained<UIView> {
        get {
            self.translatesAutoresizingMaskIntoConstraints = false
            return Constrained(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Constrained to "mutate" base object
        }
    }
}


/// Relation between the constraint's first anchor and either the constant or the second anchor
public enum ConstrainedAnchorRelation {
    case equal
    case greaterThanOrEqualTo
    case lessThanOrEqualTo
}


/// Ratio relation types. Either width to height (16:9) or height to width (9:16)
public enum ConstrainedRatioRelation {
    case widthToHeight
    case heightToWidth
}


public enum ConstraintYAxisAnchor {
    case top
    case bottom
}

public enum ConstraintXAxisAnchor {
    case leading
    case trailing
}

/// Different constraint types available
public enum ConstrainedType {
    case center
    case centerX
    case centerY
    case fill
    case frame
    case size
    case height
    case width
    case margin
    case top
    case bottom
    case leading
    case trailing
    case ratio
}

// MARK: - Convenience Helper Functions
extension Constrained where Base: UIView {
    
    /// Sets a margin around the view, relative to its parent view.
    /// - Parameters:
    ///   - top: Top margin
    ///   - bottom: Bottom margin
    ///   - leading: Leading margin
    ///   - trailing: Trailing margin
    ///   - safeArea: Whether the margins should be relative to the safe area layout guides, or not.
    public func margin(
        top: CGFloat? = nil,
        bottom: CGFloat? = nil,
        leading: CGFloat? = nil,
        trailing: CGFloat? = nil,
        safeArea: Bool = false
    ) {
        self.base.superview.also { superview in
            top.also { topConstant in
                clear(constraint: .top)
                
                self.top(
                    to: safeArea ? superview.layoutMarginsGuide.topAnchor : superview.topAnchor,
                    constant: topConstant,
                    priority: nil,
                    isActive: true
                )
            }
            
            bottom.also { bottomConstant in
                clear(constraint: .bottom)
                
                self.bottom(
                    to: safeArea ? superview.layoutMarginsGuide.bottomAnchor : superview.bottomAnchor,
                    constant: bottomConstant,
                    priority: nil,
                    isActive: true
                )
            }
            
            leading.also { leadingConstant in
                clear(constraint: .leading)
                
                self.leading(
                    to: safeArea ? superview.layoutMarginsGuide.leadingAnchor : superview.leadingAnchor,
                    constant: leadingConstant,
                    priority: nil,
                    isActive: true
                )
            }
            
            trailing.also { trailingConstant in
                clear(constraint: .trailing)
                
                self.trailing(
                    to: safeArea ? superview.layoutMarginsGuide.trailingAnchor : superview.trailingAnchor,
                    constant: trailingConstant,
                    priority: nil,
                    isActive: true
                )
            }
        }
    }
    
    public func translate(
        top: CGFloat? = nil,
        bottom: CGFloat? = nil,
        leading: CGFloat? = nil,
        trailing: CGFloat? = nil,
        safeArea: Bool = false
    ) {
        self.base.superview.also { superview in
            top.also { topConstant in
                let oldConstant = superview.constraints.filter { $0.firstAnchor == self.base.topAnchor }.first?.constant ?? 0.0
                clear(constraint: .top)
                self.top(
                    to: safeArea ? superview.layoutMarginsGuide.topAnchor : superview.topAnchor,
                    constant: oldConstant + topConstant,
                    priority: nil,
                    isActive: true
                )
            }
            
            bottom.also { bottomConstant in
                let oldConstant = superview.constraints.filter { $0.firstAnchor == self.base.bottomAnchor }.first?.constant ?? 0.0
                clear(constraint: .bottom)
                self.bottom(
                    to: safeArea ? superview.layoutMarginsGuide.bottomAnchor : superview.bottomAnchor,
                    constant: -(oldConstant + bottomConstant),
                    priority: nil,
                    isActive: true
                )
            }
            
            leading.also { leadingConstant in
                let oldConstant = superview.constraints.filter { $0.firstAnchor == self.base.leadingAnchor }.first?.constant ?? 0.0
                clear(constraint: .leading)
                self.leading(
                    to: safeArea ? superview.layoutMarginsGuide.leadingAnchor : superview.leadingAnchor,
                    constant: oldConstant + leadingConstant,
                    priority: nil,
                    isActive: true
                )
            }
            
            trailing.also { trailingConstant in
                let oldConstant = superview.constraints.filter { $0.firstAnchor == self.base.trailingAnchor }.first?.constant ?? 0.0
                clear(constraint: .trailing)
                self.trailing(
                    to: safeArea ? superview.layoutMarginsGuide.trailingAnchor : superview.trailingAnchor,
                    constant: -(oldConstant + trailingConstant),
                    priority: nil,
                    isActive: true
                )
            }
        }
    }
    
    
    /// Center the view's center x and center y anchors to its parent view.
    public func center() {
        self.base.superview.also { superview in
            clear(constraint: .center)
            
            self.center(to: superview)
        }
    }
    
    
    /// Center the view both horizontally and vertically relative to the given view
    /// - Parameter view: View to which the base view should be centered
    public func center(to view: UIView) {
        self.centerX(to: view.centerXAnchor)
        self.centerY(to: view.centerYAnchor)
    }
    
    public func centerX() {
        self.base.superview.also { superview in
            clear(constraint: .centerX)
            
            self.centerX(to: superview)
        }
    }
    
    @discardableResult
    public func centerX(
        to view: UIView,
        constant: CGFloat = 0.0,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        return self.centerX(
            to: view.centerXAnchor,
            constant: constant,
            priority: priority,
            isActive: isActive
        )
    }
    
    public func centerY() {
        self.base.superview.also { superview in
            clear(constraint: .centerY)
            
            self.centerY(to: superview)
        }
    }
    
    @discardableResult
    public func centerY(
        to view: UIView,
        constant: CGFloat = 0.0,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        return self.centerY(
            to: view.centerYAnchor,
            constant: constant,
            priority: priority,
            isActive: isActive
        )
    }
    
    public func fill(safeArea: Bool = false) {
        self.margin(top: 0.0, bottom: 0.0, leading: 0.0, trailing: 0.0, safeArea: safeArea)
    }
    
    public func fillVertically(safeArea: Bool = false) {
        self.margin(top: 0.0, bottom: 0.0, leading: nil, trailing: nil, safeArea: safeArea)
    }
    
    public func fillHorizontally(safeArea: Bool = false) {
        self.margin(top: nil, bottom: nil, leading: 0.0, trailing: 0.0, safeArea: safeArea)
    }
    
    public func frame(equals view: UIView) {
        clear(constraint: .frame)
        
        self.center(to: view)
        self.size(equals: view)
    }
    
    public func size(equals view: UIView) {
        clear(constraint: .size)
        
        self.width(equals: view)
        self.height(equals: view)
    }
    
    public func width() {
        self.base.superview.also { superview in
            clear(constraint: .width)
            
            self.width(equals: superview)
        }
    }
    
    public func height() {
        self.base.superview.also { superview in
            clear(constraint: .height)
            
            self.height(equals: superview)
        }
    }
    
    public func top() {
        self.base.superview.also { superview in
            clear(constraint: .top)
            
            self.top(to: superview.topAnchor)
        }
    }
    
    public func bottom() {
        self.base.superview.also { superview in
            clear(constraint: .bottom)
            
            self.bottom(to: superview.bottomAnchor)
        }
    }
    
    public func leading() {
        self.base.superview.also { superview in
            clear(constraint: .leading)
            
            self.leading(to: superview.leadingAnchor)
        }
    }
    
    public func trailing() {
        self.base.superview.also { superview in
            clear(constraint: .trailing)
            
            self.trailing(to: superview.trailingAnchor)
        }
    }
}


// MARK: - Clear Constraints
extension Constrained where Base: UIView {
    public func clear(constraint: ConstrainedType) {
        switch constraint {
        case .center:
            clear(constraint: .centerX)
            clear(constraint: .centerY)
        case .centerX:
            self.base.superview.also { superview in
                superview.removeConstraints(
                    superview.constraints.filter { $0.firstAnchor == self.base.centerXAnchor }
                )
            }
        case .centerY:
            self.base.superview.also { superview in
                superview.removeConstraints(
                    superview.constraints.filter { $0.firstAnchor == self.base.centerYAnchor }
                )
            }
        case .fill:
            clear(constraint: .top)
            clear(constraint: .bottom)
            clear(constraint: .leading)
            clear(constraint: .trailing)
        case .frame:
            clear(constraint: .center)
            clear(constraint: .size)
        case .size:
            clear(constraint: .width)
            clear(constraint: .height)
        case .bottom:
            self.base.superview.also { superview in
                superview.removeConstraints(
                    superview.constraints.filter { $0.firstAnchor == self.base.bottomAnchor }
                )
            }
        case .height:
            self.base.removeConstraints(
                self.base.constraints.filter { $0.firstAnchor == self.base.heightAnchor && $0.secondAnchor != self.base.widthAnchor }
            )
            
            self.base.superview.also { superview in
                superview.removeConstraints(
                    superview.constraints.filter { $0.firstAnchor == self.base.heightAnchor }
                )
            }
        case .leading:
            self.base.superview.also { superview in
                superview.removeConstraints(
                    superview.constraints.filter { $0.firstAnchor == self.base.leadingAnchor }
                )
            }
        case .ratio:
            self.base.removeConstraints(
                self.base.constraints
                    .filter {
                        $0.firstAnchor == self.base.heightAnchor && $0.secondAnchor == self.base.widthAnchor
                            || $0.firstAnchor == self.base.widthAnchor && $0.secondAnchor == self.base.heightAnchor
                    }
            )
        case .top:
            self.base.superview.also { superview in
                superview.removeConstraints(
                    superview.constraints.filter { $0.firstAnchor == self.base.topAnchor }
                )
            }
        case .trailing:
            self.base.superview.also { superview in
                superview.removeConstraints(
                    superview.constraints.filter { $0.firstAnchor == self.base.trailingAnchor }
                )
            }
        case .width:
            self.base.removeConstraints(
                self.base.constraints.filter { $0.firstAnchor == self.base.widthAnchor && $0.secondAnchor != self.base.heightAnchor }
            )
            
            self.base.superview.also { superview in
                superview.removeConstraints(
                    superview.constraints.filter { $0.firstAnchor == self.base.widthAnchor }
                )
            }
        case .margin:
            clear(constraint: .top)
            clear(constraint: .bottom)
            clear(constraint: .leading)
            clear(constraint: .trailing)
        }
    }
}


// MARK: - Top Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func top(
        to view: UIView,
        anchor: ConstraintYAxisAnchor = .top,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        switch anchor {
        case .top:
            return top(to: view.topAnchor,
                       constant: constant,
                       relation: relation,
                       priority: priority,
                       isActive: isActive
            )
        case .bottom:
            return top(to: view.bottomAnchor,
                       constant: constant,
                       relation: relation,
                       priority: priority,
                       isActive: isActive
            )
        }
    }
    
    @discardableResult
    public func top(
        to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.topAnchor.constraint(equalTo: anchor, constant: constant)
        case .greaterThanOrEqualTo:
            constraint = self.base.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        case .lessThanOrEqualTo:
            constraint = self.base.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Bottom Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func bottom(
        to view: UIView,
        anchor: ConstraintYAxisAnchor = .bottom,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        switch anchor {
        case .top:
            return bottom(to: view.topAnchor,
                          constant: constant,
                          relation: relation,
                          priority: priority,
                          isActive: isActive
            )
        case .bottom:
            return bottom(to: view.bottomAnchor,
                          constant: constant,
                          relation: relation,
                          priority: priority,
                          isActive: isActive
            )
        }
    }
    
    @discardableResult
    public func bottom(
        to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.bottomAnchor.constraint(equalTo: anchor, constant: constant * -1.0)
        case .greaterThanOrEqualTo:
            constraint = self.base.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant * -1.0)
        case .lessThanOrEqualTo:
            constraint = self.base.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant * -1.0)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Leading Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func leading(
        to view: UIView,
        anchor: ConstraintXAxisAnchor = .leading,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        switch anchor {
        case .leading:
            return leading(to: view.leadingAnchor,
                           constant: constant,
                           relation: relation,
                           priority: priority,
                           isActive: isActive
            )
        case .trailing:
            return leading(to: view.trailingAnchor,
                           constant: constant,
                           relation: relation,
                           priority: priority,
                           isActive: isActive
            )
        }
    }
    
    @discardableResult
    public func leading(
        to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.leadingAnchor.constraint(equalTo: anchor, constant: constant)
        case .greaterThanOrEqualTo:
            constraint = self.base.leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant)
        case .lessThanOrEqualTo:
            constraint = self.base.leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Trailing Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func trailing(
        to view: UIView,
        anchor: ConstraintXAxisAnchor = .trailing,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        switch anchor {
        case .leading:
            return trailing(to: view.leadingAnchor,
                            constant: constant,
                            relation: relation,
                            priority: priority,
                            isActive: isActive
            )
        case .trailing:
            return trailing(to: view.trailingAnchor,
                            constant: constant,
                            relation: relation,
                            priority: priority,
                            isActive: isActive
            )
        }
    }
    
    @discardableResult
    public func trailing(
        to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.trailingAnchor.constraint(equalTo: anchor, constant: constant * -1.0)
        case .greaterThanOrEqualTo:
            constraint = self.base.trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant * -1.0)
        case .lessThanOrEqualTo:
            constraint = self.base.trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant * -1.0)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Center Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func centerX(
        to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>,
        constant: CGFloat = 0.0,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint = self.base.centerXAnchor.constraint(equalTo: anchor, constant: constant)
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
    
    @discardableResult
    public func centerY(
        to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>,
        constant: CGFloat = 0.0,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint = self.base.centerYAnchor.constraint(equalTo: anchor, constant: constant)
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Height Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func height(
        equals view: UIView,
        multiplier: CGFloat = 1.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier)
        case .greaterThanOrEqualTo:
            constraint = self.base.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: multiplier)
        case .lessThanOrEqualTo:
            constraint = self.base.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: multiplier)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
    
    @discardableResult
    public func height(
        equals constant: CGFloat,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.heightAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqualTo:
            constraint = self.base.heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqualTo:
            constraint = self.base.heightAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Width Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func width(
        equals view: UIView,
        multiplier: CGFloat = 1.0,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier)
        case .greaterThanOrEqualTo:
            constraint = self.base.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: multiplier)
        case .lessThanOrEqualTo:
            constraint = self.base.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: multiplier)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
    
    @discardableResult
    public func width(
        equals constant: CGFloat,
        relation: ConstrainedAnchorRelation = .equal,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint!
        
        switch relation {
        case .equal:
            constraint = self.base.widthAnchor.constraint(equalToConstant: constant)
        case .greaterThanOrEqualTo:
            constraint = self.base.widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqualTo:
            constraint = self.base.widthAnchor.constraint(lessThanOrEqualToConstant: constant)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}


// MARK: - Aspect Ratio Constraints
extension Constrained where Base: UIView {
    @discardableResult
    public func ratio(
        ratio: CGFloat,
        relation: ConstrainedRatioRelation = .widthToHeight,
        priority: UILayoutPriority? = nil,
        isActive: Bool = true
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        
        switch relation {
        case .widthToHeight:
            constraint = self.base.widthAnchor.constraint(equalTo: self.base.heightAnchor, multiplier: ratio)
        case .heightToWidth:
            constraint = self.base.heightAnchor.constraint(equalTo: self.base.widthAnchor, multiplier: ratio)
        }
        
        priority.also {
            constraint.priority = $0
        }
        
        constraint.isActive = isActive
        
        return constraint
    }
}

extension Constrained where Base: UIView {
    public func hugging(
        axis: NSLayoutConstraint.Axis,
        priority: UILayoutPriority = .required
    ) {
        self.base.setContentHuggingPriority(priority, for: axis)
    }
    
    public func compression(
        axis: NSLayoutConstraint.Axis,
        priority: UILayoutPriority = .required
    ) {
        self.base.setContentCompressionResistancePriority(priority, for: axis)
    }
}
