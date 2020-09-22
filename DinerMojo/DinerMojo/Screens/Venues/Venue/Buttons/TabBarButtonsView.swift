import UIKit

class TabBarButtonsView: UIView, TabBarItemDelegate {
  var parentView: UIView?
  var tabBarItems: [TabBarItem] = []
  var tabBarItemViews: [TabBarItemView] = []
  var delegate: TabBarItemDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  convenience init(parentView: UIView, tabBarItems: [TabBarItem]) {
    self.init()
    self.tabBarItems = tabBarItems
    self.parentView = parentView

    self.setupView()
    self.setupButtons()
  }

  func setupView() {
    self.translatesAutoresizingMaskIntoConstraints = false
    if let parentView = self.parentView {
      parentView.addSubview(self)
      self.snp.makeConstraints { (make) -> Void in
        make.edges.equalTo(parentView).inset(UIEdgeInsets(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0))
      }
    }
  }

  func setupButtons() {
    var i = 0

    for tabBarItem in self.tabBarItems {
      let item = TabBarItemView(customTabBarItem: tabBarItem, position: i)
      item.translatesAutoresizingMaskIntoConstraints = false
      item.customTabBarItem = tabBarItem
      item.position = i
      item.delegate = self
      self.addSubview(item)
      self.tabBarItemViews.append(item)
      i += 1
    }

    self.layoutButtons()
  }

  func layoutButtons() {
    if self.tabBarItemViews.isEmpty {
      return
    }

    self.pinTopAndBottom()
    self.pinSides()
    self.pinEdges()
    self.applySizes()
  }

  func pinTopAndBottom() {
    for element in self.tabBarItemViews {
      element.snp.makeConstraints({ (make) -> Void in
        make.top.equalTo(self)
        make.bottom.equalTo(self)
      })
    }
  }

  func pinSides() {
    var previousElement: TabBarItemView?
    for element in self.tabBarItemViews {
      previousElement?.snp.makeConstraints({ (make) -> Void in
        make.trailing.equalTo(element.snp.leading)
      })
      previousElement = element
    }
  }

  func pinEdges() {
    let firstItem = self.tabBarItemViews.first
    firstItem?.snp.makeConstraints({ (make) -> Void in
      make.left.equalTo(self)
    })

    let lastItem = self.tabBarItemViews.last
    lastItem?.snp.makeConstraints({ (make) -> Void in
      make.right.equalTo(self)
    })
  }

  func applySizes() {
    var previousElement: TabBarItemView?
    for element in self.tabBarItemViews {
      previousElement?.snp.makeConstraints({ (make) -> Void in
        make.width.equalTo(element.snp.width)
        make.height.equalTo(element.snp.height)
      })
      previousElement = element
    }
  }

  func setSelectedTab(index: Int) {
    for item in self.tabBarItemViews {
      item.isSelected = false
    }

    if(self.tabBarItemViews.count > index) {
      self.tabBarItemViews[index].isSelected = true
    }
  }

  func tabBarSelected(position: Int) {
    self.delegate?.tabBarSelected(position: position)
  }
}
