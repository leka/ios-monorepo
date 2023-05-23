//
//  GameplayKitView.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 23/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct GameplayKitView: View {
    @StateObject private var viewModel = GameplayKitVM()

    var body: some View {
        Button("State is \(viewModel.currentState)", action: viewModel.somethingHappens)
            .onAppear(perform: viewModel.setNewState)
    }
}

struct GameplayKitView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayKitView()
    }
}
