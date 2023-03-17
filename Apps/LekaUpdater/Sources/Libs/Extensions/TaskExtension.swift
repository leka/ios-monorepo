//
//  TaskExtension.swift
//  LekaUpdater
//
//  Created by Yann LOCATELLI on 12/12/2022.
//

import Foundation

extension Task where Success == Never, Failure == Never {

	static func sleep(seconds: Double) async throws {
		let duration = UInt64(seconds * 1_000_000_000)
		try await Task.sleep(nanoseconds: duration)
	}

}
