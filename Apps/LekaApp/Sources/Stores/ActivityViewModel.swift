// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import SwiftUI
import UIKit
import Yams

// @MainActor
class ActivityViewModel: NSObject, ObservableObject, YamlFileDecodable {
    // MARK: - Current Activity's properties

    @Published var currentActivity = Activity()
    @Published var selectedActivityID: UUID? // save scroll position
    @Published var currentActivityTitle: String = ""
    @Published var currentActivityType: String = "touch_to_select"
    @Published var steps: [Step] = []
    @Published var numberOfSteps: Int = 0
    @Published var currentStep: Int = 0
    @Published var images: [String] = []
    @Published var correctIndex: Int = 0

    // AudioPlayer - Media related Activities
    @Published var sound: String = ""
    @Published var audioPlayer: AVAudioPlayer!
    @Published var progress: CGFloat = 0.0
    @Published var currentMediaHasBeenPlayedOnce: Bool = false
    @Published var answersAreDisabled: Bool = false

    // MARK: - Game-related animations & Interactions

    @Published var tapIsDisabled: Bool = false
    @Published var pressedIndex: Int = 100
    @Published var trials: Int = 0
    @Published var markerColors: [Color] = []
    @Published var overlayOpacity: Double = 0
    @Published var percent: CGFloat = .zero
    @Published var showMotivator: Bool = false
    @Published var showBlurryBG: Bool = false
    @Published var showEndAnimation: Bool = false
    @Published var goodAnswers: Int = 0
    @Published var percentOfSuccess: Int = 0
    @Published var result: ResultType = .idle

    // MARK: - UI-Based interactions (delegate in Extensions.swift)

    // Here because GameMetrics is @EnvironmentObject
    @Published var isSpeaking: Bool = false
    @Published var synth = AVSpeechSynthesizer()

    func getActivity(_ title: String) -> Activity {
        do {
            return try decodeYamlFile(withName: title, toType: Activity.self)
        } catch {
            print("Activities: Failed to decode Yaml file with error:", error)
            return Activity()
        }
    }

    // Temporary Instructions Source
    func getInstructions() -> String {
        do {
            return try decodeYamlFile(withName: "instructions", toType: Instructions.self).instructions.localized()
        } catch {
            print("Instructions: Failed to decode Yaml file with error:", error)
            return Instructions().instructions.localized()
        }
    }

    func speak(sentence: String) {
        self.synth.delegate = self
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.rate = 0.40
        utterance.voice =
            Locale.current.language.languageCode?.identifier == "fr"
                ? AVSpeechSynthesisVoice(language: "fr-FR") : AVSpeechSynthesisVoice(language: "en-US")

        self.isSpeaking = true
        self.synth.speak(utterance)
    }

