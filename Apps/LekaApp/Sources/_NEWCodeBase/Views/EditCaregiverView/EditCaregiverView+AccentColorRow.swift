// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// swiftlint:disable nesting

// MARK: - EditCaregiverView.AccentColorRow

extension EditCaregiverView {
    struct AccentColorRow: View {
        // MARK: Internal

        @Binding var caregiver: Caregiver_OLD

        var body: some View {
            HStack {
                Text(l10n.EditCaregiverView.AccentColorRow.title)

                Spacer()

                ForEach(self.colors, id: \.self) { color in
                    ColorCircleView(color: color, isSelected: self.selectedColor == color)
                        .onTapGesture {
                            self.styleManager.accentColor = color
                            self.caregiver.preferredAccentColor = color
                        }
                }
            }
        }

        // MARK: Private

        // MARK: - ColorCircleView

        private struct ColorCircleView: View {
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

        @ObservedObject private var styleManager: StyleManager = .shared

        private let colors: [Color] = [DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, .blue, .purple, .red, .orange, .yellow, .green, .gray]

        private var selectedColor: Color {
            self.styleManager.accentColor ?? .clear
        }
    }
}

// swiftlint:enable nesting

#Preview {
    Form {
        EditCaregiverView.AccentColorRow(caregiver: .constant(Caregiver_OLD()))
    }
}
