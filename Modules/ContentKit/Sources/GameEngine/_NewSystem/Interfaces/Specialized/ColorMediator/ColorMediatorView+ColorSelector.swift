// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

public extension ColorMediatorView {
    struct ColorSelector: View {
        // MARK: Public

        @Environment(\.dismiss) var dismiss

        private let colors: [Robot.Color] = [.red, .blue, .green, .yellow, .orange, .pink]
        private let buttonSize: CGFloat = 140

        @ObservedObject private var styleManager: StyleManager = .shared
        @State var selectedColors: [Robot.Color]
        var onSelected: ([Robot.Color]) -> Void

        public var body: some View {
            NavigationStack {
                VStack(spacing: 20) {
                    Text(l10n.ColorMediatorView.ColorSelector.instruction)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .padding()

                    Spacer()

                    HStack(spacing: 20) {
                        ForEach(self.colors.prefix(3), id: \.screen) { color in
                            self.colorButton(for: color)
                        }
                    }

                    HStack(spacing: 20) {
                        ForEach(self.colors.suffix(from: 3), id: \.screen) { color in
                            self.colorButton(for: color)
                        }
                    }

                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            self.dismiss()
                        } label: {
                            Text(l10n.ColorMediatorView.ColorSelector.closeLabel)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            self.onSelected(self.selectedColors)
                            self.dismiss()
                        } label: {
                            Text(l10n.ColorMediatorView.ColorSelector.selectLabel)
                        }
                        .disabled(self.selectedColors.isEmpty)
                    }
                }
            }
        }

        private func colorButton(for color: Robot.Color) -> some View {
            let isSelected = self.selectedColors.contains(where: { $0.screen == color.screen })
            let index = self.selectedColors.firstIndex(where: { $0.screen == color.screen })

            return ZStack(alignment: .topTrailing) {
                ColorLekaButtonLabel(color: color,
                                     isPressed: isSelected,
                                     size: self.buttonSize)
                    .onTapGesture { self.toggleSelection(of: color) }
                    .accessibilityLabel("\(color.screen) color button")

                if let index {
                    withAnimation {
                        self.badge(for: index)
                    }
                }
            }
        }

        private func toggleSelection(of color: Robot.Color) {
            if let index = selectedColors.firstIndex(where: { $0.screen == color.screen }) {
                self.selectedColors.remove(at: index)
            } else {
                self.selectedColors.append(color)
            }
        }

        private func badge(for index: Int) -> some View {
            Text("\(index + 1)")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(10)
                .background(Circle().fill(self.styleManager.accentColor!))
                .frame(width: self.buttonSize * 0.3, height: self.buttonSize * 0.3)
                .offset(x: 10, y: 0)
        }
    }
}

#Preview {
    ColorMediatorView.ColorSelector(selectedColors: [.red, .blue], onSelected: { colors in print("\(colors) selected") })
}
