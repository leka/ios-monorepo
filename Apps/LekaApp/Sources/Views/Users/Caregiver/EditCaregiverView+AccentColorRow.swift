// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// swiftlint:disable nesting

// MARK: - EditCaregiverView.AccentColorRow

extension EditCaregiverView {
    struct AccentColorRow: View {
        // MARK: Internal

        var styleManager: StyleManager = .shared
        @Binding var caregiver: Caregiver

        var body: some View {
            HStack {
                Text(l10n.EditCaregiverView.AccentColorRow.title)

                Spacer()

                ForEach(ColorTheme.allCases, id: \.self) { color in
                    ColorCircleView(color: color.color, isSelected: self.selectedColor == color.color)
                        .onTapGesture {
                            self.styleManager.setAccentColor(color.color)
                            self.caregiver.colorTheme = color
                        }
                }
            }
        }

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

        private var selectedColor: Color {
            self.styleManager.accentColor ?? .clear
        }
    }
}

// swiftlint:enable nesting

#Preview {
    Form {
        EditCaregiverView.AccentColorRow(caregiver: .constant(Caregiver()))
    }
}
