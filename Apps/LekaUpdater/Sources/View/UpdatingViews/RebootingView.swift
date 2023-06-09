// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RebootingView: View {
    var body: some View {
        VStack {
            Text("Installation de la mise à jour")
                .font(.title2)
                .bold()

            ProgressView()
                .scaleEffect(2)
                .padding()
                .padding()

            Text("Votre robot redémarrera dans quelques minutes")
        }
    }
}

struct RebootingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RebootingView()
        }
    }
}
