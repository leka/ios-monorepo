// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

//
//  InstructionView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/12/22.
//

// TODO(@ladislas): reimport when Down is fixed
// import Down
import SwiftUI

struct InstructionsView: View {

    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            //			instructions_OLD
            instructionsMarkdownView
        }
        .safeAreaInset(edge: .top) {
            instructionTitle
        }
    }

    @ViewBuilder
    private var instructionsMarkdownView: some View {
        //		Text(activityVM.getInstructions())
        DownAttributedString(text: activityVM.getInstructions())
            //		MarkdownRepresentable(height: .constant(.zero))
            .environmentObject(MarkdownObservable(text: activityVM.getInstructions()))
            .padding()
            .frame(minWidth: 450, maxWidth: 550)
    }

    private var instructionTitle: some View {
        HStack {
            Spacer()
            Text("DESCRIPTION & INSTALLATION")
                .font(metrics.reg18)
                .foregroundColor(Color("darkGray").opacity(0.8))
                .padding(.vertical, 22)
            Spacer()
        }
        .padding(.top, 30)
        .background(Color("lekaLightGray"))
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
            .environmentObject(UIMetrics())
            .environmentObject(ActivityViewModel())
    }
}
