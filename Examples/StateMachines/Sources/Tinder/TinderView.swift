//
//  TinderView.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 19/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct TinderView: View {
    @StateObject private var viewModel = TinderVM()

    var body: some View {
        Button("State is \(viewModel.currentState)", action: viewModel.somethingHappens)
            .onAppear(perform: viewModel.setNewState)
    }
}

struct TinderView_Previews: PreviewProvider {
    static var previews: some View {
        TinderView()
    }
}
