// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import Combine
import RobotKit
import SwiftUI

@Observable
class NewMelodyViewViewModel {
    // MARK: Lifecycle

    init(coordinator: NewMelodyCoordinator) {
        self.coordinator = coordinator
        self.songs = coordinator.songs
        self.instrument = coordinator.instrument
        self.selectedSong = coordinator.songs.first!
        self.tileColors = self.coordinator.tileColors
        self.subscribeToScale()
        self.subscribeToProgress()
        self.subscribeToViewStates()
    }

    // MARK: Public

    public var scale: [MIDINoteNumber] = []
    public var progress: CGFloat = 0.0
    public var isTappable: Bool = false
    public var showPlayButton: Bool = false
    public var isMelodyPlaying: Bool = false

    public var keyboardMode: MelodyKeyboardType = .partial
    public var selectedSong: MidiRecordingPlayerSong

    // MARK: Internal

    let instrument: MIDIInstrument
    let songs: [MidiRecordingPlayerSong]
    let tileColors: [Robot.Color]

    func setup() {
        self.coordinator.setupMelody(midiRecording: self.selectedSong)
    }

    func updateKeyboardMode(isKeyboardFull: Bool) {
        self.keyboardMode = isKeyboardFull ? .full : .partial
    }

    func playSong() {
        self.coordinator.playMIDIRecording()
    }

    func start() {
        self.coordinator.startActivity()
    }

    func onTileTapped(noteNumber: MIDINoteNumber) {
        self.coordinator.onTileTapped(noteNumber: noteNumber)
    }

    func stop() {
        self.coordinator.stop()
    }

    // MARK: Private

    private let coordinator: NewMelodyCoordinator
    private var cancellables: Set<AnyCancellable> = []

    private func subscribeToScale() {
        self.coordinator.scale
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.scale = $0
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToProgress() {
        self.coordinator.progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.progress = $0
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToViewStates() {
        self.coordinator.enableTap
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.isTappable = $0
            }
            .store(in: &self.cancellables)
        self.coordinator.showPlayButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.showPlayButton = $0
            }
            .store(in: &self.cancellables)
        self.coordinator.isMelodyPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.isMelodyPlaying = $0
            }
            .store(in: &self.cancellables)
    }
}
