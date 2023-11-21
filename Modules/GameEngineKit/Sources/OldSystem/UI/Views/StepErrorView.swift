// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct StepErrorView: View {

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
            Text("Oops ... Data has not been found")
                .font(.title)
        }
    }
}

struct StepErrorView_Previews:
    PreviewProvider
{
    static var previews: some View {
        StepErrorView()
    }
}
