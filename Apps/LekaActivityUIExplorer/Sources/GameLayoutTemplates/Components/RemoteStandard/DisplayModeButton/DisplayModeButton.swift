//
//  DisplayModeButton.swift
//  LekaActivityUIExplorer
//
//  Created by Hugo Pezziardi on 12/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct DisplayModeButton: View {
    var mode: DisplayMode
    @Binding var displayMode: DisplayMode

    @State private var buttonPressed = false

    var body: some View {
        Button {
            displayMode = mode
        } label: {
            switch mode {
                case .oneBeltSection:
                    OneBeltSectionImage()
                case .twoBeltSection:
                    TwoBeltSectionImage()
                case .fourBeltSection:
                    FourBeltSectionImage()
            }
        }
        .background(DisplayModelFeedback(backgroundDimension: displayMode == mode ? 80 : 0))
    }
}

struct DisplayModeButton_Previews: PreviewProvider {

    static var previews: some View {
        DisplayModeButton(mode: .fourBeltSection, displayMode: .constant(.fourBeltSection))
    }
}
