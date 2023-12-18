// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - ExercisePayloadProtocol

public protocol ExercisePayloadProtocol: Codable {}

// MARK: - TouchToSelect.Payload + ExercisePayloadProtocol

extension TouchToSelect.Payload: ExercisePayloadProtocol {}

// MARK: - DragAndDropIntoZones.Payload + ExercisePayloadProtocol

extension DragAndDropIntoZones.Payload: ExercisePayloadProtocol {}

// MARK: - DragAndDropToAssociate.Payload + ExercisePayloadProtocol

extension DragAndDropToAssociate.Payload: ExercisePayloadProtocol {}

// MARK: - AudioRecordingPlayer.Payload + ExercisePayloadProtocol

extension AudioRecordingPlayer.Payload: ExercisePayloadProtocol {}

// MARK: - MidiRecordingPlayer.Payload + ExercisePayloadProtocol

extension MidiRecordingPlayer.Payload: ExercisePayloadProtocol {}

// MARK: - HideAndSeek.Payload + ExercisePayloadProtocol

extension HideAndSeek.Payload: ExercisePayloadProtocol {}

// MARK: - MusicalInstrument.Payload + ExercisePayloadProtocol

extension MusicalInstrument.Payload: ExercisePayloadProtocol {}

// MARK: - DanceFreeze.Payload + ExercisePayloadProtocol

extension DanceFreeze.Payload: ExercisePayloadProtocol {}
