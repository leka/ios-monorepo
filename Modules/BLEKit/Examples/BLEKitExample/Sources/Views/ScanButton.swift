// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

struct ScanButton: View {

    // MARK: - Environment variables

    @EnvironmentObject var robotListViewModel: RobotListViewModel

    // MARK: - Public views

    var body: some View {
        Button {
            robotListViewModel.scanForPeripherals()
        } label: {
            Group {
                HStack(spacing: 10) {
                    if !robotListViewModel.isScanning {
                        Text("Start scanning")
                            .font(.headline)
                            .foregroundColor(.white)

                    } else {
                        ZStack(alignment: .leading) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .offset(x: -25)
                            Text("Stop scanning")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(!robotListViewModel.isScanning ? .blue : .orange)
            .cornerRadius(10)
        }
    }
}

struct ScanButton_Previews: PreviewProvider {
    //    static let bleManager = BLEManager.live()
    static var previews: some View {
        ScanButton()
            .environmentObject(RobotListViewModel.mock())
    }
}
