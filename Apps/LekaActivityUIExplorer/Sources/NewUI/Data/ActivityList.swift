// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

let kListOfAvailablesActivities: [ActivityModel] = [
    ActivityModel(
        title: "Test Activity #1",
        instructions: "This is a test",
        view: AnyView(TestActivity())
    ),
    ActivityModel(
        title: "Test Activity #2",
        instructions: "This is just another test",
        view: AnyView(TestActivity())
    ),
    ActivityModel(
        title: "Melody",
        instructions: "Play the song with Leka",
        view: AnyView(MelodyActivity())
    ),
    ActivityModel(
        title: "Hide and Seek",
        instructions: "Cache le robot quelque part dans la pièce. Suis ensuite les instructions. ",
        view: AnyView(HideAndSeekActivity())
    ),
    ActivityModel(
        title: "Dance Freeze",
        instructions: "Danse avec Leka au rythme de la musique et faits la statue lorsqu’il s’arrête ",
        view: AnyView(DanceFreezeActivity())
    ),
    ActivityModel(
        title: "Remote Standard",
        instructions: "Contrôle Leka avec la télécommande et fais le changer de couleur",
        view: AnyView(RemoteStandardActivity())
    ),
    ActivityModel(
        title: "Remote Arrow",
        instructions: "Contrôle Leka avec la télécommande et fais le changer de couleur",
        view: AnyView(RemoteArrowActivity())
    ),
    ActivityModel(
        title: "TouchToSelectThree",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectThreeInlineActivity())
    ),
    ActivityModel(
        title: "TouchToSelectSix",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectSixActivity())
    ),
]
