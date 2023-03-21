//
//  Colors.swift
//  ColorQuest
//
//  Created by Hugo Pezziardi on 09/03/2023.
//

import Foundation
import SwiftUI

// From https://github.com/leka/leka-app/blob/develop/Libs/LKColors.swift

enum AppColor {
	static let green = Color(red: 0.0/255.0, green: 147.0/255.0, blue: 0.0/255.0)
	static let red = Color(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0)
	static let blue = Color(red: 19.0/255.0, green: 0.0/255.0, blue: 255.0/255.0)
	static let pink = Color(red: 255.0/255.0, green: 0.0/255.0, blue: 255.0/255.0)
	static let yellow = Color(red: 254.0/255.0, green: 255.0/255.0, blue: 0.0/255.0)
}

// To adapt
enum RobotColor {
	static let green: [UInt8] = [0, 147, 0]
	static let red: [UInt8] = [255, 0, 0]
	static let blue: [UInt8] = [19, 0, 255]
	static let pink: [UInt8] = [255, 0, 255]
	static let yellow: [UInt8] = [254, 255, 0]
}

struct LKColor {
	let app: Color
	let robot: [UInt8]
}

var colorDictionary = [
	"green": LKColor(app: AppColor.green, robot: RobotColor.green),
	"red": LKColor(app: AppColor.red, robot: RobotColor.red),
	"blue": LKColor(app: AppColor.blue, robot: RobotColor.blue),
	"pink": LKColor(app: AppColor.pink, robot: RobotColor.pink),
	"yellow": LKColor(app: AppColor.yellow, robot: RobotColor.yellow)
]
