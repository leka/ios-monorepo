//
//  PeterRingsetView.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 24/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct PeterRingsetView: View {
    @StateObject private var viewModel = PeterRingsetVM()

    var body: some View {
        Button("State is \(viewModel.currentState)", action: viewModel.somethingHappens)
            .onAppear(perform: viewModel.setNewState)
    }
}

struct PeterRingsetView_Previews: PreviewProvider {
    static var previews: some View {
        PeterRingsetView()
    }
}
