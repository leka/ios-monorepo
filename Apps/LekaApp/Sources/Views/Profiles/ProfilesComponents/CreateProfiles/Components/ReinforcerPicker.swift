// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ReinforcerPicker: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        if self.company.editingProfile {
            VStack(spacing: 10) {
                HStack {
                    Text("Choix du renforçateur")
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.body)
                        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                        .padding(.leading, 10)
                    Spacer()
                }
                HStack {
                    Text( // swiftlint:disable:next line_length
                        "Le renforçateur est un effet lumineux répétitif du robot que vous pourrez actionner pour récompenser le comportement de l'utilisateur. \nSi votre robot est connecté, vous pouvez tester les renforçateurs avant d'en choisir un."
                    )
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.footnote)
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .padding(.leading, 10)
                    Spacer()
                }

                // ReinforcerPicker
                VStack(spacing: 4) {
                    HStack(spacing: 12) {
                        ForEach(1...3, id: \.self) { item in
                            self.reinforcerButton(item)
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 114)

                    HStack(spacing: 12) {
                        ForEach(4...5, id: \.self) { item in
                            self.reinforcerButton(item)
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 114)
                }
                .frame(width: 410, height: 271, alignment: .center)
            }
            .frame(width: 420)
            .animation(.default, value: self.company.bufferUser.reinforcer)
        } else {
            EmptyView()
        }
    }

    func reinforcerButton(_ number: Int) -> some View {
        Button {
            self.company.bufferUser.reinforcer = number
        } label: {
            Image("reinforcer-\(number)")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 108, maxHeight: 108)
                .padding(10)
        }
        .background(
            Circle()
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
        )
        .background(
            DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor,
            in: Circle().inset(by: self.company.bufferUser.reinforcer == number ? -6 : 2)
        )
    }
}
