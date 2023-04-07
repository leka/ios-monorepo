//
//  InteractionsView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 27/3/23.
//

import SwiftUI

struct InteractionsView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var configuration: GLT_Configurations

    var body: some View {
        VStack {
            Spacer()
            if gameEngine.allAnswers.count == 1 {
                OneAnswerLayout()
            } else if gameEngine.allAnswers.count == 2 {
                TwoAnswersLayout()
            } else if gameEngine.allAnswers.count == 3 {
                switch configuration.preferred3AnswersLayout {
                    case .inline: ThreeAnswersLayoutInline()
                    default: ThreeAnswersLayout()
                }
            } else if gameEngine.allAnswers.count == 4 {
                switch configuration.preferred4AnswersLayout {
                    case .inline: FourAnswersLayoutInline()
                    case .spaced: FourAnswersLayoutSpaced()
                    default: FourAnswersLayout()
                }
            } else if gameEngine.allAnswers.count == 6 {
                SixAnswersLayout()
            } else {
                Text("Sélectionner un modèle")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            VStack(alignment: .leading) {
                HStack {
                    if gameEngine.currentActivity.activityType == "listen_then_touch_to_select" {
                        PlaySoundButton()
                            .padding(40)
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        )
    }
}
