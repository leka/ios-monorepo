// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MainView: View {
    @State var count = 1

    var body: some View {
        Text("Hello, LogKit!")
            .onAppear {
                log.trace("This is a trace")
                log.debug("Hello, World from LogKitExample!")
                log.info("Some info perhaps?")
                log.warning("gosh! be careful")
                log.error("ooops... something went wrong")
                log.critical("WE MUST ABORT")
            }
            .onTapGesture {
                log.debug("touched \(count)")
                count += 1
            }
    }
}

#Preview {
    MainView()
}
