//
//  GLT_Styles.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/3/23.
//

import Foundation
import SwiftUI

// MARK: - Step Instructions Button Style
struct StepInstructions_ButtonStyle: ButtonStyle {
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(spacing: 0) {
            Spacer()
            configuration.label
                .foregroundColor(Color("darkGray"))
                .font(defaults.fontStepInstructionBtn)
                .multilineTextAlignment(.center)
                .padding(.horizontal, defaults.frameStepInstructionBtn.height)
            Spacer()
        }
        .frame(maxWidth: defaults.frameStepInstructionBtn.width)
        .frame(height: defaults.frameStepInstructionBtn.height, alignment: .center)
        .background(backgroundGradient)
        .overlay(buttonStroke)
        .overlay(speachIndicator)
        .clipShape(RoundedRectangle(cornerRadius: defaults.roundedCorner, style: .circular))
        .shadow(
            color: .black.opacity(0.1),
            radius: gameEngine.isSpeaking ? 0 : 4, x: 0, y: gameEngine.isSpeaking ? 1 : 4
        )
        .scaleEffect(gameEngine.isSpeaking ? 0.98 : 1)
        .disabled(gameEngine.isSpeaking)
        .animation(.easeOut(duration: 0.2), value: gameEngine.isSpeaking)
    }

    private var backgroundGradient: some View {
        ZStack {
            Color.white
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.0), .black.opacity(0.0)]),
                startPoint: .top, endPoint: .center
            )
            .opacity(gameEngine.isSpeaking ? 1 : 0)
        }
    }

    private var buttonStroke: some View {
        RoundedRectangle(cornerRadius: defaults.roundedCorner, style: .circular)
            .fill(
                .clear,
                strokeBorder: LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.2), .black.opacity(0.05)]),
                    startPoint: .bottom, endPoint: .top), lineWidth: 4
            )
            .opacity(gameEngine.isSpeaking ? 0.5 : 0)
    }

    private var speachIndicator: some View {
        HStack {
            Spacer()
            Image("person.wave.2")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(gameEngine.isSpeaking ? .accentColor : Color("progressBar"))
                .padding(10)
        }
    }
}

// MARK: - Circular Answer Buttons Style (Gameplay)
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

// MARK: - Template Previews
struct TemplatePreview_ButtonStyle: ButtonStyle {
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    var isSelected: Bool
    var name: String
    func makeBody(configuration: Self.Configuration) -> some View {
        VStack(spacing: 0) {
            configuration.label
                .clipShape(RoundedRectangle(cornerRadius: defaults.roundedCorner, style: .circular))
                .overlay(
                    RoundedRectangle(cornerRadius: defaults.roundedCorner, style: .circular)
                        .stroke(
                            isSelected ? Color.accentColor : .gray.opacity(0.1),
                            lineWidth: isSelected ? 2 : 1)
                )
                .shadow(
                    color: .black.opacity(0.1),
                    radius: configuration.isPressed ? 0 : 4, x: 0, y: configuration.isPressed ? 1 : 4
                )
                .scaleEffect((configuration.isPressed ? 0.98 : 1))

            HStack(spacing: 6) {
                Image(systemName: isSelected ? "checkmark.circle" : "circle")
                    .foregroundColor(isSelected ? .white : .accentColor)
                    .background(
                        Circle()
                            .inset(by: 2)
                            .fill(Color.accentColor)
                            .opacity(isSelected ? 1 : 0)
                            .scaleEffect(isSelected ? 1 : 0.1, anchor: .center)
                    )
                    .scaleEffect(isSelected ? 1.2 : 1, anchor: .center)
                    .frame(width: 20, height: 20)
                Text(name)
                    .font(defaults.reg17)
                    .foregroundColor(.accentColor)
            }
            .padding(.vertical, 12)
        }
    }
}
