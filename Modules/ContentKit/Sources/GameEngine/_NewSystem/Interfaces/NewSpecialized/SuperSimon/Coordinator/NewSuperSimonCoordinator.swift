// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import Combine
import RobotKit
import SwiftUI

// MARK: - CoordinatorSuperSimonChoiceModel

struct CoordinatorSuperSimonChoiceModel: Identifiable {
    let id: UUID = .init()
    let color: String

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

// MARK: - NewSuperSimonGameState

enum NewSuperSimonGameState: Equatable {
    case showingColorSequence
    case playingColorSequence
    case waitingForUser
}

// MARK: - NewSuperSimonCoordinator

class NewSuperSimonCoordinator: ExerciseSharedDataProtocol {
    // MARK: Lifecycle

    init(level: SuperSimonLevel) {
        let numberOfChoices = switch level {
            case .easy:
                2
            case .medium:
                4
            case .hard:
                6
        }

        self.availablePaletteColorChoice = Array(self.completePaletteColorChoice.prefix(numberOfChoices))
        self.uiModel.value.action = .robot(type: .color(""))
        self.rawChoices = self.availablePaletteColorChoice.map { color in
            CoordinatorSuperSimonChoiceModel(color: color)
        }
        self.uiModel.value.choices = self.rawChoices.map { choice in
            let view = ChoiceView(value: choice.color,
                                  type: .color,
                                  size: self.uiModel.value.choiceSize(for: numberOfChoices),
                                  state: .idle)
            return TTSUIChoiceModel(id: choice.id, view: view)
        }

        self.generateColorSequence()
        self.startNextSequence()
    }

    public convenience init(model: NewSuperSimonModel) {
        self.init(level: model.level)
    }

    // MARK: Public

    public private(set) var uiModel = CurrentValueSubject<TTSUIModel, Never>(.zero)

    // MARK: Internal

    var didComplete: PassthroughSubject<Void, Never> = .init()

    var gameState: CurrentValueSubject<SuperSimonGameState, Never> = .init(.showingColorSequence)

    let completePaletteColorChoice: [String] = ["red", "blue", "green", "yellow", "purple", "orange"]
    let availablePaletteColorChoice: [String]

    var completeColorSequence: [CoordinatorSuperSimonChoiceModel] = []
    var currentColorSequence: [CoordinatorSuperSimonChoiceModel] = []

    let rawChoices: [CoordinatorSuperSimonChoiceModel]
    var sequenceIndex: Int = 0
    let sequenceLength = 6

    let robot = Robot.shared
    let player: MIDIPlayer = .init(instrument: .xylophone)

    var workItem: DispatchWorkItem?

    func generateColorSequence() {
        for _ in 1...self.sequenceLength {
            self.completeColorSequence.append(self.rawChoices.randomElement()!)
        }
    }

    func processUserSelection(choiceID: UUID) {
        if let choice = self.currentColorSequence.first(where: { $0.id == choiceID }) {
            self.sequenceIndex += 1

            self.workItem?.cancel()

            self.robot.shine(.all(in: Robot.Color(from: choice.color)))
            self.player.noteOn(number: choice.note)

            self.workItem = DispatchWorkItem {
                self.robot.blacken(.all)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: self.workItem!)
        }

        if self.sequenceIndex == self.completeColorSequence.count {
            // TODO: (@ladislas, @HPezz) Trigger didComplete on animation ended
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                logGEK.debug("Exercise completed")
                self.didComplete.send()
            }
        } else if self.sequenceIndex == self.currentColorSequence.count {
            self.startNextSequence()
        }
    }

    func startNextSequence() {
        let nextCurrentColorSequenceLength = self.currentColorSequence.count + 1

        self.currentColorSequence = Array(self.completeColorSequence.prefix(nextCurrentColorSequenceLength))
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

        if currentColorSequenceIndex >= self.currentColorSequence.count {
            self.gameState.send(.waitingForUser)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.robot.shine(.all(in: Robot.Color(from: self.currentColorSequence[currentColorSequenceIndex].color)))
            self.player.noteOn(number: self.currentColorSequence[currentColorSequenceIndex].note)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showNextColor(currentColorSequenceIndex: currentColorSequenceIndex + 1)
            }
        }
    }
}

extension NewSuperSimonCoordinator {
    enum State {
        case idle
        case selected
        case correct
        case wrong
    }

    struct ChoiceView: View {
        // MARK: Lifecycle

        init(value: String, type: ChoiceType, size: CGFloat, state: State) {
            self.value = value
            self.type = type
            self.size = size
            self.state = state
        }

        // MARK: Internal

        var body: some View {
            switch self.state {
                case .correct:
                    TTSChoiceViewDefaultCorrect(value: self.value, type: self.type, size: self.size)
                case .wrong:
                    TTSChoiceViewDefaultWrong(value: self.value, type: self.type, size: self.size)
                case .selected:
                    TTSChoiceViewDefaultSelected(value: self.value, type: self.type, size: self.size)
                case .idle:
                    TTSChoiceViewDefaultIdle(value: self.value, type: self.type, size: self.size)
            }
        }

        // MARK: Private

        private let value: String
        private let type: ChoiceType
        private let size: CGFloat
        private let state: State
    }
}
