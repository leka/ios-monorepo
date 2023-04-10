//
//  DeleteProfileButton.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 21/3/23.
//

import SwiftUI

struct DeleteProfileButton: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    @Binding var show: Bool

    var body: some View {
        if company.editingProfile {
            Button {
                show.toggle()
            } label: {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("Supprimer le profil")
                }
                .padding(.horizontal, 20)
            }
            .buttonStyle(BorderedCapsule_NoFeedback_ButtonStyle(font: metrics.reg17, color: Color.red))
            .padding(.vertical, 10)
        } else {
            EmptyView()
        }
    }
}
