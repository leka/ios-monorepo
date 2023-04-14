// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct LekaLogo: View {
    var body: some View {
        HStack {
            Spacer()
            Image("leka")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("darkGray").opacity(0.2))
                .frame(height: 80)
                .padding(.vertical, 20)
            Spacer()
        }
        .listRowBackground(Color("lekaLightGray"))
    }
}
