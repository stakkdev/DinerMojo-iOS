import UIKit

@objc class TabBarItem: NSObject {
  let icon: String
  let backgroundColor: UIColor
  let iconColor: UIColor
  let selectedIconColor: UIColor
  let name: String
  var lastElement: Bool = false
    
  init?(builder: TabBarItemBuilder) {
    guard let icon = builder.icon,
      let backgroundColor = builder.backgroundColor,
      let iconColor = builder.iconColor,
      let selectedIconColor = builder.selectedIconColor,
      let name = builder.name else {
        return nil
    }

    self.icon = icon
    self.backgroundColor = backgroundColor
    self.iconColor = iconColor
    self.selectedIconColor = selectedIconColor
    self.name = name
  }
}
