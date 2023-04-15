//
//  View+Toast.swift
//  Yelp
//
//  Created by bari on 11/20/22.
//

import Foundation
import SwiftUI

extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}
