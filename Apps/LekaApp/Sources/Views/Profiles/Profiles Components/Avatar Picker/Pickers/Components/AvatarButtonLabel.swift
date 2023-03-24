//
//  AvatarButtonLabel.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 28/11/22.
//

import SwiftUI

// Avatar Buttons within the AvatarPicker()
struct AvatarButtonLabel: View {
    
    @EnvironmentObject var metrics:  UIMetrics
    
    @Binding var image: String
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: metrics.diameter, maxHeight: metrics.diameter)
                .background(.white)
                .mask(Circle())
            Circle()
                .strokeBorder(Color("lekaLightGray"), lineWidth: 2)
        }
        .frame(minWidth: metrics.diameter, maxWidth: metrics.diameter)
        .background(Color("lekaSkyBlue"),
                    in: Circle().inset(by: isSelected ? -7 : 2)
        )
        .animation(.default, value: isSelected)
    }
}
