//
//  DanceFreezeNavigationGroup.swift
//  LekaActivityUIExplorer
//
//  Created by Hugo Pezziardi on 30/06/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct DanceFreezeNavigationGroup: View {
    var body: some View {
        LazyVGrid(columns: [GridItem()]) {
            ForEach(DanceFreezePreviews.allCases, id: \.rawValue) { item in
                PreviewButton(item: .constant(item))
            }
        }
        .padding(20)
    }
}
