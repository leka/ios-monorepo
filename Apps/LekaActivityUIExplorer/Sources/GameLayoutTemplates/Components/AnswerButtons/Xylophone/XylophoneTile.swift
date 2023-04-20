//
//  XylophoneTile.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 12/4/23.
//

import SwiftUI

struct XylophoneTile: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @Binding var color: Color

    var body: some View {
        Button(
            action: {
                // Play Sound HERE
            }, label: { color }
        )
        .buttonStyle(XylophoneTileButtonStyle(color: color))
        .compositingGroup()
    }
}
