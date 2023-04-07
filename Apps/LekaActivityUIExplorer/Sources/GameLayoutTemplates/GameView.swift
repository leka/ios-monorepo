//
//  GLT_LayoutComposer.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/3/23.
//

import SwiftUI

struct GameView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GLT_Defaults

    var body: some View {
        ZStack(alignment: .top) {
            GameBackgroundView()

            VStack(spacing: 0) {
                if !gameEngine.currentActivity.stepSequence[0].isEmpty {
                    ProgressBar().padding(.bottom, defaults.headerSpacing)
                }
                StepInstructionsButton()
                InteractionsView()
            }
            .padding(.top, defaults.headerPadding)
        }
    }
}
