// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFoundation
import SwiftUI
import UIKit
import Yams

// @MainActor
class ActivityViewModel: NSObject, ObservableObject, YamlFileDecodable {

    func getActivity(_ title: String) -> Activity {
        do {
            return try self.decodeYamlFile(withName: title, toType: Activity.self)
        } catch {
            print("Activities: Failed to decode Yaml file with error:", error)
            return Activity()
        }
    }

    // Temporary Instructions Source
    func getInstructions() -> String {
        do {
            return try self.decodeYamlFile(withName: "instructions", toType: Instructions.self).instructions.localized()
        } catch {
            print("Instructions: Failed to decode Yaml file with error:", error)
            return Instructions().instructions.localized()
        }
    }

    // MARK: - Current Activity's properties
    @Published var currentActivity = Activity()
    @Published var selectedActivityID: UUID?  // save scroll position
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

    // MARK: - GameEngine Methods

    // fetch selected activity's data + setup and randomize
    func setupGame(with: Activity) {
        currentActivityTitle = with.short.localized()
        currentActivityType = with.activityType ?? "touch_to_select"
        numberOfSteps = with.stepsAmount
        steps = with.steps
        // If current activity has to repeat steps (assuming the model is always 5 provided vs. 10 expected steps...)
        if steps.count != 10 {
            steps = with.steps + with.steps
        }
        randomizeSteps()
        result = .idle
        goodAnswers = 0
        currentStep = 0
        populateMarkerColors()
        setupCurrentStep()
    }

    // Randomize steps & prevent 2 identical steps in a row
    func randomizeSteps() {
        if currentActivity.isRandom {
            steps.shuffle()
            var store: [Step] = []
            var buffer: [Step] = []
            var previous = Step()
            for step in steps {
                if step == previous {
                    store.append(step)
                } else {
                    buffer.append(step)
                }
                previous = step
            }
            steps = store + (store.last == buffer.first ? buffer.reversed() : buffer)
        }
    }

    // Initialization of the progressBar with empty Markers
    func populateMarkerColors() {
        markerColors = []
        for _ in steps {
            markerColors.append(Color.clear)
        }
    }

    // setup player and "buttons' overlay" if needed depending on activity type
    func checkMediaAvailability() {
        if currentActivityType != "touch_to_select" {
            setAudioPlayer()
            currentMediaHasBeenPlayedOnce = false
            answersAreDisabled = true
        } else {
            // keep the white overlay hidden upon answers' buttons when no media is available
            currentMediaHasBeenPlayedOnce = true
            answersAreDisabled = false
        }
    }

    // reinitialize step properties & setup for new step
    func setupCurrentStep() {
        trials = 0
        percent = 0
        pressedIndex = 100
        images = steps[currentStep].images
        sound = steps[currentStep].sound?[0] ?? ""
        checkMediaAvailability()
        // Randomize answers
        if currentActivity.randomImagePosition {
            images.shuffle()
        }
        // Pick up Correct answer
        for (index, answer) in images.enumerated() where answer == steps[currentStep].correctAnswer {
            correctIndex = index
        }
    }

    // Prevent multiple taps, deal with success or failure
    func answerHasBeenPressed(atIndex: Int) {
        tapIsDisabled.toggle()  // true
        trials += 1
        pressedIndex = atIndex
        if pressedIndex == correctIndex {
            rewardsAnimations()
        } else {
            tryStepAgain()
        }
    }

    // After good answer, reward and play next (if available) or show final animation screen
    func rewardsAnimations() {
        if currentStep < numberOfSteps - 1 {
            withAnimation(.easeOut(duration: 0.8)) {
                percent = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showMotivator.toggle()  // true
                    self.showBlurryBG.toggle()
                    self.runMotivatorScenario()
                }
            }
        } else if currentStep == numberOfSteps - 1 {
            withAnimation(.easeOut(duration: 0.8)) {
                percent = 1.0
                // Final step updated here to be seen by user & included in the final percent count
                updateMarkers(atIndex: currentStep)
                calculateSuccessPercent()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showEndAnimation.toggle()  // true
                    self.showBlurryBG = true
                    self.tapIsDisabled.toggle()  // false
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
            self.pressedIndex = 100
            self.updateMarkers(atIndex: self.currentStep)
            self.currentStep += 1
            self.setupCurrentStep()
        }
    }

    // Method that runs after the Motivator Lottie animation completes
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
                self.pressedIndex = 100
            }
        }
    }

    // Update 1 marker in the ProgressBar + goodAnswer's count
    func setMarkerColor() -> Color {
        var color: Color = .clear
        if trials == 1 {
            color = .green
            goodAnswers += 1
        } else if trials == 2 {
            color = .orange
        } else if trials > 2 {
            color = .red
        }
        return color
    }

    // Update current Marker after success
    func updateMarkers(atIndex: Int) {
        markerColors[atIndex] = setMarkerColor()
    }

    // Final % of good answers
    func calculateSuccessPercent() {
        percentOfSuccess = Int((Double(goodAnswers) * 100) / Double(numberOfSteps).rounded(.toNearestOrAwayFromZero))
        if percentOfSuccess == 0 {
            result = .fail
        } else if percentOfSuccess >= 80 {
            result = .success
        } else {
            result = .medium
        }
    }

    // Transition to the beginning of Current activity for replay
    func replayCurrentActivity() {
        Task {
            setupGame(with: currentActivity)
            showBlurryBG = false
            showEndAnimation = false
        }
    }

    // Set selected activity to empty
    func resetActivity() {
        // + reset those 2 properties for next round
        showBlurryBG = false
        showEndAnimation = false
        //		selectedActivity = Activity()
    }

}
