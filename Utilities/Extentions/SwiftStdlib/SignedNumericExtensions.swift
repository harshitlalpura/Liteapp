import Foundation

// MARK: - Properties
public extension SignedNumeric {
    
    /// String.
    var string: String {
        return String(describing: self)
    }
    
    /// String with number and current locale currency.
    var asLocaleCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        guard let number = self as? NSNumber else { return "" }
        return formatter.string(from: number) ?? ""
    }
    
}
