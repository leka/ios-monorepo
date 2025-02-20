// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

public struct ColorCoachView: View {
    // MARK: Public

    public var body: some View {
        VStack(spacing: 30) {
            Text(l10n.ColorCoachView.instructions)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .padding()

            HStack(spacing: 200) {
                VStack(spacing: 50) {
                    if self.isPlaying {
                        ActionButton(.next, text: String(l10n.ColorCoachView.nextButtonLabel.characters)) {
                            self.stopTimer()
                            self.resetTimer()
                            Robot.shared.blacken(.all)
                            self.currentColorIndex = self.currentColorIndex >= self.selectedColors.count - 1 ? 0 : self.currentColorIndex + 1
                            withAnimation {
                                self.currentColor = self.selectedColors[self.currentColorIndex]
                            }
                            self.startTimer()
                        }
                    } else {
                        ActionButton(.start, text: String(l10n.ColorCoachView.playButtonLabel.characters)) {
                            Robot.shared.blacken(.all)
                            withAnimation {
                                self.currentColor = self.selectedColors[self.currentColorIndex]
                            }
                            self.startTimer()
                            self.isPlaying = true
                        }
                    }

                    ActionButton(.stop, text: String(l10n.ColorCoachView.stopButtonLabel.characters), isPlaying: self.isPlaying) {
                        self.resetGame()
                    }
                    .disabled(!self.isPlaying)
                }

                VStack {
                    HStack(spacing: 30) {
                        self.colorSelectorButton
                        ColorBar(colors: self.selectedColors, size: 30)
                        self.shuffleButton
                    }
                    .padding(.bottom, 20)

                    ZStack {
                        self.currentColor.screen
                            .frame(width: 300, height: 300)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                            .shadow(color: self.currentColor.screen, radius: self.remainingTime == 0 ? 20 : 0)
                            .animation(.easeIn(duration: 0.2), value: self.remainingTime == 0)

                        Text("\(self.remainingTime)")
                            .font(.largeTitle.weight(.bold))
                    }

                    Text(l10n.ColorCoachView.robotColorLabel)
                        .foregroundStyle(.secondary)
                }
                .frame(width: 400)
            }

            ReinforcerBarButton()
        }
        .onAppear {
            self.isColorSelectorPresented = true
        }
        .sheet(isPresented: self.$isColorSelectorPresented) {
            ColorSelector(selectedColors: self.selectedColors, onSelected: { colors in self.selectedColors = colors })
        }
        .padding()
    }

    // MARK: Internal

    private var colorSelectorButton: some View {
        Button {
            self.isColorSelectorPresented = true
        } label: {
            Image(systemName: "paintpalette.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(.primary)
                .padding()
                .background(self.backgroundColor)
                .clipShape(Circle())
                .shadow(radius: 1)
        }
    }

    private var shuffleButton: some View {
        Button {
            self.selectedColors.shuffle()
            self.resetGame()
        } label: {
            Image(systemName: "shuffle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(.primary)
                .padding()
                .background(self.backgroundColor)
                .clipShape(Circle())
                .shadow(radius: 1)
        }
    }

    private func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stopTimer()
                Robot.shared.shine(.all(in: self.currentColor))
            }
        }
    }

    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    private func resetTimer() {
        self.remainingTime = 5
    }

    private func resetGame() {
        Robot.shared.blacken(.all)
        self.stopTimer()
        self.resetTimer()
        self.isPlaying = false
        self.currentColorIndex = 0
        self.currentColor = .white
    }

    // MARK: Private

    @State private var isColorSelectorPresented: Bool = false
    @State private var selectedColors: [Robot.Color] = []
    @State private var currentColor: Robot.Color = .white
    @State private var currentColorIndex: Int = 0
    @State private var remainingTime: Int = 5

    @State private var isPlaying: Bool = false
    @State var timer: Timer?

    private let backgroundColor: Color = .init(light: UIColor.white, dark: UIColor.systemGray5)
}

#Preview {
    ColorCoachView()
}
