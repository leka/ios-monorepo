// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct JobPickerTriggerDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    @Binding var navigate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Profession(s)")
                .font(.body)
                .padding(.leading, 10)

            Button {
                self.navigate.toggle()
            } label: {
                self.buttonLabel
            }

            if !self.company.bufferTeacher.jobs.isEmpty {
                ForEach(self.company.bufferTeacher.jobs, id: \.self) { profession in
                    JobTagDeprecated(profession: profession)
                }
            }
        }
        .frame(width: 435)
    }

    // MARK: Private

    private var buttonLabel: some View {
        HStack(spacing: 0) {
            Text("Sélectionnez")
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .padding(10)
            Spacer()
            Image(systemName: "chevron.down")
                .padding(10)
        }
        .frame(width: 400, height: 44)
        .background(
            DesignKitAsset.Colors.lekaLightGray.swiftUIColor, in: RoundedRectangle(cornerRadius: self.metrics.btnRadius)
        )
    }
}
