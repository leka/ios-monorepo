//
//  GoButton.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 19/11/22.
//

import SwiftUI

struct GoButton: View {

    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var company: CompanyViewModel

    var action: () -> Void

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                Button {
                    action()
                } label: {
                    goButtonLabel
                }
                .background(Color("lekaLightGray"), in: Circle())
                .padding(.trailing, 40)
            }
            .offset(y: -40)
            Spacer()
        }
    }

    private var goButtonLabel: some View {
        ZStack {
            Circle()
                .inset(by: 6)
                .fill(Color("btnLightBlue"))
                .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 2.5)
            Circle()
                .inset(by: 8)
                .fill(Color.accentColor)
                .shadow(color: .black.opacity(0.2), radius: 2.5, x: 0, y: 2.6)
            Circle()
                .inset(by: 15)
                .stroke(.white, lineWidth: 2)
            Text("GO !")
                .foregroundColor(.white)
                .font(.system(size: 34, weight: .bold, design: .rounded))
        }
        .frame(width: 127, height: 127)
        .compositingGroup()
    }
}
