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

    public static func gameplaySelector(stepModel: any StepModelProtocol) -> any GameplayProtocol {
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
        }
    }

    @ViewBuilder public var interfaceView: some View {
        switch currentInterface {
            case .undefined:
                StepErrorView()
            case .oneChoice:
                OneChoiceView(gameplay: currentGameplay)
            case .twoChoices:
                TwoChoicesView(gameplay: currentGameplay)
            case .threeChoices:
                ThreeChoicesView(gameplay: currentGameplay)
            case .threeChoicesInline:
                ThreeChoicesInlineView(gameplay: currentGameplay)
            case .fourChoices:
                FourChoicesView(gameplay: currentGameplay)
            case .fourChoicesInline:
                FourChoicesInlineView(gameplay: currentGameplay)
            case .fiveChoices:
                FiveChoicesView(gameplay: currentGameplay)
            case .sixChoices:
                SixChoicesView(gameplay: currentGameplay)
            case .listenOneChoice(let audioRecording):
                ListenOneChoiceView(gameplay: currentGameplay, audioRecording: audioRecording)
            case .listenTwoChoices(let audioRecording):
                ListenTwoChoicesView(gameplay: currentGameplay, audioRecording: audioRecording)
            case .listenThreeChoices(let audioRecording):
                ListenThreeChoicesView(gameplay: currentGameplay, audioRecording: audioRecording)
            case .listenThreeChoicesInline(let audioRecording):
                ListenThreeChoicesInlineView(gameplay: currentGameplay, audioRecording: audioRecording)
            case .listenFourChoices(let audioRecording):
                ListenFourChoicesView(gameplay: currentGameplay, audioRecording: audioRecording)
            case .listenSixChoices(let audioRecording):
                ListenSixChoicesView(gameplay: currentGameplay, audioRecording: audioRecording)
            case .dragAndDropOneAreaOneChoice(let contexts):
                DragAndDropOneAreaOneChoiceView(gameplay: currentGameplay, contexts: contexts)
        }
    }

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
