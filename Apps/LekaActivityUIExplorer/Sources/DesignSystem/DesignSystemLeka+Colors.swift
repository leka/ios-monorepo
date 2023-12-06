// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension DesignSystemLeka {

    struct ColorsSwiftUIView: View {

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Dark blue, light blue, green")
                        .font(.title2)
                    ColorSwiftUIView(color: Color(hex: 0xAFCE36))
                    ColorSwiftUIView(color: Color(hex: 0xCFEBFC))
                    ColorSwiftUIView(color: Color(hex: 0x0A579B))
                }
            }
            .navigationTitle("Leka SwiftUI colors")
        }
    }
}

#Preview {
    DesignSystemLeka.ColorsSwiftUIView()
}