    // AudioPlayer (delegate in Extensions.swift)
    func setAudioPlayer() {
        do {
            let path = Bundle.main.path(forResource: self.sound, ofType: "mp3")!
            self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        } catch {
            print("ERROR - mp3 file not found - \(error)")
            return
        }

        self.audioPlayer.prepareToPlay()
        self.audioPlayer.delegate = self

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let player = self.audioPlayer {
                self.progress = CGFloat(player.currentTime / player.duration)
            }
        }
    }

    // MARK: - GameEngine Methods

    // fetch selected activity's data + setup and randomize
    func setupGame(with: Activity) {
        self.currentActivityTitle = with.short.localized()
        self.currentActivityType = with.activityType ?? "touch_to_select"
        self.numberOfSteps = with.stepsAmount
        self.steps = with.steps
        // If current activity has to repeat steps (assuming the model is always 5 provided vs. 10 expected steps...)
        if self.steps.count != 10 {
            self.steps = with.steps + with.steps
        }
        self.randomizeSteps()
        self.result = .idle
        self.goodAnswers = 0
        self.currentStep = 0
        self.populateMarkerColors()
        self.setupCurrentStep()
    }

    // Randomize steps & prevent 2 identical steps in a row
    func randomizeSteps() {
        if self.currentActivity.isRandom {
            self.steps.shuffle()
            var store: [Step] = []
            var buffer: [Step] = []
            var previous = Step()
            for step in self.steps {
                if step == previous {
                    store.append(step)
                } else {
                    buffer.append(step)
                }
                previous = step
            }
            self.steps = store + (store.last == buffer.first ? buffer.reversed() : buffer)
        }
    }

    // Initialization of the progressBar with empty Markers
    func populateMarkerColors() {
        self.markerColors = []
        for _ in self.steps {
            self.markerColors.append(Color.clear)
        }
    }

    // setup player and "buttons' overlay" if needed depending on activity type
    func checkMediaAvailability() {
        if self.currentActivityType != "touch_to_select" {
            self.setAudioPlayer()
            self.currentMediaHasBeenPlayedOnce = false
            self.answersAreDisabled = true
        } else {
            // keep the white overlay hidden upon answers' buttons when no media is available
            self.currentMediaHasBeenPlayedOnce = true
            self.answersAreDisabled = false
        }
    }

    // reinitialize step properties & setup for new step
    func setupCurrentStep() {
        self.trials = 0
        self.percent = 0
        self.pressedIndex = 100
        self.images = self.steps[self.currentStep].images
        self.sound = self.steps[self.currentStep].sound?[0] ?? ""
        self.checkMediaAvailability()
        // Randomize answers
        if self.currentActivity.randomImagePosition {
            self.images.shuffle()
        }
        // Pick up Correct answer
        for (index, answer) in self.images.enumerated() where answer == self.steps[self.currentStep].correctAnswer {
            correctIndex = index
        }
    }

    // Prevent multiple taps, deal with success or failure
    func answerHasBeenPressed(atIndex: Int) {
        self.tapIsDisabled.toggle() // true
        self.trials += 1
        self.pressedIndex = atIndex
        if self.pressedIndex == self.correctIndex {
            self.rewardsAnimations()
        } else {
            self.tryStepAgain()
        }
    }

    // After good answer, reward and play next (if available) or show final animation screen
    func rewardsAnimations() {
        if self.currentStep < self.numberOfSteps - 1 {
            withAnimation(.easeOut(duration: 0.8)) {
                self.percent = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showMotivator.toggle() // true
                    self.showBlurryBG.toggle()
                    self.runMotivatorScenario()
                }
            }
        } else if self.currentStep == self.numberOfSteps - 1 {
            withAnimation(.easeOut(duration: 0.8)) {
                self.percent = 1.0
                // Final step updated here to be seen by user & included in the final percent count
                self.updateMarkers(atIndex: self.currentStep)
                self.calculateSuccessPercent()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showEndAnimation.toggle() // true
                    self.showBlurryBG = true
                    self.tapIsDisabled.toggle() // false
                }
            }
        }
    }

    // Show, Then Hide Reinforcer animation + Setup for next Step
    func runMotivatorScenario() {
        self.showBlurryBG = true
        // Update behind-the-scene during Reinforcer animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.tapIsDisabled.toggle() // false
            self.pressedIndex = 100
            self.updateMarkers(atIndex: self.currentStep)
            self.currentStep += 1
            self.setupCurrentStep()
        }
    }

    // Method that runs after the Motivator Lottie animation completes
    func hideMotivator() {
        self.showMotivator = false
        self.showBlurryBG = false
    }

    // Trigger failure animation, Play again after failure(s)
    func tryStepAgain() {
        withAnimation {
            self.overlayOpacity = 0.8
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    self.overlayOpacity = 0
                }
                self.tapIsDisabled.toggle() // false
                self.pressedIndex = 100
            }
        }
    }

    // Update 1 marker in the ProgressBar + goodAnswer's count
    func setMarkerColor() -> Color {
        var color: Color = .clear
        if self.trials == 1 {
            color = .green
            self.goodAnswers += 1
        } else if self.trials == 2 {
            color = .orange
        } else if self.trials > 2 {
            color = .red
        }
        return color
    }

    // Update current Marker after success
    func updateMarkers(atIndex: Int) {
        self.markerColors[atIndex] = self.setMarkerColor()
    }

    // Final % of good answers
    func calculateSuccessPercent() {
        self.percentOfSuccess = Int((Double(self.goodAnswers) * 100) / Double(self.numberOfSteps).rounded(.toNearestOrAwayFromZero))
        if self.percentOfSuccess == 0 {
            self.result = .fail
        } else if self.percentOfSuccess >= 80 {
            self.result = .success
        } else {
            self.result = .medium
        }
    }

    // Transition to the beginning of Current activity for replay
    func replayCurrentActivity() {
        Task {
            self.setupGame(with: self.currentActivity)
            self.showBlurryBG = false
            self.showEndAnimation = false
        }
    }

    // Set selected activity to empty
    func resetActivity() {
        // + reset those 2 properties for next round
        self.showBlurryBG = false
        self.showEndAnimation = false
        //		selectedActivity = Activity()
    }
}
