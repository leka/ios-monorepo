// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import RobotKit
import SwiftUI

struct ContentView: View {
    // MARK: Internal

    @State var isConnectionSheetPresented: Bool = false
    @State var isActivityPresented: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Button {
                    self.isActivityPresented = true
                    let newgekyaml = Bundle.main.url(forResource: "new_gek_activity_tts", withExtension: "yml")
                    let content = try? String(contentsOf: newgekyaml!, encoding: .utf8)
                    log.debug("\(content ?? "No YAML file found")")
                    self.navigation.setCurrentActivity(NewActivity(yaml: content!)!)
                } label: {
                    Text("Touch To Select")
                }

                Button {
                    self.isActivityPresented = true
                    let newgekyaml = Bundle.main.url(forResource: "new_gek_activity_dnd_grid", withExtension: "yml")
                    let content = try? String(contentsOf: newgekyaml!, encoding: .utf8)
                    log.debug("\(content ?? "No YAML file found")")
                    self.navigation.setCurrentActivity(NewActivity(yaml: content!)!)
                } label: {
                    Text("Drag and Drop w/ Grid")
                }

                Button {
                    self.isActivityPresented = true
                    let newgekyaml = Bundle.main.url(forResource: "new_gek_activity_dnd_with_zones", withExtension: "yml")
                    let content = try? String(contentsOf: newgekyaml!, encoding: .utf8)
                    log.debug("\(content ?? "No YAML file found")")
                    self.navigation.setCurrentActivity(NewActivity(yaml: content!)!)
                } label: {
                    Text("Drag and Drop w/ Zones")
                }

                Button {
                    self.isActivityPresented = true
                    let newgekyaml = Bundle.main.url(forResource: "new_gek_activity_dnd_one_to_one", withExtension: "yml")
                    let content = try? String(contentsOf: newgekyaml!, encoding: .utf8)
                    log.debug("\(content ?? "No YAML file found")")
                    self.navigation.setCurrentActivity(NewActivity(yaml: content!)!)
                } label: {
                    Text("Drag and Drop One to One")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Connect to a Robot") {
                        self.isConnectionSheetPresented = true
                    }
                }
            }
        }
        .sheet(isPresented: self.$isConnectionSheetPresented) {
            NavigationStack {
                RobotConnectionView(viewModel: RobotConnectionViewModel())
                    .logEventScreenView(screenName: "robot_connection", context: .sheet)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .fullScreenCover(isPresented: self.$isActivityPresented) {
            YAMLActivities()
        }
    }

    // MARK: Private

    private var navigation: Navigation = .shared
}

#Preview {
    ContentView()
}
