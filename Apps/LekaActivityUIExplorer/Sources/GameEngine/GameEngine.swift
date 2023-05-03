// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import Foundation
import SwiftUI
import UIKit

class GameEngine: NSObject, ObservableObject {

    // MARK: - Current Round configuration
    @Published var currentActivity = Activity()
    @Published var bufferActivity = Activity()

    // MARK: - Current Step Configuration
    @Published var answersAreImages: Bool = true  // This will change when activity types are sorted out
    @Published var allAnswers: [String] = []
    @Published var stepInstruction: String = "Nothing to display"
    @Published var correctAnswerIndex: Int = 0
    @Published var allAnswersAreDisabled: Bool = false
    @Published var tapIsDisabled: Bool = false

    // MARK: - Game Statistics
    // Current Round Stats
    @Published var goodAnswers: Int = 0
    @Published var correctAnswerAnimationPercent: CGFloat = .zero
    @Published var percentOfSuccess: Int = 0
    @Published var result: ResultType = .idle

    // Current Step Stats
    @Published var currentGroupIndex: Int = 0
    @Published var currentStepIndex: Int = 0
    @Published var trials: Int = 0
    @Published var pressedAnswerIndex: Int?

    // MARK: - Game UI Interactions properties
    @Published var groupedStepMarkerColors: [[Color]] = [[]]
    @Published var isSpeaking: Bool = false
    @Published var overlayOpacity: Double = 0
    @Published var showMotivator: Bool = false
    @Published var showBlurryBG: Bool = false
    @Published var showEndAnimation: Bool = false

    // MARK: - AudioPlayer - Media related Activities
    @Published var sound: String = ""
    @Published var audioPlayer: AVAudioPlayer!
    @Published var progress: CGFloat = 0.0
    @Published var currentMediaHasBeenPlayedOnce: Bool = false

    // MARK: - Game Setup

    // fetch selected activity's data + setup and randomize
    func setupGame() {
        multiplyStepsIfNeeded()
        randomizeSteps()
        resetStepMarkers()
        currentActivity = bufferActivity
        result = .idle
        goodAnswers = 0
        currentGroupIndex = 0
        currentStepIndex = 0  // this will probably change to take into account the sequencing of Steps
        setupCurrentStep()
    }

    // If current activity has only one group, multiply steps to get the number of steps indicated in the model
    func multiplyStepsIfNeeded() {
        if bufferActivity.stepSequence.count == 1 && bufferActivity.stepSequence[0].count < bufferActivity.stepsAmount {
            let multiplier = bufferActivity.stepsAmount / bufferActivity.stepSequence[0].count
            let newSequence = Array(repeating: bufferActivity.stepSequence[0], count: multiplier)
            bufferActivity.stepSequence[0] = newSequence.flatMap({ $0 })
            // Make sure each step is identifiable (no common IDs)
            for index in bufferActivity.stepSequence[0].indices {
                bufferActivity.stepSequence[0][index].id = UUID()
            }
        }
    }

    // Initialization of the progressBar with empty Markers (on BufferActivity)
    func resetStepMarkers() {
        groupedStepMarkerColors.removeAll()
        for group in bufferActivity.stepSequence.indices {
            groupedStepMarkerColors.append([])
            for _ in bufferActivity.stepSequence[group] {
                groupedStepMarkerColors[group].append(.clear)
            }
        }
    }

    // Randomize steps & prevent 2 identical steps in a row (within BufferActivity)
    func randomizeSteps() {
        if bufferActivity.isRandom {
            for index in bufferActivity.stepSequence.indices {
                bufferActivity.stepSequence[index].shuffle()
                bufferActivity.stepSequence[index].sort { $0 != $1 }
            }
        }
    }

    // MARK: - Setup Current Step

    // reinitialize step properties & setup for new step (with currentActivity)
    func setupCurrentStep() {
        trials = 0
        correctAnswerAnimationPercent = 0
        correctAnswerIndex = 0
        pressedAnswerIndex = nil
        allAnswers = currentActivity.stepSequence[currentGroupIndex][currentStepIndex].allAnswers

        checkMediaAvailability()

        // Randomize answers
        if currentActivity.randomAnswerPositions {
            allAnswers.shuffle()

        }
        stepInstruction = currentActivity.stepSequence[currentGroupIndex][currentStepIndex].instruction.localized()
        getCorrectAnswerIndex()

        if currentActivity.activityType == "color_quest" {
            // Show correct answer color on Leka's belt
        }
    }

    // Turn answer strings to color names
    func stringToColor(from: String) -> Color {
        switch from {
            case "red": return .red
            case "pink": return .pink
            case "blue": return .blue
            case "green": return .green
            case "yellow": return .yellow
            default: return .blue
        }
    }

    // Pick up Correct answer
    private func getCorrectAnswerIndex() {
        if let i = allAnswers.firstIndex(where: {
            $0 == currentActivity.stepSequence[currentGroupIndex][currentStepIndex].correctAnswer
        }) {
            correctAnswerIndex = i
        }
    }

