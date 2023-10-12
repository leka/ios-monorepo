// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class StepViewViewModel: ObservableObject {
    @Published var currentInterface: InterfaceType
    @Published var currentGameplay: any GameplayProtocol
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
                let dropZoneStepModel = stepModel as! DragAndDropZoneStepModel
                return GameplayDragAndDropOneAnswerOnTheRightZone(
                    choices: dropZoneStepModel.choices, dropZones: dropZoneStepModel.dropZones)
        }
    }

    @ViewBuilder public var interfaceView: some View {
        switch currentInterface {
            case .undefined:
                StepErrorView()
            case .oneChoice:
                OneChoiceView(gameplay: currentGameplay as! ChoiceGameplayProtocol)
            case .twoChoices:
                TwoChoicesView(gameplay: currentGameplay as! ChoiceGameplayProtocol)
            case .threeChoices:
                ThreeChoicesView(gameplay: currentGameplay as! ChoiceGameplayProtocol)
            case .threeChoicesInline:
                ThreeChoicesInlineView(gameplay: currentGameplay as! ChoiceGameplayProtocol)
            case .fourChoices:
                FourChoicesView(gameplay: currentGameplay as! ChoiceGameplayProtocol)
            case .fourChoicesInline:
                FourChoicesInlineView(gameplay: currentGameplay as! ChoiceGameplayProtocol)
            case .fiveChoices:
                FiveChoicesView(gameplay: currentGameplay as! ChoiceGameplayProtocol)
            case .sixChoices:
                SixChoicesView(gameplay: currentGameplay as! ChoiceGameplayProtocol)
            case .listenOneChoice(let audioRecording):
                ListenOneChoiceView(
                    gameplay: currentGameplay as! ChoiceGameplayProtocol, audioRecording: audioRecording)
            case .listenTwoChoices(let audioRecording):
                ListenTwoChoicesView(
                    gameplay: currentGameplay as! ChoiceGameplayProtocol, audioRecording: audioRecording)
            case .listenThreeChoices(let audioRecording):
                ListenThreeChoicesView(
                    gameplay: currentGameplay as! ChoiceGameplayProtocol, audioRecording: audioRecording)
            case .listenThreeChoicesInline(let audioRecording):
                ListenThreeChoicesInlineView(
                    gameplay: currentGameplay as! ChoiceGameplayProtocol, audioRecording: audioRecording)
            case .listenFourChoices(let audioRecording):
                ListenFourChoicesView(
                    gameplay: currentGameplay as! ChoiceGameplayProtocol, audioRecording: audioRecording)
            case .listenSixChoices(let audioRecording):
                ListenSixChoicesView(
                    gameplay: currentGameplay as! ChoiceGameplayProtocol, audioRecording: audioRecording)
            case .dragAndDropOneAreaOneOrMoreChoices:
                DragAndDropOneAreaOneOrMoreChoicesView(gameplay: currentGameplay as! DragAndDropGameplayProtocol)
            case .dragAndDropTwoAreasOneOrMoreChoices:
                DragAndDropTwoAreasOneOrMoreChoicesView(gameplay: currentGameplay as! DragAndDropGameplayProtocol)
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
