//
//  JobPickerTrigger.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 21/3/23.
//

import SwiftUI

struct JobPickerTrigger: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    @Binding var navigate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Profession(s)")
                .font(metrics.reg14)
                .foregroundColor(.accentColor)
                .padding(.leading, 10)

            Button {
                navigate.toggle()
            } label: {
                buttonLabel
            }

            if !company.bufferTeacher.jobs.isEmpty {
                ForEach(company.bufferTeacher.jobs, id: \.self) { profession in
                    JobTag(profession: profession)
                }
            }
        }
        .frame(width: 435)
    }

    private var buttonLabel: some View {
        HStack(spacing: 0) {
            Text("Sélectionnez")
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .padding(10)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(.accentColor)
                .padding(10)
        }
        .frame(width: 400, height: 44)
        .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: metrics.btnRadius))
    }
}
