// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

public class StepManager: ObservableObject {
    @Published public var currentInterface: InterfaceType

    public var currentStepIndex: Int = 0
    public var steps: [any StepModelProtocol]
    public var currentStep: any StepModelProtocol
    public var currentGameplay: any GameplayProtocol
    public var state = CurrentValueSubject<GameplayState, Never>(.idle)

    var cancellables = Set<AnyCancellable>()

    public init(steps: [any StepModelProtocol], state: GameplayState = .idle) {
        self.steps = steps
        guard let firstStep = steps.first else {
            self.currentStep = StandardStepModel(choices: [], gameplay: .undefined, interface: .undefined)
            self.currentGameplay = GameplayError()
            self.currentInterface = .undefined
            return
        }
        self.currentStep = firstStep
        self.currentGameplay = StepManager.gameplaySelector(stepModel: currentStep)
        self.currentInterface = currentStep.interface
        subscribeToGameplayState()
    }

    private func subscribeToGameplayState() {
        self.currentGameplay.state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.state.send($0)
                if $0 == .finished {
                    Task {
                        await self.nextStep()
                    }
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
        }
    }

    @ViewBuilder public var interface: some View {
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
        }
    }

    func nextStep() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.currentStepIndex += 1
            guard self.currentStepIndex < self.steps.count else { return }
            self.currentStep = self.steps[self.currentStepIndex]
            self.currentGameplay = StepManager.gameplaySelector(stepModel: currentStep)
            self.currentInterface = currentStep.interface
            self.subscribeToGameplayState()
        }
    }
}
