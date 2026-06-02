import AVFoundation
import Foundation

#if canImport(UIKit)
import UIKit
#endif

struct FeedbackSettings: Codable, Equatable {
    var isSoundEnabled: Bool
    var isHapticsEnabled: Bool

    static let `default` = FeedbackSettings(isSoundEnabled: true, isHapticsEnabled: true)
}

enum GameFeedbackEvent {
    case move
    case dig
    case failedAction
    case reward
    case bomb
    case shield
    case damage
    case runOver
    case upgradePurchase
    case toggle
}

@MainActor
final class GameFeedbackSystem {
    private let audio = AudioFeedbackSystem()
    private let haptics = HapticFeedbackSystem()

    func play(_ event: GameFeedbackEvent, settings: FeedbackSettings) {
        if settings.isSoundEnabled {
            audio.play(event)
        }

        if settings.isHapticsEnabled {
            haptics.play(event)
        }
    }
}

@MainActor
private final class AudioFeedbackSystem {
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)
    private var isPrepared = false

    func play(_ event: GameFeedbackEvent) {
        guard let format else {
            return
        }

        prepareIfNeeded(format: format)

        guard engine.isRunning else {
            return
        }

        let tone = toneDefinition(for: event)
        guard let buffer = makeToneBuffer(
            frequency: tone.frequency,
            duration: tone.duration,
            volume: tone.volume,
            format: format
        ) else {
            return
        }

        player.scheduleBuffer(buffer, at: nil)
        if !player.isPlaying {
            player.play()
        }
    }

    private func prepareIfNeeded(format: AVAudioFormat) {
        guard !isPrepared else {
            return
        }

        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.ambient, options: [.mixWithOthers])
        #endif

        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        try? engine.start()
        isPrepared = true
    }

    private func toneDefinition(for event: GameFeedbackEvent) -> (frequency: Double, duration: Double, volume: Float) {
        switch event {
        case .move:
            return (220, 0.035, 0.10)
        case .dig:
            return (150, 0.055, 0.16)
        case .failedAction:
            return (95, 0.045, 0.12)
        case .reward:
            return (740, 0.080, 0.15)
        case .bomb:
            return (82, 0.130, 0.22)
        case .shield:
            return (520, 0.090, 0.12)
        case .damage:
            return (118, 0.110, 0.20)
        case .runOver:
            return (72, 0.180, 0.18)
        case .upgradePurchase:
            return (660, 0.120, 0.14)
        case .toggle:
            return (440, 0.050, 0.10)
        }
    }

    private func makeToneBuffer(
        frequency: Double,
        duration: Double,
        volume: Float,
        format: AVAudioFormat
    ) -> AVAudioPCMBuffer? {
        let frameCount = AVAudioFrameCount(format.sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channel = buffer.floatChannelData?.pointee
        else {
            return nil
        }

        buffer.frameLength = frameCount
        let sampleRate = format.sampleRate

        for frame in 0..<Int(frameCount) {
            let progress = Double(frame) / Double(max(1, frameCount - 1))
            let envelope = Float(sin(progress * .pi))
            let phase = (Double(frame) / sampleRate) * frequency * Double.pi * 2
            channel[frame] = Float(sin(phase)) * volume * envelope
        }

        return buffer
    }
}

@MainActor
private final class HapticFeedbackSystem {
    func play(_ event: GameFeedbackEvent) {
        #if canImport(UIKit)
        switch event {
        case .move, .toggle:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .dig, .shield:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .failedAction:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .reward, .upgradePurchase:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .bomb, .damage, .runOver:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        #endif
    }
}
