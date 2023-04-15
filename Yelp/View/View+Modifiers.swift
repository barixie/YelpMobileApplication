//
//  View+Modifiers.swift
//  Yelp
//
//  Created by bari on 11/19/22.
//

import SwiftUI

extension View {
    public func alwaysPopover<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.modifier(AlwaysPopoverModifier(isPresented: isPresented, contentBlock: content))
    }
}
