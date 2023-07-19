// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AVFAudio
import SwiftUI

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
}

extension GameEngine {
    func animate(duration: CGFloat, _ execute: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            withAnimation(.easeOut(duration: duration)) {
                execute()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                continuation.resume()
            }
        }
    }

    // Turn answer-strings into color types
    func stringToColor(from: String) -> Color {
        switch from {
            case "red": return .red
            case "blue": return .blue
            case "purple": return .purple
            case "yellow": return .yellow
            default: return .green
        }
    }

    // MARK: - Speech Synthesis - Step Instructions Button
    func speak(sentence: String) {
        synth.delegate = self
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.rate = 0.40
        utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        //            Locale.current.language.languageCode?.identifier == "fr"
        //            ? AVSpeechSynthesisVoice(language: "fr-FR") : AVSpeechSynthesisVoice(language: "en-US")
        isSpeaking = true
        synth.speak(utterance)
    }

    // MARK: - End current round + "what's next" options

    func endGame() async {
        setMarkerColor(forGroup: currentGroupIndex, atIndex: currentStepIndex)
        calculateSuccessPercent()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showEndAnimation = true
            self.showBlurryBG = true
            self.tapIsDisabled = false
        }
        print("EndGame")
    }

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

    // Reset Activity
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

    // MARK: - ProgressBar methods

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

    // ProgressBar & Markers update for current step
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
}
