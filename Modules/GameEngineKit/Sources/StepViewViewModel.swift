// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class StepViewViewModel: ObservableObject {
    @Published var currentInterface: InterfaceType
    @Published var currentGameplay: any BaseGameplayProtocol
    @Published var currentIndex: Int
    @Published var state: GameplayState = .idle

    private var stepManager: StepManager
    private var cancellables: Set<AnyCancellable> = []

    public init(stepManager: StepManager) {
        self.stepManager = stepManager
        self.currentIndex = stepManager.currentStep.value.index
        let step = stepManager.currentStep.value.step
        self.currentGameplay = StepViewViewModel.gameplaySelector(stepModel: step)
        self.currentInterface = step.interface
        subscribeToGameplayState()

        self.stepManager.currentStep
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                let step = $0.step

                self.currentIndex = $0.index
                if $0.index > 0 {
                    self.currentGameplay = StepViewViewModel.gameplaySelector(stepModel: step)
                    self.currentInterface = step.interface
                    subscribeToGameplayState()
                }
            })
            .store(in: &cancellables)
    }

    // swiftlint:disable force_cast
    public static func gameplaySelector(stepModel: any StepModelProtocol) -> any BaseGameplayProtocol {
        switch stepModel.gameplay {
            case .undefined:
                return GameplayError()
            case .selectTheRightAnswer:
                return GameplaySelectTheRightAnswer(choices: stepModel.choices)
            case .selectAllRightAnswers:
                return GameplaySelectAllRightAnswers(choices: stepModel.choices)
            case .selectSomeRightAnswers(let answersNumber):
                return GameplaySelectSomeRightAnswers(
                    choices: stepModel.choices, rightAnswersToFind: answersNumber)
            case .colorBingo:
                return ColorBingoGameplay(choices: stepModel.choices)
            case .superSimon(let answerIndexOrder):
                return SuperSimonGameplay(choices: stepModel.choices, answerIndexOrder: answerIndexOrder)
            case .dragAndDropOneAnswerOnTheRightZone:
                let dragAndDropZoneStepModel = stepModel as! DragAndDropZoneStepModel
                return GameplayDragAndDropOneAnswerOnTheRightZone(
                    choices: dragAndDropZoneStepModel.choices, dropZones: dragAndDropZoneStepModel.dropZones)
            case .dragAndDropAllAnswersOnTheRightZone:
                let dragAndDropZoneStepModel = stepModel as! DragAndDropZoneStepModel
                return GameplayDragAndDropAllAnswersOnTheRightZone(
                    choices: dragAndDropZoneStepModel.choices, dropZones: dragAndDropZoneStepModel.dropZones)
        }
    }

    @ViewBuilder public var interfaceView: some View {
        switch currentInterface {
            case .undefined:
                StepErrorView()
            case .oneChoice:
                OneChoiceView(gameplay: currentGameplay as! SelectionGameplayProtocol)
            case .twoChoices:
                TwoChoicesView(gameplay: currentGameplay as! SelectionGameplayProtocol)
            case .threeChoices:
                ThreeChoicesView(gameplay: currentGameplay as! SelectionGameplayProtocol)
            case .threeChoicesInline:
                ThreeChoicesInlineView(gameplay: currentGameplay as! SelectionGameplayProtocol)
            case .fourChoices:
                FourChoicesView(gameplay: currentGameplay as! SelectionGameplayProtocol)
            case .fourChoicesInline:
                FourChoicesInlineView(gameplay: currentGameplay as! SelectionGameplayProtocol)
            case .fiveChoices:
                FiveChoicesView(gameplay: currentGameplay as! SelectionGameplayProtocol)
            case .sixChoices:
                SixChoicesView(gameplay: currentGameplay as! SelectionGameplayProtocol)
            case .listenOneChoice(let audioRecording):
                ListenOneChoiceView(
                    gameplay: currentGameplay as! SelectionGameplayProtocol, audioRecording: audioRecording)
            case .listenTwoChoices(let audioRecording):
                ListenTwoChoicesView(
                    gameplay: currentGameplay as! SelectionGameplayProtocol, audioRecording: audioRecording)
            case .listenThreeChoices(let audioRecording):
                ListenThreeChoicesView(
                    gameplay: currentGameplay as! SelectionGameplayProtocol, audioRecording: audioRecording)
            case .listenThreeChoicesInline(let audioRecording):
                ListenThreeChoicesInlineView(
                    gameplay: currentGameplay as! SelectionGameplayProtocol, audioRecording: audioRecording)
            case .listenFourChoices(let audioRecording):
                ListenFourChoicesView(
                    gameplay: currentGameplay as! SelectionGameplayProtocol, audioRecording: audioRecording)
            case .listenSixChoices(let audioRecording):
                ListenSixChoicesView(
                    gameplay: currentGameplay as! SelectionGameplayProtocol, audioRecording: audioRecording)
            case .dragAndDropOneZoneOneOrMoreChoices(let hints):
                DragAndDropOneZoneOneOrMoreChoicesView(
                    gameplay: currentGameplay as! DragAndDropGameplayProtocol, hints: hints)
            case .dragAndDropTwoZonesOneOrMoreChoices(let hints):
                DragAndDropTwoZonesOneOrMoreChoicesView(
                    gameplay: currentGameplay as! DragAndDropGameplayProtocol, hints: hints)
        }
    }
    // swiftlint:enable force_cast

    private func subscribeToGameplayState() {
        self.currentGameplay.state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.state = $0
                if $0 == .finished {
                    self.stepManager.nextStep()
                }
            })
            .store(in: &cancellables)
    }
}
