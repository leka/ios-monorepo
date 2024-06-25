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

        @Binding var caregiver: Caregiver

        var body: some View {
            HStack {
                Text(l10n.EditCaregiverView.AccentColorRow.title)

                Spacer()

                ForEach(ColorTheme.allCases, id: \.self) { color in
                    ColorCircleView(color: color.color, isSelected: self.selectedColor == color.color)
                        .onTapGesture {
                            self.styleManager.accentColor = color.color
                            self.caregiver.colorTheme = color
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
                // TODO: (@team) - Move to iOS17 support - Remove useless VStack below
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
