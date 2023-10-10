// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

//
// MARK: - Public ButtonStyle extensions
//

public extension ButtonStyle where Self == RobotControlPlainButtonStyle {

    static func robotControlPlainButtonStyle(foreground: Color? = nil, background: Color? = nil) -> Self {
        .init(foreground: foreground, background: background)
    }

}

public extension ButtonStyle where Self == RobotControlBorderedButtonStyle {

    static func robotControlBorderedButtonStyle(foreground: Color? = nil, border: Color? = nil) -> Self {
        .init(foreground: foreground, border: border)
    }

}

//
// MARK: - ButtonStyle struct implementations
//

public struct RobotControlPlainButtonStyle: ButtonStyle {
    private let foreground: Color
    private let background: Color

    init(foreground: Color?, background: Color?) {
        self.foreground = foreground ?? .black
        self.background = background ?? .white
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            configuration.label
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 20)
        .foregroundColor(foreground)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

public struct RobotControlBorderedButtonStyle: ButtonStyle {
    private let foreground: Color
    private let border: Color

    init(foreground: Color?, border: Color?) {
        self.foreground = foreground ?? .accentColor
        self.border = border ?? .accentColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            configuration.label
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 20)
        .foregroundColor(foreground)
        .background(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(border, lineWidth: 2)
        )
        .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
