// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SwiftUI

struct ContentView: View {
    @State private var viewOrder: Int = 1

    var body: some View {
        NavigationSplitView {
            List {
                Button("Show view 1") {
                    viewOrder = 1
                }
                Button("Show view 2") {
                    viewOrder = 2
                }
                Button("Show view 3") {
                    viewOrder = 3
                }
            }
        } detail: {
            ZStack {
                View1()
                    .opacity(viewOrder == 1 ? 1 : 0)
                View2()
                    .opacity(viewOrder == 2 ? 1 : 0)

                View3()
                    .opacity(viewOrder == 3 ? 1 : 0)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct View1: View {

    @State var value: Int = 0

    init() {
        print("View1 init")
    }

    var body: some View {
        ZStack {
            Rectangle().fill(Color.red).edgesIgnoringSafeArea(.all)
            Text("Value: \(value)")
                .foregroundColor(.white)
                .font(.title)
                .onTapGesture {
                    value += 1
                }
                .onAppear {
                    print("View 1 Text appeared")
                }
        }
        .onTapGesture {
            print("View1 tapped")
        }
        .onAppear {
            print("View1 appeared")
        }
    }
}

struct View2: View {
    @State var value: Int = 0

    init() {
        print("View2 init")
    }
    var body: some View {
        ZStack {
            Rectangle().fill(Color.green).edgesIgnoringSafeArea(.all)
            Text("Value: \(value)")
                .foregroundColor(.white)
                .font(.title)
                .onTapGesture {
                    value += 1
                }
                .onAppear {
                    print("View 2 Text appeared")
                }
        }

        .onTapGesture {
            print("View2 tapped")
        }
        .onAppear {
            print("View2 appeared")
        }
    }
}

struct View3: View {
    @State var value: Int = 0

    init() {
        print("View3 init")
    }

    var body: some View {
        ZStack {
            Rectangle().fill(Color.blue).edgesIgnoringSafeArea(.all)
            Text("Value: \(value)")
                .foregroundColor(.white)
                .font(.title)
                .onTapGesture {
                    value += 1
                }
                .onAppear {
                    print("View 3 Text appeared")
                }
        }
        .onTapGesture {
            print("View3 tapped")
        }
        .onAppear {
            print("View3 appeared")
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
