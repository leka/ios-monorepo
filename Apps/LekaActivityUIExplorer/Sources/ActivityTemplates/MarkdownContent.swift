//
//  MarkdownContent.swift
//  LekaActivityUIExplorer
//
//  Created by Ladislas de Toldi on 13/04/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Foundation

extension String {

    public static var markdownInstructionsFR: String = """
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

    public static var markdownInstructionsEN: String = """
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

}
