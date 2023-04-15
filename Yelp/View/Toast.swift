//
//  Toast.swift
//  Yelp
//
//  Created by bari on 11/20/22.
//

import Foundation
import SwiftUI

struct Toast<Presenting, Content>: View where Presenting: View, Content: View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 2

    var body: some View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()

                ZStack {
                    Capsule()
                        .fill(Color(red: 211/255, green: 211/255, blue: 211/255))

                    self.content()
                } //ZStack (inner)
                .frame(width: geometry.size.width / 1.25, height: geometry.size.height / 10)
                .opacity(self.isPresented ? 0.7 : 0)
            } //ZStack (outer)
            .padding(.bottom)
        } //GeometryReader
    } //body
} //Toast

//from https://stackoverflow.com/questions/56550135/swiftui-global-overlay-that-can-be-triggered-from-any-view
