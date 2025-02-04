//
//  HideViewModifier.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-03.
//

import SwiftUI

struct HideViewModifier: ViewModifier {
    let isHidden: Bool

    @ViewBuilder func body(content: Content) -> some View {
        if isHidden {
            EmptyView()
        }
        else {
            content
        }
    }
}

// Extending on View to apply to all Views
extension View {
    func hide(if isHiddden: Bool) -> some View {
        ModifiedContent(
            content: self,
            modifier: HideViewModifier(isHidden: isHiddden)
        )
    }
}
