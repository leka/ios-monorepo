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
        title: "TouchToSelectOne",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectOneChoiceActivity())
    ),
    ActivityModel(
        title: "TouchToSelectTwo",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectTwoChoicesActivity())
    ),
    ActivityModel(
        title: "TouchToSelectThree",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectThreeChoicesActivity())
    ),
    ActivityModel(
        title: "TouchToSelectThreeInline",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectThreeChoicesInlineActivity())
    ),
    ActivityModel(
        title: "TouchToSelectFour",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectFourChoicesActivity())
    ),
    ActivityModel(
        title: "TouchToSelectFourInline",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectFourChoicesInlineActivity())
    ),
    ActivityModel(
        title: "TouchToSelectFive",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectFiveChoicesActivity())
    ),
    ActivityModel(
        title: "TouchToSelectSix",
        instructions: "Touch the right answer",
        view: AnyView(TouchToSelectSixChoicesActivity())
    ),
    ActivityModel(
        title: "ListenThenTouchToSelectOne",
        instructions: "Listen then touch the right answer",
        view: AnyView(ListenThenTouchToSelectOneChoiceActivity())
    ),
    ActivityModel(
        title: "ListenThenTouchToSelectTwo",
        instructions: "Listen then touch the right answer",
        view: AnyView(ListenThenTouchToSelectTwoChoicesActivity())
    ),
    ActivityModel(
        title: "ListenThenTouchToSelectThree",
        instructions: "Listen then touch the right answer",
        view: AnyView(ListenThenTouchToSelectThreeChoicesActivity())
    ),
    ActivityModel(
        title: "ListenThenTouchToSelectThreeInline",
        instructions: "Listen then touch the right answer",
        view: AnyView(ListenThenTouchToSelectThreeChoicesInlineActivity())
    ),
    ActivityModel(
        title: "ListenThenTouchToSelectFour",
        instructions: "Listen then touch the right answer",
        view: AnyView(ListenThenTouchToSelectFourChoicesActivity())
    ),
    ActivityModel(
        title: "ListenThenTouchToSelectSix",
        instructions: "Listen then touch the right answer",
        view: AnyView(ListenThenTouchToSelectSixChoicesActivity())
    ),
    ActivityModel(
        title: "Xylophone",
        instructions: "Play xylophone with Leka",
        view: AnyView(XylophoneActivity())
    ),
    ActivityModel(
        title: "Pairing",
        instructions: "Start sequence and observe the user's behavior interacting with Leka",
        view: AnyView(PairingActivity())
    ),
    ActivityModel(
        title: "ColorBingo - Lvl 1",
        instructions: "Touch the right color",
        view: AnyView(ColorBingoLevelOne())
    ),
    ActivityModel(
        title: "ColorBingo - Lvl 2",
        instructions: "Touch the right color",
        view: AnyView(ColorBingoLevelTwo())
    ),
    ActivityModel(
        title: "ColorBingo - Lvl 3",
        instructions: "Touch the right color",
        view: AnyView(ColorBingoLevelThree())
    ),
    ActivityModel(
        title: "SuperSimon - Lvl 1",
        instructions: "Touch the right color sequence",
        view: AnyView(SuperSimonLevelOne())
    ),
    ActivityModel(
        title: "SuperSimon - Lvl 2",
        instructions: "Touch the right color sequence",
        view: AnyView(SuperSimonLevelTwo())
    ),
    ActivityModel(
        title: "SuperSimon - Lvl 3",
        instructions: "Touch the right color sequence",
        view: AnyView(SuperSimonLevelThree())
    ),
    ActivityModel(
        title: "DragAndDropOneZoneOneChoice",
        instructions: "Drag and drop the fruit in the basket",
        view: AnyView(DragAndDropOneZoneOneChoiceActivity())
    ),
    ActivityModel(
        title: "DragAndDropOneZoneTwoChoices",
        instructions: "Drag and drop the fruit in the basket",
        view: AnyView(DragAndDropOneZoneTwoChoicesActivity())
    ),
    ActivityModel(
        title: "DragAndDropOneZoneThreeChoices",
        instructions: "Drag and drop the fruit in the basket",
        view: AnyView(DragAndDropOneZoneThreeChoicesActivity())
    ),
    ActivityModel(
        title: "DragAndDropOneZoneFourChoices",
        instructions: "Drag and drop the fruit in the basket",
        view: AnyView(DragAndDropOneZoneFourChoicesActivity())
    ),
    ActivityModel(
        title: "DragAndDropTwoZonesThreeChoices",
        instructions: "Drag and drop all the fruits in the right place",
        view: AnyView(DragAndDropTwoZonesThreeChoicesActivity())
    ),
]
