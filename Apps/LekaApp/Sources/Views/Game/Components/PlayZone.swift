// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import SwiftUI

// MARK: - PlayZone

struct PlayZone: View {
    // MARK: Internal

    @ObservedObject var gameMetrics: GameMetrics
    @EnvironmentObject var activityVM: ActivityViewModel

    var body: some View {
        HStack {
            Spacer()
            LazyVGrid(columns: columns, spacing: gameMetrics.playGridRowSpacing) {
                ForEach(0..<activityVM.currentActivity.numberOfImages, id: \.self) { answer in
                    Button {
                        activityVM.answerHasBeenPressed(atIndex: answer)
                    } label: {
                        Image(activityVM.images[answer])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle().inset(by: 2))
                            .frame(
                                width: gameMetrics.playGridBtnSize,
                                height: gameMetrics.playGridBtnSize,
                                alignment: .center)
                    }
                    .buttonStyle(ActivityAnswer_ButtonStyle(isEnabled: activityVM.currentMediaHasBeenPlayedOnce))
                    .animation(.easeIn(duration: gameMetrics.playGridBtnAnimDuration), value: activityVM.percent)
                    .overlay(
                        ZStack {
                            if answer == activityVM.correctIndex {
                                Circle()
                                    .trim(from: 0, to: activityVM.percent)
                                    .stroke(
                                        .green,
                                        style: StrokeStyle(
                                            lineWidth: gameMetrics.playGridBtnTrimLineWidth,
                                            lineCap: .round,
                                            lineJoin: .round,
                                            miterLimit: 10))
                            } else if answer == activityVM.pressedIndex {
                                Circle()
                                    .fill(.gray)
                                    .opacity(activityVM.overlayOpacity)
                            } else {
                                EmptyView()
                            }
                        }
                    )
                    .disabled(activityVM.tapIsDisabled)
                    .disabled(activityVM.answersAreDisabled)
                }
            }
            Spacer()
        }
        .background(
            HStack {
                if activityVM.currentActivityType != "touch_to_select" {
                    PlaySoundButton()
                        .padding(.leading, 50)
                    Spacer()
                } else {
                    EmptyView()
                }
            }
        )
    }

    // MARK: Private

    // Grid configuration
    private var columns: [GridItem] {
        let number = activityVM.currentActivity.numberOfImages
        if number % 3 == 0 {
            guard activityVM.currentActivityType != "touch_to_select" else {
                return [
                    GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                ]
            }
            return [
                GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
            ]
        } else if number == 2 {
            return [
                GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
            ]
        } else if number == 4 {
            guard activityVM.currentActivityType != "touch_to_select" else {
                return [
                    GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                ]
            }
            return [
                GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
                GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center),
            ]
        } else {
            return [GridItem(.fixed(gameMetrics.playGridBtnCellSize), alignment: .center)]
        }
    }
}

// MARK: - PlayZone_Previews

struct PlayZone_Previews: PreviewProvider {
    static var previews: some View {
        PlayZone(gameMetrics: GameMetrics())
            .environmentObject(ActivityViewModel())
            .environmentObject(GameMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
