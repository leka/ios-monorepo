// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Fuzzy match algorithm heavily inspired by:
// https://github.com/junegunn/fzf/blob/master/src/algo/algo.go
// junegunn/fzf License: MIT

// swiftlint:disable identifier_name cyclomatic_complexity function_body_length

import Foundation

// MARK: - Result

public struct Result {
    public var start: Int
    public var end: Int
    public var score: Int
}

// MARK: - FuzzyMatch

public func fuzzyMatch(input: String, pattern: String, normalized: Bool = true) -> Result {
    var _input = normalized ? input.normalized() : input
    var _pattern = normalized ? pattern.normalized() : pattern

    let n = input.count
    let m = pattern.count

    guard m > 0 else {
        return Result(start: 0, end: 0, score: 0)
    }

    if m == 1 {
        return exactMatchNaive(text: _input, pattern: _pattern)
    }

    // Phase 1: Matching and bonus calculation
    var pidx = 0
    var lastIDx = 0
    var prevClass: CharClass = .charNonWord
    var bonuses = Array(repeating: Int16(0), count: n)
    var t = Array(repeating: Character(" "), count: n)

    for (idx, char) in _input.enumerated() {
        let class_ = charClassOf(char)
        var adjustedChar = char

        t[idx] = adjustedChar
        bonuses[idx] = bonusFor(prevClass, class_)
        prevClass = class_

        if pidx < m, adjustedChar == _pattern[_pattern.index(_pattern.startIndex, offsetBy: pidx)] {
            lastIDx = idx
            pidx += 1
        }
    }

    guard pidx == m else {
        return Result(start: -1, end: -1, score: 0)
    }

    // Phase 2: Scoring
    let width = lastIDx + 1
    var h = Array(repeating: Int16(0), count: width * m)
    var c = Array(repeating: Int16(0), count: width * m)
    var maxScore: Int16 = 0
    var maxScorePos = 0

    for i in 0..<m {
        let I = i * width
        var inGap = false

        for j in 0...lastIDx {
            let j0 = j
            var s1: Int16 = 0
            var s2: Int16 = 0
            var consecutive: Int16 = 0

            if j > 0 {
                if inGap {
                    s2 = h[I + j0 - 1] + Int16(scoreGapExtension)
                } else {
                    s2 = h[I + j0 - 1] + Int16(scoreGapStart)
                }
            }

            if _pattern[_pattern.index(_pattern.startIndex, offsetBy: i)] == t[j] {
                var diag: Int16 = 0
                if i > 0, j0 > 0 {
                    diag = h[I - width + j0 - 1]
                }
                s1 = diag + Int16(scoreMatch)
                var b = bonuses[j]

                if i > 0, j0 > 0 {
                    consecutive = c[I - width + j0 - 1] + 1
                    if b == Int16(bonusBoundary) {
                        consecutive = 1
                    } else if consecutive > 1 {
                        b = max(b, max(Int16(bonusConsecutive), bonuses[j - Int(consecutive) + 1]))
                    }
                } else {
                    consecutive = 1
                    b *= Int16(bonusFirstCharMultiplier)
                }

                if s1 + b < s2 {
                    s1 += bonuses[j]
                    consecutive = 0
                } else {
                    s1 += b
                }
            }
            c[I + j0] = consecutive
            inGap = s1 < s2
            let score = max(s1, max(s2, 0))

            if i == m - 1, score > maxScore {
                maxScore = score
                maxScorePos = j
            }
            h[I + j0] = score
        }
    }

    return Result(start: 0, end: maxScorePos + 1, score: Int(maxScore))
}

private func exactMatchNaive(text: String, pattern: String) -> Result {
    let lenRunes = text.count
    let lenPattern = pattern.count

    guard lenRunes >= lenPattern else {
        return Result(start: -1, end: -1, score: 0)
    }

    var pidx = 0
    var bestPos = -1
    var bonus: Int16 = 0
    var bestBonus: Int16 = -1

    for (index, char) in text.enumerated() {
        var adjustedChar = char

        if adjustedChar == pattern[pattern.index(pattern.startIndex, offsetBy: pidx)] {
            bonus = bonusFor(.charNonWord, charClassOf(adjustedChar))
            if bonus > bestBonus {
                bestPos = index
                bestBonus = bonus
            }
            pidx += 1
            if pidx == lenPattern {
                break
            }
        }
    }

    if bestPos != -1 {
        return Result(start: bestPos, end: bestPos + lenPattern, score: Int(bestBonus))
    }

    return Result(start: -1, end: -1, score: 0)
}

private func charClassOf(_ char: Character) -> CharClass {
    if char.isLowercase {
        return .charLower
    } else if char.isUppercase {
        return .charUpper
    } else if char.isNumber {
        return .charNumber
    } else if char.isLetter {
        return .charLetter
    }
    return .charNonWord
}

private func bonusFor(_ prevClass: CharClass, _ currentClass: CharClass) -> Int16 {
    if prevClass == .charNonWord && currentClass != .charNonWord {
        return Int16(bonusBoundary)
    } else if prevClass == .charLower && currentClass == .charUpper ||
        prevClass != .charNumber && currentClass == .charNumber
    {
        return Int16(bonusCamel123)
    } else if currentClass == .charNonWord {
        return Int16(bonusNonWord)
    }
    return 0
}

// MARK: - CharClass

private enum CharClass {
    case charNonWord
    case charLower
    case charUpper
    case charLetter
    case charNumber
}

private let scoreMatch = 16
private let scoreGapStart = -3
private let scoreGapExtension = -1
private let bonusBoundary = scoreMatch / 2
private let bonusNonWord = scoreMatch / 2
private let bonusCamel123 = bonusBoundary + scoreGapExtension
private let bonusConsecutive = -(scoreGapStart + scoreGapExtension)
private let bonusFirstCharMultiplier = 2

// swiftlint:enable identifier_name cyclomatic_complexity function_body_length
