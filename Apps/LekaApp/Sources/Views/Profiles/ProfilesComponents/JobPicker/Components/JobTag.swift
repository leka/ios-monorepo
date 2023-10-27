// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct JobTag: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    @State var profession: String

    var body: some View {
        HStack(spacing: 12) {
            Text(profession)
                .padding(.leading, 4)
            Button {
                company.bufferTeacher.jobs.removeAll(where: { profession == $0 })
            } label: {
                Image(systemName: "multiply.square.fill")
            }
        }
        .font(metrics.bold15)
        .foregroundColor(.white)
        .padding(5)
        .background(
            DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
            in: RoundedRectangle(cornerRadius: 6, style: .circular))
    }
}

struct JobTag_Previews: PreviewProvider {
    static var previews: some View {
        JobTag(profession: "Accompagnant des élèves en situation de handicap")
            .environmentObject(CompanyViewModel())
            .environmentObject(UIMetrics())
    }
}
