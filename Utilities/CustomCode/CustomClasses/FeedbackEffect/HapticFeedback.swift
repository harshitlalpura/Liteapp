import UIKit

/// An enum describing the different kinds of haptic feedback the taptic engine is capable of producing.
/// For use in `FeedbackEffect`, to give the user feedback when it's desired.
///
/// - impact: Used for calling `UIImpactFeedbackGenerator(impactStyle).impactOccurred()`.
/// - selection: Used for calling `UISelectionFeedbackGenerator().selectionChanged()`.
/// - notification: Used for calling `UINotificationFeedbackGenerator().notificationOccurred(notificationType)`.
public enum HapticFeedback: HapticEmitting {

    fileprivate static let lightImpactGenerator = UIImpactFeedbackGenerator()
    fileprivate static let mediumImpactGenerator = UIImpactFeedbackGenerator()
    fileprivate static let heavyImpactGenerator = UIImpactFeedbackGenerator()
    fileprivate static let selectionGenerator = UISelectionFeedbackGenerator()
    fileprivate static let notificationGenerator = UINotificationFeedbackGenerator()

    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case selection
    case notification(UINotificationFeedbackGenerator.FeedbackType)
}

extension HapticFeedback {

    public func prepare() {
        switch self {

        case .impact(let style):
            switch style {

            case .light:
                HapticFeedback.lightImpactGenerator.prepare()

            case .medium:
                HapticFeedback.mediumImpactGenerator.prepare()

            case .heavy:
                HapticFeedback.heavyImpactGenerator.prepare()

            default:
                HapticFeedback.lightImpactGenerator.prepare()
            }

        case .selection:
            HapticFeedback.selectionGenerator.prepare()

        case .notification:
            HapticFeedback.notificationGenerator.prepare()
        }
    }

    public func generateFeedback() {
        switch self {

        case .impact(let style):
            switch style {

            case .light:
                HapticFeedback.lightImpactGenerator.impactOccurred()

            case .medium:
                HapticFeedback.mediumImpactGenerator.impactOccurred()

            case .heavy:
                HapticFeedback.heavyImpactGenerator.impactOccurred()

            default:
                HapticFeedback.lightImpactGenerator.impactOccurred()
            }

        case .selection:
            HapticFeedback.selectionGenerator.selectionChanged()

        case .notification(let notificationType):
            HapticFeedback.notificationGenerator.notificationOccurred(notificationType)

        }
    }
}