    // setup player and "buttons' overlay" if needed depending on activity type
    func checkMediaAvailability() {
        switch currentActivity.activityType {
            case "listen_then_touch_to_select":
                setAudioPlayer()
                currentMediaHasBeenPlayedOnce = false
                allAnswersAreDisabled = true
                sound = currentActivity.stepSequence[currentGroupIndex][currentStepIndex].sound?[0] ?? ""
            default:
                // property is set to true in order to keep the white overlay hidden
                currentMediaHasBeenPlayedOnce = true
                allAnswersAreDisabled = false
        }
    }

    // AudioPlayer (delegate in Extensions.swift)
    func setAudioPlayer() {
        do {
            let path = Bundle.main.path(forResource: sound, ofType: "mp3")!
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        } catch {
            print("ERROR - mp3 file not found - \(error)")
            return
        }

        audioPlayer.prepareToPlay()
        audioPlayer.delegate = self

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let player = self.audioPlayer {
                self.progress = CGFloat(player.currentTime / player.duration)
            }
        }
    }

    // MARK: - Answering Logic
    // Prevent multiple taps, deal with success or failure
    func answerHasBeenPressed(atIndex: Int) {
        tapIsDisabled.toggle()  // true
        trials += 1
        pressedAnswerIndex = atIndex
        if atIndex == correctAnswerIndex {
            rewardsAnimations()
        } else {
            tryStepAgain()
        }
    }

    func rewardsAnimations() {
        if currentActivity.stepSequence[currentGroupIndex][currentStepIndex].id
            == currentActivity.stepSequence.flatMap({ $0 }).last?.id
        {
            withAnimation(.easeOut(duration: 0.8)) {
                correctAnswerAnimationPercent = 1.0
                // Final step updated here to be seen by user & included in the final percent count
                setMarkerColor(forGroup: currentGroupIndex, atIndex: currentStepIndex)
                calculateSuccessPercent()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showEndAnimation.toggle()  // true
                    self.showBlurryBG = true
                    self.tapIsDisabled.toggle()  // false
                }
                print("EndGame")
            }
        } else {
            withAnimation(.easeOut(duration: 0.8)) {
                correctAnswerAnimationPercent = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showMotivator.toggle()  // true
                    self.showBlurryBG.toggle()
                    self.runMotivatorScenario()
                }
            }
        }
    }

    // Show, Then Hide Reinforcer animation + Setup for next Step
    func runMotivatorScenario() {
        self.showBlurryBG = true
        // Update behind-the-scene during Reinforcer animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.tapIsDisabled.toggle()  // false
            self.pressedAnswerIndex = nil
            self.setMarkerColor(forGroup: self.currentGroupIndex, atIndex: self.currentStepIndex)
            if self.currentStepIndex == self.currentActivity.stepSequence[self.currentGroupIndex].count - 1 {
                self.currentGroupIndex += 1
                self.currentStepIndex = 0
            } else {
                self.currentStepIndex += 1
            }
            self.setupCurrentStep()
        }
    }

    // Motivator - Lottie animation completion
    func hideMotivator() {
        showMotivator = false
        showBlurryBG = false
    }

    // Trigger failure animation, Play again after failure(s)
    func tryStepAgain() {
        withAnimation {
            overlayOpacity = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    self.overlayOpacity = 0
                }
                self.tapIsDisabled.toggle()  // false
                self.pressedAnswerIndex = nil
            }
        }
    }

    // MARK: - End current round
    // Final % of good answers
    func calculateSuccessPercent() {
        percentOfSuccess = Int(
            (Double(goodAnswers) * 100) / Double(currentActivity.stepsAmount).rounded(.toNearestOrAwayFromZero))
        if percentOfSuccess == 0 {
            result = .fail
        } else if percentOfSuccess >= 80 {
            result = .success
        } else {
            result = .medium
        }
    }

    // MARK: - Reset Activity
    func resetActivity() {
        showBlurryBG = false
        showEndAnimation = false
        currentActivity = Activity()
        allAnswers = []
        stepInstruction = "Nothing to display"
    }

    // Transition to the beginning of Current activity for replay
    func replayCurrentActivity() {
        Task {
            setupGame()
            showBlurryBG = false
            showEndAnimation = false
        }
    }

    // MARK: - ProgressBar & Markers for currentActivity
    func setMarkerColor(forGroup: Int, atIndex: Int) {
        if trials == 1 {
            goodAnswers += 1
            groupedStepMarkerColors[forGroup][atIndex] = .green
        } else if trials == 2 {
            groupedStepMarkerColors[forGroup][atIndex] = .orange
        } else if trials > 2 {
            groupedStepMarkerColors[forGroup][atIndex] = .red
        } else {
            groupedStepMarkerColors[forGroup][atIndex] = .clear
        }
    }

    // MARK: - Speech Synthesis - Step Instructions Button
    var synth = AVSpeechSynthesizer()
    func speak(sentence: String) {
        synth.delegate = self
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.rate = 0.40
        utterance.voice =
            Locale.current.language.languageCode?.identifier == "fr"
            ? AVSpeechSynthesisVoice(language: "fr-FR") : AVSpeechSynthesisVoice(language: "en-US")
        isSpeaking = true
        synth.speak(utterance)
    }

}

extension GameEngine: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

extension GameEngine: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentMediaHasBeenPlayedOnce = true
        allAnswersAreDisabled = false
    }
}
