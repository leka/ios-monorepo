//
//  XylophoneLayout.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 12/4/23.
//

import SwiftUI

struct XylophoneLayout: View {
	
	@EnvironmentObject var gameEngine: GameEngine
	@EnvironmentObject var defaults: GLT_Defaults
	
	@State private var colors: [Color] = [.green, .purple, .red, .yellow, .blue]
	@State private var showAlert: Bool = false
	
    var body: some View {
		HStack(spacing: defaults.xylophoneTilesSpacing) {
			ForEach($colors, id: \.self) { color in
				XylophoneTile(color: color)
			}
		}
        .onAppear {
            showAlert = true
        }
		.alert("Cette activité nécessite l'utilisation du robot !", isPresented: $showAlert) {
            alertContent
		} message: {
			Text("Avant de commencer l'activité, connectez-vous en Bluetooth à votre robot.")
		}
    }
    
    private var alertContent: some View {
        Group {
            Button(role: .destructive, action: {
                showAlert.toggle()
            }, label: {
                Text("Annuler")
            })
            
            Button(role: .none, action: {
                showAlert.toggle()
            }, label: {
                Text("Continuer sans le robot")
            })
            
            Button(role: .cancel, action: {
                showAlert.toggle()
            }, label: {
                Text("Me connecter")
                    .font(defaults.semi17)
                    .foregroundColor(.accentColor)
            })
        }
    }
}

struct XylophoneLayout_Previews: PreviewProvider {
    static var previews: some View {
        XylophoneLayout()
			.environmentObject(GLT_Defaults())
    }
}
