// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

struct CurrentStep {
    var index: Int
    var step: any StepModelProtocol

    init() {
        self.index = 0
        self.step = StandardStepModel(choices: [], gameplay: .undefined, interface: .undefined)
    }

    init(_ index: Int, step: any StepModelProtocol) {
        self.index = index
        self.step = step
    }
}

public class StepManager {
    public var steps: [any StepModelProtocol]

    var currentStep = CurrentValueSubject<CurrentStep, Never>(CurrentStep())

    public init(steps: [any StepModelProtocol]) {
        self.steps = steps
        guard let firstStep = steps.first else {
            return
        }
        self.currentStep.send(CurrentStep(0, step: firstStep))
    }

    func nextStep() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            let currentStepIndex = self.currentStep.value.index + 1
            guard currentStepIndex < self.steps.count else { return }
            self.currentStep.send(CurrentStep(currentStepIndex, step: self.steps[currentStepIndex]))
        }
    }
}
