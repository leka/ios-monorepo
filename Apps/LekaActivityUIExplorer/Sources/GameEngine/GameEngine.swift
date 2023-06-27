// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import Foundation
import SwiftUI
import UIKit

@MainActor
class GameEngine: NSObject, ObservableObject {

    // MARK: - Current Round configuration
    @Published var currentActivity = Activity()
    @Published var bufferActivity = Activity()

    // MARK: - Current Step Configuration
    @Published var allAnswers: [String] = ["dummy_1"]
    @Published var interface: GameLayout = .touch1
    @Published var stepInstruction: String = "Nothing to display"
    @Published var correctAnswersIndices: [[Int]] = [[0]]
    @Published var allAnswersAreDisabled: Bool = false
    @Published var tapIsDisabled: Bool = false
    @Published var displayAnswer: Bool = false
    var synth = AVSpeechSynthesizer()

    // MARK: - Game Statistics
    // Current Round Stats
    @Published var goodAnswers: Int = 0
    @Published var correctAnswerAnimationPercent: CGFloat = .zero
    @Published var percentOfSuccess: Int = 0
    @Published var result: ResultType = .idle

    // Current Step Stats
    @Published var currentGroupIndex: Int = 0
    @Published var currentStepIndex: Int = 0
    @Published var rightAnswersGiven: [Int] = []
    @Published var trials: Int = 0
    @Published var pressedAnswerIndex: Int?

    // MARK: - Game UI Interactions properties
    @Published var groupedStepMarkerColors: [[Color]] = [[]]
    @Published var isSpeaking: Bool = false
    @Published var overlayOpacity: Double = 0
    @Published var showReinforcer: Bool = false
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
        currentStepIndex = 0
        setupCurrentStep()
    }

    // If current activity has only one group, multiply steps to get the number of steps indicated in the model
    private func multiplyStepsIfNeeded() {
        if bufferActivity.stepSequence.count == 1 && bufferActivity.stepSequence[0].count <= bufferActivity.stepsAmount
        {
            let multiplier = bufferActivity.stepsAmount / bufferActivity.stepSequence[0].count
            let newSequence = Array(repeating: bufferActivity.stepSequence[0], count: multiplier)
            bufferActivity.stepSequence[0] = newSequence.flatMap({ $0 })
            // Make sure each step is identifiable (no common IDs)
            for index in bufferActivity.stepSequence[0].indices {
                bufferActivity.stepSequence[0][index].id = UUID()
            }
        }
    }

    // Randomize steps & prevent 2 identical steps in a row (within BufferActivity)
    private func randomizeSteps() {
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
        correctAnswersIndices = [[0]]
        rightAnswersGiven = []
        pressedAnswerIndex = nil
        displayAnswer = false
        Task {
            await switchInterface()
            switch currentActivity.activityType {
                case .dragAndDrop, .listenThenTouchToSelect:
                    prepareAnswers()
                default:
                    prepareAnswersOnMainQueue()
            }
        }
        if currentActivity.activityType == .colorQuest {
            // Show correct answer color on Leka's belt
        }
    }

    private func switchInterface() async {
        interface = currentActivity.stepSequence[currentGroupIndex][currentStepIndex].interface
    }

    private func prepareAnswersOnMainQueue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.prepareAnswers()
        }
    }

    private func prepareAnswers() {
        allAnswers =
            currentActivity.stepSequence[currentGroupIndex][currentStepIndex].allAnswers
        checkMediaAvailability()
        displayAnswer = true
        // Randomize answers
        if currentActivity.randomAnswerPositions {
            allAnswers.shuffle()
        }
        stepInstruction =
            currentActivity.stepSequence[currentGroupIndex][currentStepIndex]
            .instruction.localized()
        getCorrectAnswersIndices()
    }

    // Pick up Correct answers' indices
    private func getCorrectAnswersIndices() {  // HERE
        correctAnswersIndices = []
        for (indexG, group) in currentActivity.stepSequence[currentGroupIndex][currentStepIndex].correctAnswers
            .enumerated()
        {
            correctAnswersIndices.append([])
            for (indexA, answer) in allAnswers.enumerated() where group.contains(answer) {
                correctAnswersIndices[indexG].append(indexA)
            }
        }
        // for (index, answer) in allAnswers.enumerated()
        // where currentActivity.stepSequence[currentGroupIndex][currentStepIndex].correctAnswers.contains(answer) {
        //     correctAnswersIndices.append(index)
        // }
    }

    // setup player and "buttons' overlay" if needed depending on activity type
    private func checkMediaAvailability() {
        switch currentActivity.activityType {
            case .listenThenTouchToSelect:
                setAudioPlayer()
                currentMediaHasBeenPlayedOnce = false
                allAnswersAreDisabled = true
                sound = currentActivity.stepSequence[currentGroupIndex][currentStepIndex].sound?[0] ?? ""
            case .danceFreeze:
                sound = currentActivity.stepSequence[currentGroupIndex][currentStepIndex].sound?[0] ?? ""
                setAudioPlayer()

            default:
                // property is set to true in order to keep the white overlay hidden
                currentMediaHasBeenPlayedOnce = true
                allAnswersAreDisabled = false
        }
    }

    // MARK: - Answering Logic
    // Prevent multiple taps, deal with success or failure
    func answerHasBeenPressed(atIndex: Int) {  // HERE
        tapIsDisabled = true
        pressedAnswerIndex = atIndex
        if correctAnswersIndices[0].contains(atIndex) {
            rightAnswersGiven.append(atIndex)
            if allCorrectAnswersWereGiven() {
                trials += 1
                rewardsAnimations()
            } else {
                sameStepAgain()
            }
        } else {
            trials += 1
            sameStepAgain()
        }
    }

    func allCorrectAnswersWereGiven() -> Bool {  // HERE
        rightAnswersGiven.sort()
        // correctAnswersIndices.sort()
        var flattenedCorrectAnswersIndices = correctAnswersIndices.flatMap({ $0 })
        flattenedCorrectAnswersIndices.sort()
        return rightAnswersGiven.elementsEqual(flattenedCorrectAnswersIndices)
    }

    private func rewardsAnimations() {
        if currentActivity.stepSequence[currentGroupIndex][currentStepIndex].id
            == currentActivity.stepSequence.flatMap({ $0 }).last?.id
        {
            Task {
                await animate(duration: 0.8) {
                    self.correctAnswerAnimationPercent = 1.0
                }
                // Final step updated here to be seen by user & included in the final percent count
                await endGame()
            }
        } else {
            Task {
                await animate(duration: 0.8) {
                    self.correctAnswerAnimationPercent = 1.0
                }
                await runReinforcerScenario()
            }
        }
    }

    // Show, Then Hide Reinforcer animation + Setup for next Step
    private func runReinforcerScenario() async {
        showReinforcer = true
        showBlurryBG = true
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

    // Reinforcer - Lottie animation completion
    func hideReinforcer() {
        showReinforcer = false
        showBlurryBG = false
    }

    // Trigger failure animation, Play again after failure(s)
    private func sameStepAgain() {
        Task {
            await animate(duration: 0.8) {
                self.overlayOpacity = 0.8
            }
            await animate(duration: 0.3) {
                self.overlayOpacity = 0
            }
            await resumeAfterFail()
        }
    }

    private func resumeAfterFail() async {
        tapIsDisabled = false
        pressedAnswerIndex = nil
    }
}
