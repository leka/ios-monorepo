// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Foundation
import SwiftUI

// MARK: - NoFeedback_ButtonStyleDeprecated

struct NoFeedback_ButtonStyleDeprecated: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

// MARK: - BorderedCapsule_NoFeedback_ButtonStyleDeprecated

struct BorderedCapsule_NoFeedback_ButtonStyleDeprecated: ButtonStyle {
    var font: Font
    var color: Color
    var isOpaque: Bool = false
    var width: CGFloat = 280

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(self.font)
            .foregroundColor(self.color)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(width: self.width)
            .overlay(
                Capsule()
                    .stroke(self.color, lineWidth: 1)
            )
            .background(self.isOpaque ? .white : .clear, in: Capsule())
            .contentShape(Capsule())
    }
}

// MARK: - CircledIcon_NoFeedback_ButtonStyleDeprecated

struct CircledIcon_NoFeedback_ButtonStyleDeprecated: ButtonStyle {
    var font: Font

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(self.font)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
            .frame(width: 46, height: 46)
            .overlay(
                Circle()
                    .stroke(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, lineWidth: 1)
            )
            .contentShape(Circle())
    }
}

// MARK: - Connect_ButtonStyleDeprecated

struct Connect_ButtonStyleDeprecated: ButtonStyle {
    @EnvironmentObject var metrics: UIMetrics
    var reversed: Bool = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.body)
            .frame(width: 310, height: 60)
            .foregroundColor(self.reversed ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .white)
            .background(self.reversed ? .white : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, in: Capsule())
            .contentShape(Capsule())
            .opacity(configuration.isPressed ? 0.4 : 1)
            .compositingGroup()
            .animation(.easeIn(duration: 0.05), value: configuration.isPressed)
    }
}

// MARK: - JobPickerToggleStyleDeprecated

struct JobPickerToggleStyleDeprecated: ToggleStyle {
    @EnvironmentObject var metrics: UIMetrics
    var onImage = "checkmark.circle"
    var offImage = "circle"
    var action: () -> Void

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 10) {
            Image(systemName: configuration.isOn ? self.onImage : self.offImage)
                .foregroundColor(configuration.isOn ? .white : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .background(
                    Circle()
                        .inset(by: 2)
                        .fill(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                        .opacity(configuration.isOn ? 1 : 0)
                        .scaleEffect(configuration.isOn ? 1 : 0.1, anchor: .center)
                )
                .scaleEffect(configuration.isOn ? 1.2 : 1, anchor: .center)
                .frame(width: 18, height: 18)

            configuration.label
                .multilineTextAlignment(.leading)
                .font(.body)

            Spacer()
        }
        .frame(width: 200)
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.2)) {
                configuration.isOn.toggle()
                self.action()
            }
        }
    }
}

// MARK: - SuccessGaugeStyleDeprecated

struct SuccessGaugeStyleDeprecated: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        let color: Color = if configuration.value < 0.25 {
            .red
        } else if 0.25..<0.5 ~= configuration.value {
            .orange
        } else if 0.5..<0.8 ~= configuration.value {
            .yellow
        } else {
            .green
        }

        ZStack {
            Circle()
                .stroke(color.opacity(0.4), lineWidth: 6)
                .frame(maxWidth: 54)
            Circle()
                .trim(from: 0, to: CGFloat(configuration.value))
                .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(maxHeight: 54)
                .rotationEffect(Angle(degrees: -90))
            Text("\(Int(configuration.value * 100))%")
        }
    }
}

// MARK: - ActivityAnswer_ButtonStyleDeprecated

struct ActivityAnswer_ButtonStyleDeprecated: ButtonStyle {
    var isEnabled: Bool = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1, anchor: .center)
            .mask(Circle().inset(by: 4))
            .background(
                Circle()
                    .fillDeprecated(
                        DesignKitAsset.Colors.gameButtonBorder.swiftUIColor,
                        strokeBorder: DesignKitAsset.Colors.gameButtonBorder.swiftUIColor,
                        lineWidth: 4
                    )
            )
            .overlay(
                Circle()
                    .fill(self.isEnabled ? .clear : .white.opacity(0.6))
            )
            .contentShape(Circle())
            .animation(.easeOut(duration: 0.3), value: self.isEnabled)
    }
}

// MARK: - PlaySound_ButtonStyleDeprecated

struct PlaySound_ButtonStyleDeprecated: ButtonStyle {
    var progress: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .mask(Circle().inset(by: 4))
            .background(
                Circle()
                    .fillDeprecated(
                        Color.white,
                        strokeBorder: DesignKitAsset.Colors.gameButtonBorder.swiftUIColor,
                        lineWidth: 4
                    )
                    .overlay(
                        Circle()
                            .trim(from: 0, to: self.progress)
                            .stroke(
                                DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 0.2), value: self.progress)
                    )
            )
            .contentShape(Circle())
    }
}

// MARK: - BorderedCapsule_ButtonStyleDeprecated

struct BorderedCapsule_ButtonStyleDeprecated: ButtonStyle {
    var isFilled: Bool = true

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(!self.isFilled ? DesignKitAsset.Colors.bravoHighlights.swiftUIColor : .white)
            .opacity(configuration.isPressed ? 0.95 : 1)
            .scaleEffect(configuration.isPressed ? 0.99 : 1, anchor: .center)
            .padding()
            .frame(width: 250)
            .background(
                Capsule()
                    .fillDeprecated(
                        self.isFilled ? DesignKitAsset.Colors.bravoHighlights.swiftUIColor : .white,
                        strokeBorder: DesignKitAsset.Colors.bravoHighlights.swiftUIColor,
                        lineWidth: 1
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2.3, x: 0, y: 1.8)
            )
    }
}