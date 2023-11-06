// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import RobotKit
import SwiftUI

struct ContentView: View {

    @State var presentRobotConnection: Bool = false

    var body: some View {
        NavigationStack {
            let columns = Array(repeating: GridItem(), count: 3)
            Button("Connect Robot") {
                print("connect robot")
                presentRobotConnection.toggle()
            }
            .foregroundStyle(.green)
            .font(.title3)

            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(kListOfAvailablesActivities) { activity in
                        NavigationLink {
                            activity.view
                        } label: {
                            VStack(spacing: 20) {
                                Image(systemName: "photo")
                                    .activityIconImageModifier(padding: 20)
                                Text(activity.title)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.accentColor)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: 200)
                            .padding(.bottom, 40)
                        }
                    }
                }
                .safeAreaInset(edge: .top) {
                    Color.clear
                        .frame(height: 40)
                }
            }
            .background(DesignKitAsset.Colors.lekaLightBlue.swiftUIColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) { navigationTitleView }
            }
        }
        .fullScreenCover(isPresented: $presentRobotConnection) {
            RobotConnectionView(viewModel: RobotConnectionViewModel())
        }
    }

    private var navigationTitleView: some View {
        HStack(spacing: 4) {
            Text("Leka Activity UI Explorer")
        }
        .font(.system(size: 17, weight: .bold))
        .foregroundColor(.accentColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
