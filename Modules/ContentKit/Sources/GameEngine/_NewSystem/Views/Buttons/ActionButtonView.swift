// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - ActionButtonView

struct ActionButtonView: View {
    // MARK: Lifecycle

    init(action: NewExerciseAction) {
        self.action = action
    }

    // MARK: Internal

    var body: some View {
        switch self.action {
            case let .ipad(type):
                switch type {
                    case let .image(value),
                         let .sfsymbol(value):
                        ObserveButton(image: value)
                    case let .audio(value):
                        ListenButton(audio: .file(name: value))
                    case let .speech(value):
                        ListenButton(audio: .speech(text: value))
                    default:
                        EmptyView()
                }
            case let .robot(type):
                RobotButton(actionType: type)
        }
    }

    // MARK: Private

    private let action: NewExerciseAction
}

// MARK: ActionButtonView.Style

extension ActionButtonView {
    struct Style: ButtonStyle {
        var progress: CGFloat

        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .mask(Circle().inset(by: 4))
                .background(
                    Circle()
                        .fill(
                            Color.white, strokeBorder: DesignKitAsset.Colors.gameButtonBorder.swiftUIColor,
                            lineWidth: 4
                        )
                        .overlay(
                            Circle()
                                .trim(from: 0, to: self.progress)
                                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .animation(.easeOut(duration: 0.2), value: self.progress)
                        )
                )
                .contentShape(Circle())
        }
    }
}

#Preview {
    HStack {
        ActionButtonView(action: .ipad(type: .image("sport_dance_player_man")))
        ActionButtonView(action: .ipad(type: .sfsymbol("star")))
        ActionButtonView(action: .robot(type: .color("red")))
    }
}
