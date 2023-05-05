// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import Foundation
import SwiftUI

// MARK: - Shape
// Fill & Stroke with 1 modifier
extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1
    ) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

// MARK: - String
// Check if email format id correct
extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

// MARK: - Image
// Used for Activities Icons && Commands/Stories buttons
extension Image {
    func activityIconImageModifier(diameter: CGFloat = 132, padding: CGFloat = 0) -> some View {
        ZStack {
            Circle()
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 2.5, x: 0, y: 2.6)
            self
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: diameter, maxHeight: diameter)
                .mask(Circle())
                .padding(padding)
            Circle()
                .strokeBorder(Color("btnLightBlue"), lineWidth: 4)
        }
        .frame(minWidth: diameter, maxWidth: diameter)
    }
}

// MARK: - dismiss Keyboard when focusState not available
#if canImport(UIKit)
    extension View {
        func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
#endif
