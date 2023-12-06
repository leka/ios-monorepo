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

// MARK: - RobotControlPlainButtonStyle

//

//

public struct RobotControlPlainButtonStyle: ButtonStyle {
    // MARK: Lifecycle

    init(foreground: Color?, background: Color?) {
        self.foreground = foreground ?? .black
        self.background = background ?? .white
    }

    // MARK: Public

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

    // MARK: Private

    private let foreground: Color
    private let background: Color
}

// MARK: - RobotControlBorderedButtonStyle

public struct RobotControlBorderedButtonStyle: ButtonStyle {
    // MARK: Lifecycle

    init(foreground: Color?, border: Color?, background: Color? = nil) {
        self.foreground = foreground ?? .accentColor
        self.border = border ?? .accentColor
        self.background = background ?? .clear
    }

    // MARK: Public

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            configuration.label
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 20)
        .foregroundColor(foreground)
        .background(background)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(border, lineWidth: 2)
        )
        .opacity(configuration.isPressed ? 0.8 : 1)
    }

    // MARK: Private

    private let foreground: Color
    private let border: Color
    private let background: Color
}
