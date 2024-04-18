// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import SwiftUI

// MARK: - PlayZoneDeprecated

struct PlayZoneDeprecated: View {
    // MARK: Internal

    @ObservedObject var gameMetrics: GameMetrics
    @EnvironmentObject var activityVM: ActivityViewModelDeprecated

    var body: some View {
        HStack {
            Spacer()
            LazyVGrid(columns: self.columns, spacing: self.gameMetrics.playGridRowSpacing) {
                ForEach(0..<self.activityVM.currentActivity.numberOfImages, id: \.self) { answer in
                    Button {
                        self.activityVM.answerHasBeenPressed(atIndex: answer)
                    } label: {
                        Image(self.activityVM.images[answer])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle().inset(by: 2))
                            .frame(
                                width: self.gameMetrics.playGridBtnSize,
                                height: self.gameMetrics.playGridBtnSize,
                                alignment: .center
                            )
                    }
                    .buttonStyle(ActivityAnswer_ButtonStyleDeprecated(isEnabled: self.activityVM.currentMediaHasBeenPlayedOnce))
                    .animation(.easeIn(duration: self.gameMetrics.playGridBtnAnimDuration), value: self.activityVM.percent)
                    .overlay(
                        ZStack {
                            if answer == self.activityVM.correctIndex {
                                Circle()
                                    .trim(from: 0, to: self.activityVM.percent)
                                    .stroke(
                                        .green,
                                        style: StrokeStyle(
                                            lineWidth: self.gameMetrics.playGridBtnTrimLineWidth,
                                            lineCap: .round,
                                            lineJoin: .round,
                                            miterLimit: 10
                                        )
                                    )
                            } else if answer == self.activityVM.pressedIndex {
                                Circle()
                                    .fill(.gray)
                                    .opacity(self.activityVM.overlayOpacity)
                            } else {
                                EmptyView()
                            }
                        }
                    )
                    .disabled(self.activityVM.tapIsDisabled)
                    .disabled(self.activityVM.answersAreDisabled)
                }
            }
            Spacer()
        }
        .background(
            HStack {
                if self.activityVM.currentActivityType != "touch_to_select" {
                    PlaySoundButtonDeprecated()
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
        let number = self.activityVM.currentActivity.numberOfImages
        if number % 3 == 0 {
            guard self.activityVM.currentActivityType != "touch_to_select" else {
                return [
                    GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                ]
            }
            return [
                GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
            ]
        } else if number == 2 {
            return [
                GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
            ]
        } else if number == 4 {
            guard self.activityVM.currentActivityType != "touch_to_select" else {
                return [
                    GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                    GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                ]
            }
            return [
                GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
                GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center),
            ]
        } else {
            return [GridItem(.fixed(self.gameMetrics.playGridBtnCellSize), alignment: .center)]
        }
    }
}

// MARK: - PlayZone_Previews

struct PlayZone_Previews: PreviewProvider {
    static var previews: some View {
        PlayZoneDeprecated(gameMetrics: GameMetrics())
            .environmentObject(ActivityViewModelDeprecated())
            .environmentObject(GameMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
