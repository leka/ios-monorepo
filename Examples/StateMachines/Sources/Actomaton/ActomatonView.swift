//
//  ActomatonView.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 23/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct ActomatonView: View {
    @StateObject private var viewModel = ActomatonVM()

    var body: some View {
        Button("State is \(viewModel.currentState)", action: viewModel.somethingHappens)
            .onAppear(perform: viewModel.setNewState)
    }
}

struct ActomatonView_Previews: PreviewProvider {
    static var previews: some View {
        ActomatonView()
    }
}
