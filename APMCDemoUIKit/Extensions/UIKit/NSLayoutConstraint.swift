//
//  NSLayoutConstraint.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import UIKit

@objc extension NSLayoutDimension {
    func constraint(equalToConstant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: equalToConstant)
        constraint.priority = priority
        return constraint
    }
}

@objc extension NSLayoutAnchor {
    func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor)
        constraint.priority = priority
        return constraint
    }

    func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self.constraint(greaterThanOrEqualTo: anchor)
        constraint.priority = priority
        return constraint
    }

    func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = self.constraint(lessThanOrEqualTo: anchor)
        constraint.priority = priority
        return constraint
    }
}
