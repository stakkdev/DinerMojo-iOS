//
//  LottieView.swift
//  HighNetWork
//
//  Created by chrisfulford on 24/01/2019.
//  Copyright © 2019 The Distance. All rights reserved.
//

import UIKit
import Lottie
import Promises

extension UIView {
    func edges(to view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
        ])
    }
    
    func roundCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func border(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func cgImage() -> CGImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: 0, y: self.bounds.height)
        context?.scaleBy(x: 1, y: -1)
        self.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return image?.cgImage
    }
}


protocol DinerLOTAnimationDelegate: class {
    func animationDidFinish()
}

@objc(DinerLOTAnimationView) class DinerLOTAnimationView: UIView {
    weak var delegate: DinerLOTAnimationDelegate?
    var animationView: AnimationView?
    
    // MARK: - Public Funcs:
    func load(jsonFile: String,
                    animationShouldLoop: Bool,
                    animationSpeed: CGFloat?) {
        self.setupAnimationView(with: jsonFile)
        self.animationView?.animationSpeed = animationSpeed ?? 1.0
        self.animationView?.loopMode = animationShouldLoop ? .loop : .playOnce
    }
    
    @objc func loopFrog(jsonFile: String) {
        self.setupAnimationView(with: jsonFile)
        self.loopPauseAnimate()
    }
    
    @discardableResult func playAnimation() -> Promise<Void> {
        return wrap { handler in
            self.animationView?.play(completion: handler)
        }.then { _ in
            self.delegate?.animationDidFinish()
        }
    }
    
    // MARK: - Private Funcs:
    private func setupAnimationView(with name: String) {
        self.animationView?.removeFromSuperview()
        let animationView = AnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animationView)
        animationView.edges(to: self)
        self.animationView = animationView
    }
    
    @discardableResult private func loopPauseAnimate() -> Promise<Void> {
        return self.playAnimation().then {
            return self.playAnimation()
        }.then {
            return self.playAnimation()
        }.delay(2.0).then {
            return self.loopPauseAnimate()
        }
    }
}
