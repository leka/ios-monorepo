//
//  JobPickerStore.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 20/3/23.
//

import SwiftUI

struct JobPickerStore: View {
	
	@Binding var selectedJobs: [String]
	private func jobSelection(job: String) {
		if selectedJobs.contains(job) {
			selectedJobs.removeAll(where: {job == $0})
		} else {
			selectedJobs.append(job)
		}
	}
	
    var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 40) {
				let columns = Array(repeating: GridItem(), count: 3)
				LazyVGrid(columns: columns, spacing: 40) {
					ForEach(Professions.allCases) { job in
						Toggle(isOn: .constant(selectedJobs.contains(job.name))) {
							Text(job.name)
						}
						.toggleStyle(JobPickerToggleStyle(action: {
							jobSelection(job: job.name)
						}))
					}
				}
				.padding(.vertical, 30)
			}
		}
    }
}
