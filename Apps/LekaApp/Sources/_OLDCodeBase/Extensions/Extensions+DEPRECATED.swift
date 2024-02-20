// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import DesignKit
import Foundation
import SwiftUI

// MARK: - Shape

// Fill & Stroke with 1 modifier
extension Shape {
    func fillDeprecated(
        _ fillStyle: some ShapeStyle, strokeBorder strokeStyle: some ShapeStyle, lineWidth: CGFloat = 1
    ) -> some View {
        stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

// MARK: - String

// Check if email format is correct
extension String {
    func isValidEmailDeprecated() -> Bool {
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
                .strokeBorder(DesignKitAsset.Colors.btnLightBlue.swiftUIColor, lineWidth: 4)
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

// MARK: - Localized Custom Type for Yaml Translations

extension LocalizedContent {
    func localized() -> String {
        guard let translation = (Locale.current.language.languageCode?.identifier == "fr" ? frFR : enUS)
        else {
            print("Nothing to display")
            return ""
        }
        return translation
    }
}

// MARK: - ActivityViewModelDeprecated + AVSpeechSynthesizerDelegate

extension ActivityViewModelDeprecated: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) {
        isSpeaking = false
    }
}

// MARK: - ActivityViewModelDeprecated + AVAudioPlayerDelegate

extension ActivityViewModelDeprecated: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        currentMediaHasBeenPlayedOnce = true
        answersAreDisabled = false
    }
}