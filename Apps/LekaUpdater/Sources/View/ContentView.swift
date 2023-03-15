//
//  ContentView.swift
//  ios-leka_update
//
//  Created by Yann LOCATELLI on 20/09/2022.
//

import SwiftUI

struct ContentView: View {
    let os_version: String = Bundle.main.object(forInfoDictionaryKey: "os_version") as! String

    @StateObject var robot_manager = RobotManager()

    @State private var selected_robot_index = 0

    var body: some View {
        VStack {
            Image("leka-logo")
                .resizable()
                .aspectRatio(CGSize(width: 1000, height: 715), contentMode: .fit)
                .frame(maxHeight: 100)

            VStack {
                VStack {
                    HStack {
                        Text("Robot")
                        Picker("Robot", selection: $selected_robot_index, content: {
                            ForEach(0..<robot_manager.robots.count, id: \.self, content: { robot_index in
                                Text(robot_manager.robots[robot_index].name).tag(robot_index)
                            })
                        }).disabled(robot_manager.robot_connected != nil)
                            .frame(width: 250)
                        Button(robot_manager.robot_connected == nil ? "Connection" : "Disconnection") {
                            if robot_manager.robot_connected != nil {
                                robot_manager.disconnect()
                            } else if !robot_manager.robots.isEmpty {
                                robot_manager.connect(to: robot_manager.robots[selected_robot_index])
                            }
                        }
                        .disabled(robot_manager.robots.isEmpty)
                        Text("Connected ✔")
                            .foregroundColor(Color.gray)
                            .opacity(robot_manager.robot_connected == nil ? 0 : 1)
                    }
                }.padding()// (ConnectionView)

                VStack {
                    List {
                        Text(robot_manager.robot_connected == nil ?
                             robot_manager.robots.isEmpty ? "Name: -" : "Name: (\(robot_manager.robots[selected_robot_index].name))" :
                                "Name: \(robot_manager.robot_connected!.name)")
                        Text(robot_manager.robot_connected == nil ?
                             robot_manager.robots.isEmpty ? "Battery: -" : "Battery: (\(robot_manager.robots[selected_robot_index].battery))" :
                                "Battery: \(robot_manager.robot_connected!.battery)")
                        Text(robot_manager.robot_connected == nil ?
                             robot_manager.robots.isEmpty ? "In charge: -" : robot_manager.robots[selected_robot_index].is_charging ? "In charge: (yes)" : "In charge: (no)" :
                                robot_manager.robot_connected!.is_charging ? "In charge: yes" : "In charge: no")
                        Text(robot_manager.robot_connected == nil ?
                             robot_manager.robots.isEmpty || robot_manager.robots[selected_robot_index].os_version == nil ? "Version: -" : "Version: (\(robot_manager.robots[selected_robot_index].os_version!))" :
                                robot_manager.robot_connected!.os_version == nil ? "Version: -" :
                                "Version: \(robot_manager.robot_connected!.os_version!)")
                    }
                }.padding() // (RobotInformationView)

                VStack {
                    HStack {
                        Button("Start update process (v\(os_version))") {
                            robot_manager.applyUpdate()
                        }
                        .disabled(robot_manager.robot_connected == nil ||
                                  robot_manager.robot_connected!.os_version == nil ||
                                  robot_manager.robot_connected!.os_version!.compare(os_version, options: .numeric) != .orderedAscending ||
                                  robot_manager.sending_file_progression > 0
                        )
                        .alert(isPresented: Binding<Bool>(
                            get: {() -> Bool in
                                robot_manager.is_sending_file_and_not_charging || robot_manager.applying_update_fail
                            },
                            set: {(_) -> Void in
                                robot_manager.is_sending_file_and_not_charging = false
                                robot_manager.applying_update_fail = false
                            }
                        )) {
                            if robot_manager.is_sending_file_and_not_charging {
                                return Alert(title: Text("⚠️ WARNING ⚠️\nRobot not in charge."))
                            } else {
                                return Alert(title: Text("Oops!... 🙁\nSomething's wrong..."),
                                             message: Text("The update process failed, please try again"))
                            }
                        }
                        ProgressView(value: robot_manager.sending_file_progression)
                            .opacity(robot_manager.sending_file_progression > 0 ? 1 : 0)
                        Text(robot_manager.sending_file_is_paused ? "Update paused,\nwill resume shortly" : "Rebooting...")
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.center)
                            .opacity(robot_manager.sending_file_progression >= 1 || robot_manager.sending_file_is_paused ? 1 : 0 )
                    }
                    Text("To start the update process, the robot must be charging and have at least 30% of battery.")
                        .foregroundColor(Color.gray)
                        .font(.footnote)
                    Text("⚠️ Please keep the \"Emergency Stop 🛑\" magic card nearby during update process, to reboot the robot in case of failure ⚠️")
                        .foregroundColor(Color.red)
                        .font(.footnote)
                    Text(robot_manager.errorMessage)
                        .foregroundColor(Color.red)
                }.padding() // (UpdateView)

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
