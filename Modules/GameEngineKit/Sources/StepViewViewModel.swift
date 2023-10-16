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
                return GameplaySelectTheRightAnswer(choices: (stepModel.choices as? [ChoiceModel])!)
            case .selectAllRightAnswers:
                return GameplaySelectAllRightAnswers(choices: (stepModel.choices as? [ChoiceModel])!)
            case .selectSomeRightAnswers(let answersNumber):
                return GameplaySelectSomeRightAnswers(
                    choices: (stepModel.choices as? [ChoiceModel])!, rightAnswersToFind: answersNumber)
            case .association:
                return GameplayAssociation(choices: (stepModel.choices as? [AssociationChoiceModel])!)
            case .colorBingo:
                return ColorBingoGameplay(choices: (stepModel.choices as? [ChoiceModel])!)
            case .superSimon(let answerIndexOrder):
                return SuperSimonGameplay(
                    choices: (stepModel.choices as? [ChoiceModel])!, answerIndexOrder: answerIndexOrder)
        }
    }

    @ViewBuilder public var interfaceView: some View {
        switch currentInterface {
            case .undefined:
                StepErrorView()
            case .oneChoice:
                OneChoiceView(gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!)
            case .twoChoices:
                TwoChoicesView(gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!)
            case .threeChoices:
                ThreeChoicesView(gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!)
            case .threeChoicesInline:
                ThreeChoicesInlineView(gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!)
            case .fourChoices:
                FourChoicesView(gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!)
            case .fourChoicesInline:
                FourChoicesInlineView(gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!)
            case .fiveChoices:
                FiveChoicesView(gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!)
            case .sixChoices:
                SixChoicesView(gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!)
            case .listenOneChoice(let audioRecording):
                ListenOneChoiceView(
                    gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!, audioRecording: audioRecording)
            case .listenTwoChoices(let audioRecording):
                ListenTwoChoicesView(
                    gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!, audioRecording: audioRecording)
            case .listenThreeChoices(let audioRecording):
                ListenThreeChoicesView(
                    gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!, audioRecording: audioRecording)
            case .listenThreeChoicesInline(let audioRecording):
                ListenThreeChoicesInlineView(
                    gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!, audioRecording: audioRecording)
            case .listenFourChoices(let audioRecording):
                ListenFourChoicesView(
                    gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!, audioRecording: audioRecording)
            case .listenSixChoices(let audioRecording):
                ListenSixChoicesView(
                    gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!, audioRecording: audioRecording)
            case .dragAndDropOneAreaOneChoice(let dropArea):
                DragAndDropOneAreaOneChoiceView(
                    gameplay: (currentGameplay as? any GameplayProtocol<ChoiceModel>)!, dropArea: dropArea)
            case .dragAndDropAssociationFourChoices:
                DragAndDropAssociationFourChoicesView(
                    gameplay: (currentGameplay as? any GameplayProtocol<AssociationChoiceModel>)!)
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
