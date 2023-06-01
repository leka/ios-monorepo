// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import Foundation
import GameplayKit
import SwiftUI
import UIKit

var mockedStep1 = Step(
    id: UUID(), instruction: LocalizedContent(), correctAnswer: "blue", allAnswers: ["blue", "red", "yellow"])
var mockedStep2 = Step(
    id: UUID(), instruction: LocalizedContent(), correctAnswer: "red", allAnswers: ["green", "red", "yellow"])
var mockedStep3 = Step(
    id: UUID(), instruction: LocalizedContent(), correctAnswer: "green", allAnswers: ["green", "blue", "pink"])
var mockedStep4 = Step(
    id: UUID(), instruction: LocalizedContent(), correctAnswer: "yellow", allAnswers: ["green", "pink", "yellow"])
var mockedStep5 = Step(
    id: UUID(), instruction: LocalizedContent(), correctAnswer: "pink", allAnswers: ["pink", "yellow", "blue"])

class GameEngineGK: NSObject, ObservableObject {

    // MARK: - Current Round configuration
    @Published var currentActivity = Activity()
    //    @Published var mockedActivity = Activity()

    @Published var mockedActivity = Activity(
        isRandom: true,
        randomAnswerPositions: true,
        stepSequence: [
            [mockedStep1, mockedStep2, mockedStep3, mockedStep4, mockedStep5]
        ])
    @Published var randomStepIndex = GKShuffledDistribution()

    // MARK: - Current Step Configuration
    @Published var answersAreImages: Bool = true  // This will change when activity types are sorted out
    @Published var allAnswers: [String] = []
    @Published var answers: [Answer] = []
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
    @Published var currentStepRandomIndex: Int = 0
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
        resetStepMarkers()
        currentActivity = mockedActivity
        result = .idle
        goodAnswers = 0
        currentGroupIndex = 0
        randomStepIndex = GKShuffledDistribution(forDieWithSideCount: currentActivity.stepsAmount - 1)
        currentStepIndex = 0
        currentStepRandomIndex = randomStepIndex.nextInt()
        setupCurrentStep()
    }

    // If current activity has only one group, multiply steps to get the number of steps indicated in the model
    func multiplyStepsIfNeeded() {
        if mockedActivity.stepSequence.count == 1 && mockedActivity.stepSequence[0].count < mockedActivity.stepsAmount {
            let multiplier = mockedActivity.stepsAmount / mockedActivity.stepSequence[0].count
            let newSequence = Array(repeating: mockedActivity.stepSequence[0], count: multiplier)
            mockedActivity.stepSequence[0] = newSequence.flatMap({ $0 })
            // Make sure each step is identifiable (no common IDs)
            for index in mockedActivity.stepSequence[0].indices {
                mockedActivity.stepSequence[0][index].id = UUID()
            }
        }
    }

    // Initialization of the progressBar with empty Markers (on BufferedActivity)
    func resetStepMarkers() {
        groupedStepMarkerColors.removeAll()
        for group in mockedActivity.stepSequence.indices {
            groupedStepMarkerColors.append([])
            for _ in mockedActivity.stepSequence[group] {
                groupedStepMarkerColors[group].append(.clear)
            }
        }
    }

    // MARK: - Setup Current Step

    // reinitialize step properties & setup for new step (with mockedActivity)
    func setupCurrentStep() {
        trials = 0
        correctAnswerAnimationPercent = 0
        correctAnswerIndex = 0
        pressedAnswerIndex = nil

        if currentActivity.isRandom {
            allAnswers = currentActivity.stepSequence[currentGroupIndex][currentStepRandomIndex].allAnswers
            stepInstruction = currentActivity.stepSequence[currentGroupIndex][currentStepRandomIndex].instruction
                .localized()
        } else {
            allAnswers = currentActivity.stepSequence[currentGroupIndex][currentStepIndex].allAnswers
            stepInstruction = currentActivity.stepSequence[currentGroupIndex][currentStepIndex].instruction.localized()
        }

        checkMediaAvailability()

        // Randomize answers
        if currentActivity.randomAnswerPositions {
            allAnswers.shuffle()
        }
        setupAnswers()

        if currentActivity.activityType == .colorQuest {
            // Show correct answer color on Leka's belt
        }
    }

    func setupAnswers() {
        answers.removeAll()
        for answer in allAnswers {
            let answerType =
                (answer
                    != currentActivity.stepSequence[currentGroupIndex][
                        currentActivity.isRandom ? currentStepRandomIndex : currentStepIndex
                    ]
                    .correctAnswer
                    ? AnswerType.right : AnswerType.wrong)
            let newAnswer = Answer(answerType, color: stringToColor(from: answer))
            answers.append(newAnswer)
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

    // setup player and "buttons' overlay" if needed depending on activity type
    func checkMediaAvailability() {
        switch currentActivity.activityType {
            case .listenThenTouchToSelect:
                setAudioPlayer()
                currentMediaHasBeenPlayedOnce = false
                allAnswersAreDisabled = true
                sound =
                    currentActivity.stepSequence[currentGroupIndex][
                        currentActivity.isRandom ? currentStepRandomIndex : currentStepIndex
                    ]
                    .sound?[0] ?? ""
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
        if answers[pressedAnswerIndex!].answerType == .right {
            rewardsAnimations()
        } else {
            tryStepAgain()
        }
        //        pressedAnswerIndex = atIndex
        //        if atIndex == correctAnswerIndex {
        //            rewardsAnimations()
        //        } else {
        //            tryStepAgain()
        //        }
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
                resetActivity()
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
                self.currentStepRandomIndex = self.randomStepIndex.nextInt()
            } else {
                self.currentStepIndex += 1
                self.currentStepRandomIndex = self.randomStepIndex.nextInt()
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
        mockedActivity = Activity()
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

    // MARK: - ProgressBar & Markers for mockedActivity
    func setMarkerColor(forGroup: Int, atIndex: Int) {
        print(trials)
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

extension GameEngineGK: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

extension GameEngineGK: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentMediaHasBeenPlayedOnce = true
        allAnswersAreDisabled = false
    }
}
