// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// swiftlint:disable nesting

// MARK: - SettingsView.AppearanceSection.AccentColorRow

extension SettingsView.AppearanceSection {
    struct AccentColorRow: View {
        // MARK: Internal

        // MARK: - ColorCircleView

        struct ColorCircleView: View {
            let color: Color
            let isSelected: Bool

            var body: some View {
                VStack {
                    Circle()
                        .fill(self.color)
                        .frame(width: 25)
                        .overlay(Circle().fill(self.isSelected ? .white : .clear).frame(width: 8))
                        .overlay(Circle().stroke(.gray, lineWidth: 0.5))
                }
                .animation(.easeIn, value: self.isSelected)
            }
        }

        @ObservedObject var styleManager: StyleManager = .shared

        var body: some View {
            HStack {
                Text(l10n.SettingsView.AppearanceSection.AccentColorRow.title)

                Spacer()

                ForEach(self.colors, id: \.self) { color in
                    ColorCircleView(color: color, isSelected: self.selectedColor == color)
                        .onTapGesture {
                            self.styleManager.accentColor = color
                        }
                }
            }
        }

        // MARK: Private

        private let colors: [Color] = [DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, .blue, .purple, .red, .orange, .yellow, .green, .gray]

        private var selectedColor: Color {
            self.styleManager.accentColor ?? .clear
        }
    }
}

// swiftlint:enable nesting

#Preview {
    Form {
        SettingsView.AppearanceSection.AccentColorRow()
    }
}
