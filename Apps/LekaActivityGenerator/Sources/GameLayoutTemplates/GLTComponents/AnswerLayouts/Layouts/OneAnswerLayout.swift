//
//  OneAnswerLayout.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 27/3/23.
//

import SwiftUI

struct OneAnswerLayout: View {
	var body: some View {
		HStack {
			Spacer()
			CircularAnswerButton(answer: 0)
			Spacer()
		}
	}
}
