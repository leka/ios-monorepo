//
//  StepMarker.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/3/23.
//

import SwiftUI

struct StepMarker: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @Binding var color: Color

    var body: some View {
        Circle()
            .fill(
                color,
                strokeBorder: .white,
                lineWidth: defaults.stepMarkerBorderWidth
            )
            .background(.white, in: Circle())
            .padding(defaults.stepMarkerPadding)
    }
}
