// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FullBeltSelector: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 300, height: 300)

            VStack {
                Image(systemName: "chevron.up")
                    .foregroundColor(.gray.opacity(0.7))
                Text("Front")
                    .foregroundColor(.gray.opacity(0.7))
                Spacer()
            }
            .padding(20)

            BeltSectionButton(section: .full, color: .red)
            EarButton(color: .blue)

        }
        .padding()
    }
}

struct FullBeltSelector_Previews: PreviewProvider {
    static var previews: some View {
        FullBeltSelector()
    }
}
