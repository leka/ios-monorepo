// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct EndOfRoundView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    // animation-related values
    @State private var textOffset: CGFloat = -100
    @State private var textOpacity: Double = 0
    @State private var offsetGameOverBtn: CGFloat = -700
    @State private var offsetReplayBtn: CGFloat = 700

    var body: some View {
        ZStack {
            LottieView(
                name: gameEngine.percentOfSuccess >= 80 ? "bravo" : "tryAgain", play: $gameEngine.showEndAnimation
            )
            .onAppear {
                // Delayed to avoid artifacts on animation... SwiftUI bug
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    textOffset = 0
                    textOpacity = 1
                    offsetGameOverBtn = 0
                    offsetReplayBtn = 0
                }
            }

            VStack(spacing: 0) {
                resultMessage(result: gameEngine.result)
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            // gameEngine.resetActivity()
                            // within LekaApp, use above instead
                            gameEngine.replayCurrentActivity()
                        }
                    } label: {
                        Text("gameOver_button")
                    }
                    .buttonStyle(BorderedCapsule_ButtonStyle(isFilled: false))
                    .offset(x: offsetGameOverBtn)
                    .animation(
                        .easeOut(duration: defaults.endAnimBtnDuration).delay(defaults.endAnimGameOverBtnDelay),
                        value: offsetGameOverBtn)
                    Spacer()
                    Button {
                        gameEngine.replayCurrentActivity()
                        textOffset = -100
                        textOpacity = 0
                    } label: {
                        Text("replay_button")
                    }
                    .buttonStyle(BorderedCapsule_ButtonStyle())
                    .offset(x: offsetReplayBtn)
                    .animation(
                        .easeOut(duration: defaults.endAnimBtnDuration).delay(defaults.endAnimReplayBtnDelay),
                        value: offsetReplayBtn)
                    Spacer()
                }
            }
            .padding(.vertical, defaults.endAnimBtnPadding)
        }
    }

    // Result Texts
    private func makeTopMessage(result: ResultType) -> Text {
        switch result {
            case .fail:
                return Text("fail_top_message")
            case .medium:
                return Text("medium_top_message")
            case .success:
                return Text("success_top_message")
            default:
                return Text("")
        }
    }

    private func makeBottomMessage(result: ResultType) -> Text {
        switch result {
            case .fail:
                return Text("fail_bottom_message")
                    + Text("(0%)")
                    .foregroundColor(DesignKitAsset.Colors.bravoHighlights.swiftUIColor)
                    + Text(".")
            case .medium, .success:
                return Text("success_bottom_message")
                    + Text(
                        "success_bottom_result \(gameEngine.goodAnswers) \(gameEngine.currentActivity.stepsAmount) \(gameEngine.percentOfSuccess)"
                    )
                    .foregroundColor(DesignKitAsset.Colors.bravoHighlights.swiftUIColor)
                    + Text("!")
            default:
                return Text("")
        }
    }

    @ViewBuilder
    func resultMessage(result: ResultType) -> some View {
        VStack(spacing: defaults.endAnimTextsSpacing) {
            Group {
                makeTopMessage(result: result)
                    .foregroundColor(.accentColor)
                    .offset(y: textOffset)
                    .opacity(textOpacity)
                    .animation(
                        .easeOut(duration: defaults.endAnimDuration).delay(defaults.endAnimDelayTop),
                        value: textOffset
                    )
                    .animation(
                        .easeOut(duration: defaults.endAnimDuration).delay(defaults.endAnimDelayTop),
                        value: textOpacity
                    )
                makeBottomMessage(result: result)
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                    .offset(y: textOffset)
                    .opacity(textOpacity)
                    .animation(
                        .easeOut(duration: defaults.endAnimDuration).delay(defaults.endAnimDelayBottom),
                        value: textOffset
                    )
                    .animation(
                        .easeOut(duration: defaults.endAnimDuration).delay(defaults.endAnimDelayBottom),
                        value: textOpacity
                    )
            }
            .font(
                .system(
                    size: defaults.endAnimFontSize,
                    weight: defaults.endAnimFontWeight,
                    design: defaults.endAnimFontDesign
                )
            )
        }
    }
}
