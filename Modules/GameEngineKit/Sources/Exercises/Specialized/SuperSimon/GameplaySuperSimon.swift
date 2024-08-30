// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import ContentKit
import Foundation
import RobotKit

// MARK: - GameplaySuperSimonChoiceModel

struct GameplaySuperSimonChoiceModel: Identifiable {
    let id: String = UUID().uuidString
    let color: String
    var state: GameplayChoiceState = .idle

    var note: UInt8 {
        switch self.color {
            case "red":
                24
            case "blue":
                36
            case "green":
                28
            case "yellow":
                31
            case "purple":
                26
            case "orange":
                33
            default:
                0
        }
    }
}

// MARK: - SuperSimonGameState

enum SuperSimonGameState: Equatable {
    case showingColorSequence
    case playingColorSequence
    case waitingForUser
}

// MARK: - GameplaySuperSimon

class GameplaySuperSimon: StatefulGameplayProtocol {
    // MARK: Lifecycle

    init(level: SuperSimon.Level) {
        let numberOfChoices = switch level {
            case .easy:
                2
            case .medium:
                4
            case .hard:
                6
        }

        self.availablePaletteColorChoice = Array(self.completePaletteColorChoice[0..<numberOfChoices])

        self.choices.send(self.availablePaletteColorChoice.map { GameplaySuperSimonChoiceModel(color: $0) })

        self.generateColorSequence()

        self.startNextSequence()

        self.allowedTrials = self.getNumberOfAllowedTrials(from: kGradingLUTDefault)

        self.state.send(.playing())
    }

    // MARK: Internal

    typealias GameplayChoiceModelType = GameplaySuperSimonChoiceModel

    var state: CurrentValueSubject<ExerciseState, Never> = .init(.idle)
    var gameState: CurrentValueSubject<SuperSimonGameState, Never> = .init(.showingColorSequence)
    var numberOfTrials: Int = 0
    var allowedTrials: Int = 0

    let completePaletteColorChoice: [String] = ["red", "blue", "green", "yellow", "purple", "orange"]
    let availablePaletteColorChoice: [String]
    let choices: CurrentValueSubject<[GameplaySuperSimonChoiceModel], Never> = .init([])

    var completeColorSequence: [GameplaySuperSimonChoiceModel] = []
    let sequenceLength = 6
    var currentColorSequence: CurrentValueSubject<[GameplaySuperSimonChoiceModel], Never> = .init([])
    var sequenceIndex: Int = 0

    let robot = Robot.shared

    var player: MIDIPlayer = .init(instrument: .xylophone)

    var workItem: DispatchWorkItem?

    func generateColorSequence() {
        for _ in 1...self.sequenceLength {
            self.completeColorSequence.append(self.choices.value.randomElement()!)
        }
    }

    func process(choice: GameplaySuperSimonChoiceModel) {
        self.numberOfTrials += 1

        if choice.id == self.currentColorSequence.value[self.sequenceIndex].id {
            self.sequenceIndex += 1

            self.workItem?.cancel()

            self.robot.shine(.all(in: .init(from: choice.color)))
            self.player.noteOn(number: choice.note)

            self.workItem = DispatchWorkItem {
                self.robot.blacken(.all)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: self.workItem!)
        }

        if self.sequenceIndex == self.completeColorSequence.count {
            let level = evaluateCompletionLevel(allowedTrials: allowedTrials, numberOfTrials: numberOfTrials)
            self.state.send(.completed(level: level))
        } else if self.sequenceIndex == self.currentColorSequence.value.count {
            self.startNextSequence()
        }
    }

    func startNextSequence() {
        let nextcurrentColorSequenceLength = self.currentColorSequence.value.count + 1

        self.currentColorSequence.send(Array(self.completeColorSequence[0..<nextcurrentColorSequenceLength]))
        self.sequenceIndex = 0

        self.gameState.send(.showingColorSequence)
    }

    func rewindSequence() {
        self.sequenceIndex = 0
    }

    func playColorSequence() {
        self.rewindSequence()

        self.gameState.send(.playingColorSequence)

        DispatchQueue.main.async {
            self.showNextColor()
        }
    }

    func showNextColor(currentColorSequenceIndex: Int = 0) {
        self.robot.blacken(.all)

        if currentColorSequenceIndex >= self.currentColorSequence.value.count {
            self.gameState.send(.waitingForUser)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.robot.shine(.all(in: .init(from: self.currentColorSequence.value[currentColorSequenceIndex].color)))
            self.player.noteOn(number: self.currentColorSequence.value[currentColorSequenceIndex].note)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showNextColor(currentColorSequenceIndex: currentColorSequenceIndex + 1)
            }
        }
    }

    func getNumberOfAllowedTrials(from _: GradingLUT) -> Int {
        let minimumTrials = (sequenceLength * (sequenceLength + 1)) / 2
        return minimumTrials + 1 * self.sequenceLength
    }
}
