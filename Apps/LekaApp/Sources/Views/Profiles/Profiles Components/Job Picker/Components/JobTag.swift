//
//  JobTag.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 30/12/22.
//

import SwiftUI

struct JobTag: View {
    
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics:  UIMetrics
    
    @State var job: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(job)
                .padding(.leading, 4)
            Button {
                company.bufferTeacher.jobs.removeAll(where: {job == $0})
            } label: {
                Image(systemName: "multiply.square.fill")
            }
        }
        .font(metrics.bold15)
        .foregroundColor(.white)
        .padding(5)
        .background(Color.accentColor,
                    in: RoundedRectangle(cornerRadius: 6, style: .circular))
    }
}

struct JobTag_Previews: PreviewProvider {
    static var previews: some View {
        JobTag(job: "Accompagnant des élèves en situation de handicap")
            .environmentObject(CompanyViewModel())
            .environmentObject(UIMetrics())
    }
}
