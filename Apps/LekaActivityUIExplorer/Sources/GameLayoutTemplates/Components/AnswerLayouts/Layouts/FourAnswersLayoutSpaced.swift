//
//  FourAnswersLayoutSpaced.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import SwiftUI

struct FourAnswersLayoutSpaced: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        Grid(horizontalSpacing: defaults.horizontalCellSpacing, verticalSpacing: defaults.verticalCellSpacing) {
            GridRow {
                CircularAnswerButton(answer: 0)
                Color.clear.frame(width: defaults.playGridBtnSize, height: 0)
                CircularAnswerButton(answer: 1)
            }
            GridRow {
                CircularAnswerButton(answer: 2)
                Color.clear.frame(width: defaults.playGridBtnSize, height: 0)
                CircularAnswerButton(answer: 3)
            }
        }
    }
}

struct FourAnswersLayoutSpaced_Previews: PreviewProvider {
    static var previews: some View {
        FourAnswersLayoutSpaced()
            .environmentObject(GameLayoutTemplatesDefaults())
            .environmentObject(GameLayoutTemplatesConfigurations())
            .environmentObject(GameEngine())
    }
}
