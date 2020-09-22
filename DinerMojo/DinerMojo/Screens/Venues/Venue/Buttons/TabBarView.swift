import UIKit
import SnapKit

@objc class TabBarView: UIView, TabBarItemDelegate {
  var parentView: UIView?
  var heightConstraint: Constraint? = nil
  var tabBarItems: [TabBarItem] = []
  @objc public var delegate: TabBarItemDelegate?
  var buttonsView: TabBarButtonsView?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

 @objc convenience init(parentView: UIView, tabBarItems: [TabBarItem]) {
    self.init()
    self.tabBarItems = tabBarItems
    self.parentView = parentView
    self.setupView()
  }

  func setupView() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.white

    if let parentView = self.parentView {
      parentView.addSubview(self)

      self.snp.makeConstraints { (make) -> Void in
        make.left.equalTo(parentView)
        make.right.equalTo(parentView)
        make.bottom.equalTo(parentView)
        make.top.equalTo(parentView)
      }
    }

    self.buttonsView = TabBarButtonsView(parentView: self, tabBarItems: self.tabBarItems)
    self.buttonsView?.delegate = self
  }

  func setViewHeight(height: Int) {
    self.heightConstraint?.update(offset: height)
  }

  func tabBarSelected(position: Int) {
    self.delegate?.tabBarSelected(position: position)
  }

  func setSelectedTab(index: Int) {
    self.buttonsView?.setSelectedTab(index: index)
  }
}
