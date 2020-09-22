import UIKit

class TabBarItemView: UIView, CustomTabBar {

    var customTabBarItem: TabBarItem?
    var position: Int?
    var delegate: TabBarItemDelegate?
    var button: UIButton?

    private var _isSelected: Bool = false
    var isSelected: Bool {
        get {
            _isSelected
        }
        set(item) {
            _isSelected = item
            if item {
                self.button?.tintColor = self.customTabBarItem?.selectedIconColor
            } else {
                self.button?.tintColor = self.customTabBarItem?.iconColor
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(customTabBarItem: TabBarItem, position: Int) {
        self.init()
        self.customTabBarItem = customTabBarItem
        self.position = position

        self.setupButton()
    }

    func setupButton() {
        self.button = UIButton()

        guard let item = self.customTabBarItem, let button = self.button else {
            return
        }

        let icon = UIImage(named: item.icon)?.withRenderingMode(.alwaysTemplate)

        let backgroundView = UIImageView()
        self.addSubview(backgroundView)
        backgroundView.image = icon
        backgroundView.tintColor = item.iconColor
        backgroundView.contentMode = .center
        button.addTarget(self, action: #selector(TabBarItemView.clickButton), for: .touchUpInside)
        self.addSubview(button)

        button.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }

        button.isUserInteractionEnabled = true
        self.backgroundColor = item.backgroundColor
        self.isSelected = false

        let label = UILabel.init()
        label.text = item.name
        label.textAlignment = .center
        self.addSubview(label)

        label.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(20)
        }

        backgroundView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(label.snp.top)
        }

        label.font = UIFont(name: "Open Sans", size: 13)
        label.textColor = item.iconColor

        if(item.lastElement == false) {
            let separator = UIView()
            separator.backgroundColor = item.iconColor
            self.addSubview(separator)

            separator.snp.makeConstraints { (make) -> Void in
                make.right.equalTo(self)
                make.top.equalTo(self)
                make.bottom.equalTo(self)
                make.width.equalTo(1)
            }
        }
    }

    @objc func clickButton(sender: UIButton) {
        if let number = self.position {
            self.delegate?.tabBarSelected(position: number)
        }
    }
}
