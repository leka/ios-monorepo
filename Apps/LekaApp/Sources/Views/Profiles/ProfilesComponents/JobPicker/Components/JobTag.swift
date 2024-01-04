// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - JobTag

struct JobTag: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    @State var profession: String

    var body: some View {
        HStack(spacing: 12) {
            Text(self.profession)
                .padding(.leading, 4)
            Button {
                self.company.bufferTeacher.jobs.removeAll(where: { self.profession == $0 })
            } label: {
                Image(systemName: "multiply.square.fill")
            }
        }
        .font(self.metrics.bold15)
        .foregroundColor(.white)
        .padding(5)
        .background(
            DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor,
            in: RoundedRectangle(cornerRadius: 6, style: .circular)
        )
    }
}

// MARK: - JobTag_Previews

struct JobTag_Previews: PreviewProvider {
    static var previews: some View {
        JobTag(profession: "Accompagnant des élèves en situation de handicap")
            .environmentObject(CompanyViewModel())
            .environmentObject(UIMetrics())
    }
}
