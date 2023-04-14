//
//  FourAnswersLayoutInline.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 1/4/23.
//

import SwiftUI

struct FourAnswersLayoutInline: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        HStack(spacing: defaults.horizontalCellSpacing) {
            ForEach(0..<4) { answer in
                CircularAnswerButton(answer: answer)
            }
        }
    }
}
