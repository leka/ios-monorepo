// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

public struct ColorMediatorView: View {
    // MARK: Public

    public var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 60) {
                self.colorSelectorButton
                ColorBar(colors: self.isShuffleModeActivated ? self.shuffledSelectedColors : self.selectedColors, size: 30)
                self.shuffleButton
            }

            Spacer()
            HStack(spacing: 300) {
                VStack(spacing: 20) {
                    if self.isPlaying {
                        ActionButton(.next, text: String(l10n.ColorMediatorView.nextButtonLabel.characters)) {
                            Robot.shared.blacken(.all)
                            self.stopTimer()
                            self.resetTimer()
                            self.currentColorIndex = self.currentColorIndex >= self.selectedColors.count - 1 ? 0 : self.currentColorIndex + 1
                            withAnimation {
                                self.currentColor = self.isShuffleModeActivated ?
                                    self.shuffledSelectedColors[self.currentColorIndex] : self.selectedColors[self.currentColorIndex]
                            }
                            self.startTimer()
                        }
                    } else {
                        ActionButton(.start, text: String(l10n.ColorMediatorView.playButtonLabel.characters)) {
                            Robot.shared.blacken(.all)
                            withAnimation {
                                self.currentColor = self.isShuffleModeActivated ?
                                    self.shuffledSelectedColors[self.currentColorIndex] : self.selectedColors[self.currentColorIndex]
                            }
                            self.startTimer()
                            self.isPlaying = true
                        }
                    }

                    ActionButton(.stop, text: String(l10n.ColorMediatorView.stopButtonLabel.characters), isPlaying: self.isPlaying) {
                        self.resetGame()
                    }
                    .disabled(!self.isPlaying)
                }

                VStack {
                    ZStack {
                        self.currentColor.screen
                            .frame(width: 300, height: 300)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                            .shadow(color: self.currentColor.screen, radius: self.remainingTime == 0 ? 20 : 0)
                            .animation(.easeIn(duration: 0.2), value: self.remainingTime == 0)

                        Text("\(self.remainingTime)")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.black)
                    }

                    Text(l10n.ColorMediatorView.robotColorLabel)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            ReinforcerBarButton()
                .padding(.bottom, 20)
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
        VStack {
            Button {
                self.isColorSelectorPresented = true
            } label: {
                Text("🎨")
                    .font(.title)
                    .padding()
                    .background(self.backgroundColor)
                    .clipShape(Circle())
                    .shadow(radius: 1)
            }
            Text(l10n.ColorMediatorView.chooseColorsButtonLabel)
                .foregroundStyle(.secondary)
        }
    }

    private var shuffleButton: some View {
        VStack {
            HStack {
                Toggle("", isOn: self.$isShuffleModeActivated)
                    .labelsHidden()
                    .onChange(of: self.isShuffleModeActivated) { isShuffleModeActivated in
                        self.resetGame()
                        if !isShuffleModeActivated { return }
                        self.shuffledSelectedColors = self.selectedColors.shuffled()
                    }
                Image(systemName: "shuffle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
            }
            Text(l10n.ColorMediatorView.shuffleColorLabel)
                .foregroundStyle(.secondary)
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
    @State private var shuffledSelectedColors: [Robot.Color] = []
    @State private var currentColor: Robot.Color = .white
    @State private var currentColorIndex: Int = 0
    @State private var remainingTime: Int = 5

    @State private var isShuffleModeActivated: Bool = false
    @State private var isPlaying: Bool = false
    @State var timer: Timer?

    private let backgroundColor: Color = .init(light: UIColor.white, dark: UIColor.systemGray5)
}

#Preview {
    ColorMediatorView()
}
