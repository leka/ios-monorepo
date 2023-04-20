//
//  XylophoneTile.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 12/4/23.
//

import SwiftUI

struct XylophoneTile: View {
	
	@EnvironmentObject var gameEngine: GameEngine
	@EnvironmentObject var defaults: GLT_Defaults
	
	@Binding var color: Color
	
    var body: some View {
		Button(action: {
            // Play Sound HERE
        }, label: { color })
			.buttonStyle(XylophoneTileButtonStyle(color: color))
            .compositingGroup()
    }
}

// MARK: - Xylophone Tile Answer Button Style (Gameplay)
struct XylophoneTileButtonStyle: ButtonStyle {

    @EnvironmentObject var defaults: GLT_Defaults
	var color: Color

	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.overlay {
				VStack {
					Spacer()
					Circle()
						.fill(Color("xyloAttach"))
					Spacer()
					Circle()
						.fill(Color("xyloAttach"))
					Spacer()
				}
                .frame(width: 44)
			}
			.overlay {
				RoundedRectangle(cornerRadius: 7, style: .circular)
					.stroke(.black.opacity(configuration.isPressed ? 0.3 : 0), lineWidth: 20)
			}
			.clipShape(RoundedRectangle(cornerRadius: 7, style: .circular))
            .frame(width: defaults.xylophoneTileWidth, height: setSizeFromColor())
            .scaleEffect(configuration.isPressed ? defaults.xylophoneTilesScaleFeedback : 1,
                         anchor: .center)
			.rotationEffect(Angle(degrees: configuration.isPressed ? defaults.xylophoneTilesRotationFeedback : 0),
                            anchor: .center)
	}
	
	private func setSizeFromColor() -> CGFloat {
		switch color {
			case .blue: return 240
			case .yellow: return 300
			case .red: return 365
			case .purple: return 425
			default: return 490
		}
	}
}
