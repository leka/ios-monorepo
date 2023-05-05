// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

// MARK: - Bot (bot connection) Button Style
struct NoFeedback_ButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

// MARK: - Edit Button Style -> avatar picker, profile editor, explorer mode tile
struct BorderedCapsule_NoFeedback_ButtonStyle: ButtonStyle {

    var font: Font
    var color: Color
    var isOpaque: Bool = false
    var width: CGFloat = 280

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(font)
            .foregroundColor(color)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(width: width)
            .overlay(
                Capsule()
                    .stroke(color, lineWidth: 1)
            )
            .background(isOpaque ? .white : .clear, in: Capsule())
            .contentShape(Capsule())
    }
}

struct CircledIcon_NoFeedback_ButtonStyle: ButtonStyle {

    var font: Font

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(font)
            .foregroundColor(Color.accentColor)
            .frame(width: 46, height: 46)
            .overlay(
                Circle()
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .contentShape(Circle())
    }
}

// MARK: - Login/Signup Button Style
struct Connect_ButtonStyle: ButtonStyle {
    @EnvironmentObject var metrics: UIMetrics
    var reversed: Bool = false
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(metrics.bold15)
            .frame(width: 310, height: 60)
            .foregroundColor(reversed ? .accentColor : .white)
            .background(reversed ? .white : .accentColor, in: Capsule())
            .contentShape(Capsule())
            .opacity(configuration.isPressed ? 0.4 : 1)
            .compositingGroup()
            .animation(.easeIn(duration: 0.05), value: configuration.isPressed)
    }
}

// MARK: - Job Picker Toggle Style
struct JobPickerToggleStyle: ToggleStyle {
    @EnvironmentObject var metrics: UIMetrics
    var onImage = "checkmark.circle"
    var offImage = "circle"
    var action: () -> Void
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 10) {
            Image(systemName: configuration.isOn ? onImage : offImage)
                .foregroundColor(configuration.isOn ? .white : .accentColor)
                .background(
                    Circle()
                        .inset(by: 2)
                        .fill(Color.accentColor)
                        .opacity(configuration.isOn ? 1 : 0)
                        .scaleEffect(configuration.isOn ? 1 : 0.1, anchor: .center)
                )
                .scaleEffect(configuration.isOn ? 1.2 : 1, anchor: .center)
                .frame(width: 18, height: 18)

            configuration.label
                .multilineTextAlignment(.leading)
                .font(metrics.reg16)
                .foregroundColor(.accentColor)

            Spacer()
        }
        .frame(width: 200)
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.2)) {
                configuration.isOn.toggle()
                action()
            }
        }
    }
}

// MARK: - Custom Gauge Style (FollowUp stats)
struct SuccessGaugeStyle: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        let color: Color = {
            if configuration.value < 0.25 {
                return .red
            } else if 0.25..<0.5 ~= configuration.value {
                return .orange
            } else if 0.5..<0.8 ~= configuration.value {
                return .yellow
            } else {
                return .green
            }
        }()

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

// MARK: - Emotion Buttons Style (Gameplay)
struct ActivityAnswer_ButtonStyle: ButtonStyle {

    var isEnabled: Bool = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1, anchor: .center)
            .mask(Circle().inset(by: 4))
            .background(
                Circle()
                    .fill(Color("gameButtonBorder"), strokeBorder: Color("gameButtonBorder"), lineWidth: 4)
            )
            .overlay(
                Circle()
                    .fill(isEnabled ? .clear : .white.opacity(0.6))
            )
            .contentShape(Circle())
            .animation(.easeOut(duration: 0.3), value: isEnabled)
    }
}

// MARK: - Play Sound Button Style (Gameplay)
struct PlaySound_ButtonStyle: ButtonStyle {

    var progress: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .mask(Circle().inset(by: 4))
            .background(
                Circle()
                    .fill(Color.white, strokeBorder: Color("gameButtonBorder"), lineWidth: 4)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 0.2), value: progress)
                    )
            )
            .contentShape(Circle())
    }
}

// MARK: - CheerScreen Buttons
struct BorderedCapsule_ButtonStyle: ButtonStyle {

    var isFilled: Bool = true

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 22, weight: .black, design: .rounded))
            .foregroundColor(!isFilled ? Color("bravoHighlights") : .white)
            .opacity(configuration.isPressed ? 0.95 : 1)
            .scaleEffect(configuration.isPressed ? 0.99 : 1, anchor: .center)
            .padding()
            .frame(width: 250)
            .background(
                Capsule()
                    .fill(
                        isFilled ? Color("bravoHighlights") : .white,
                        strokeBorder: (Color("bravoHighlights")),
                        lineWidth: 1
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2.3, x: 0, y: 1.8)
            )
    }
}
