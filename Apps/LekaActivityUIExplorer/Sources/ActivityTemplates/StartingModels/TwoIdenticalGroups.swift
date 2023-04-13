//
//  TwoIdenticalGroups.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import Foundation

class TwoIdenticalGroups: ObservableObject {

    func makeEmptyActivity() -> Activity {
        return Activity(
            id: UUID(),
            title: emptyTitle,
            short: emptyShort,
            instructions: emptyInstructions(),
            activityType: "touch_to_select",
            stepsAmount: 6,
            isRandom: false,
            numberOfImages: 1,
            randomAnswerPositions: false,
            stepSequence: makeEmptyStepArray())
    }

    // MARK: - Empty Activity Values
    var emptyTitle = LocalizedContent(
        enUS: "2 groups Sequence",
        frFR: "Séquence de 2 groupes"
    )

    var emptyShort = LocalizedContent(
        enUS: "Subject - 1",
        frFR: "Sujet - 1"
    )

    func emptyInstructions() -> LocalizedContent {
        return LocalizedContent(
            enUS: markdownInstructionsEN,
            frFR: markdownInstructionsFR)
    }

    var markdownInstructionsFR: String = """
        ## Objectif

        Écrire l'objectif ici.

        ## Matériel

        Écrire le matériel ici.

        ## Préparation de la séance

        Écrire la préparation ici.

        ## Déroulé

        1. Première étape
        1. Deuxième étape
        1. Troisième étape
        1. Quatrième étape
        1. **Cinquième** étape

        ## Séquence

        Répétez le déroulé **X fois**.

        ## Validation de la leçon

        La leçon est validée lorsque **X images sur Y** ont été bien sélectionnées.

        """

    var markdownInstructionsEN: String = """
        ## Goal

        Write the goal here.

        ## Equipment

        Write the equipment here.

        ## Preparation of the session

        Write the preparation here.

        ## Steps

        1. First step
        1. Second step
        1. Third step
        1. Fourth step
        1. **Fifth** step

        ## Sequence

        Repeat the steps **X times**.

        ## How to validate the lesson

        The lesson is validated when **X images out of Y** have been correctly selected.

        """

    func emptyStep() -> Step {
        return Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers2, sound: nil)
    }

    func makeEmptyStepArray() -> [[Step]] {
        return [
            [
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers2, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers2, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers2, sound: nil),
            ],
            [
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers4, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers4, sound: nil),
                Step(instruction: stepInstruction(), correctAnswer: "dummy_1", allAnswers: stepAnswers4, sound: nil),
            ],
        ]
    }

    var stepAnswers2 = ["dummy_1", "dummy_2"]
    var stepAnswers4 = ["dummy_1", "dummy_2", "dummy_3", "dummy_4"]

    func stepInstruction() -> LocalizedContent {
        return LocalizedContent(
            enUS: stepInstructionEN,
            frFR: stepInstructionFR)
    }

    var stepInstructionFR: String = "Touche le numéro 1"
    var stepInstructionEN: String = "Touch the number 1"
}
