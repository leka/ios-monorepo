//
//  LekaLogo.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 3/4/23.
//

import SwiftUI

struct LekaLogo: View {
    var body: some View {
        HStack {
            Spacer()
            Image("leka")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("darkGray").opacity(0.2))
                .frame(height: 80)
                .padding(.vertical, 20)
            Spacer()
        }
        .listRowBackground(Color("lekaLightGray"))
    }
}
