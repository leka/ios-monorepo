//
//  Extensions.swift
//  Leka Emotion
//
//  Created by Mathieu Jeannot on 14/6/22.
//

import Foundation
import AVFoundation
import SwiftUI

// MARK: - Fill & Stroke with 1 modifier
extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: CGFloat = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

// MARK: - Localized Custom Type for Yaml Translations
// return "en" if Locale != "fr"
extension LocalizedContent {
    func localized() -> String {
		guard let translation = (Locale.current.language.languageCode?.identifier == "fr" ? self.frFR : self.enUS) else {
            print("Nothing to display")
            return ""
        }
        return translation
    }
}
