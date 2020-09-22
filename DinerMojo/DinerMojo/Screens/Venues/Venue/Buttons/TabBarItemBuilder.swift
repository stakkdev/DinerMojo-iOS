import UIKit

@objc class TabBarItemBuilder: NSObject {
  var icon: String?
  var backgroundColor: UIColor?
  var iconColor: UIColor?
  var selectedIconColor: UIColor?
  var name: String?

  typealias BuilderClosure = (TabBarItemBuilder) -> ()

  init(buildClosure: BuilderClosure) {
    super.init()
    buildClosure(self)
  }
}
