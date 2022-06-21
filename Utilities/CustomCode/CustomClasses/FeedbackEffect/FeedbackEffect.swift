//
// let soundUrl = Bundle.main.url(forResource: "sound", withExtension: "wav")
// FeedbackEffect.play(sound: soundUrl, feedback: VibrationFeedback.selection)

import AVFoundation
import UIKit

/// A protocol for encapsulating the different ways that sound can be created, for use in `FeedbackEffect`.
public protocol SoundEmitting {

    func makeSound()
}

/// A protocol for encapsulating the different ways that haptic feedback can be created, for use in `FeedbackEffect`.
public protocol HapticEmitting {
    func generateFeedback()
}

/// A type which encapsulates sound and haptic feedback. This is useful for providing feedback on user
/// interaction, or when an app would like to signal a noteworthy event.
public struct FeedbackEffect {

    // The player needs to be retained, so we make it a property.
    static let player = AVQueuePlayer()

    /// A function that allows a user to provide feedback to a user.
    ///
    /// - Parameters:
    ///   - sound: A `SoundEmitting` type to play when feedback occurs.
    ///   - feedback: A `HapticEmitting` type to play when feedback occurs.
//    public static func play(sound: SoundEmitting?, feedback: HapticEmitting? = nil, mute: Bool = false) {
//
//        if let sound = sound, !mute {
//            do {
//                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, with: .mixWithOthers)
//                sound.makeSound()
//            } catch {
//                Logger.log("Couldn't play a sound")
//            }
//        }
//
//        if let feedback = feedback {
//            feedback.generateFeedback()
//        }
//
//    }

    public static func play(sound: SoundEmitting? = nil, feedback: HapticEmitting? = nil, mute: Bool = false) {
        if let sound = sound, !mute {
            do {
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
                sound.makeSound()
            } catch {
                Logger.log("Couldn't play a sound")
            }
        }

        if let feedback = feedback {
            feedback.generateFeedback()
        }
    }

    public static func playSendMessageSound() {

        let soundUrl = Bundle.main.url(forResource: "pop_2", withExtension: "wav")
        FeedbackEffect.play(sound: soundUrl, feedback: HapticFeedback.selection, mute: false)

    }

}
