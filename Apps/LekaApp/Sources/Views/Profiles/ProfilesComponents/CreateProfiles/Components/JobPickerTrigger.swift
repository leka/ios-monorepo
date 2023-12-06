// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct JobPickerTrigger: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    @Binding var navigate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Profession(s)")
                .font(metrics.reg14)
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .padding(.leading, 10)

            Button {
                navigate.toggle()
            } label: {
                buttonLabel
            }

            if !company.bufferTeacher.jobs.isEmpty {
                ForEach(company.bufferTeacher.jobs, id: \.self) { profession in
                    JobTag(profession: profession)
                }
            }
        }
        .frame(width: 435)
    }

    private var buttonLabel: some View {
        HStack(spacing: 0) {
            Text("Sélectionnez")
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .padding(10)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                .padding(10)
        }
        .frame(width: 400, height: 44)
        .background(
            DesignKitAsset.Colors.lekaLightGray.swiftUIColor, in: RoundedRectangle(cornerRadius: metrics.btnRadius))
    }
}
