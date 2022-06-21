import UIKit
extension NSLayoutConstraint {
/**
 Change multiplier constraint

 - parameter multiplier: CGFloat
 - returns: NSLayoutConstraintfor
*/
func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {

    NSLayoutConstraint.deactivate([self])

    let newConstraint = NSLayoutConstraint(
        item: firstItem!,
        attribute: firstAttribute,
        relatedBy: relation,
        toItem: secondItem,
        attribute: secondAttribute,
        multiplier: multiplier,
        constant: constant)

    newConstraint.priority = priority
    newConstraint.shouldBeArchived = self.shouldBeArchived
    newConstraint.identifier = self.identifier

    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
}
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
