// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - JobTagDeprecated

struct JobTagDeprecated: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated
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
        // TODO: (@ui/ux) - Design System - replace with Leka font
        .font(.footnote)
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
        JobTagDeprecated(profession: "Accompagnant des élèves en situation de handicap")
            .environmentObject(CompanyViewModelDeprecated())
            .environmentObject(UIMetrics())
    }
}
