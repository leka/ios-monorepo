//
//  NavigationManager.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {

	@Published var diplaysEditor: Bool = true
	@Published var sidebarVisibility = NavigationSplitViewVisibility.all

}
