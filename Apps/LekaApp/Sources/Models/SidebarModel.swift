//
//  SidebarModel.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 9/2/23.
//

import SwiftUI

// Navigation Sets
enum SidebarDestinations: Int, Identifiable, CaseIterable {
	case curriculums, activities, commands, stories, teachers, users

	var id: Self { self }
}

// Sidebar Sections
enum NavSections: Int, Identifiable, CaseIterable {
	case educ, followUp

	var id: Self { self }
}

// Sidebar UI Models
struct SectionLabel: Identifiable, Hashable {
	let id = UUID()
	let destination: SidebarDestinations
	let icon: String
	let label: String
	let has3Columns: Bool
}

struct ListModel: Identifiable, Hashable {
	let id = UUID()
	let title: String
	let sections: [SectionLabel]
}
