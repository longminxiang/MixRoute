//
//  UINavigationItem+Mix.swift
//  MixRoute
//
//  Created by Eric Lung on 2019/1/17.
//  Copyright © 2019年 YOOEE. All rights reserved.
//

import UIKit

@objc public class MixUINavigationItem: NSObject {

    @objc public var disableInteractivePopGesture: Bool = false

    @objc public var statusBarHidden: Bool = false

    @objc public var statusBarStyle: UIStatusBarStyle = .default

    @objc public var barHidden: Bool = false

    @objc public var barTitleTextAttributes: [NSAttributedString.Key : Any]?

    @objc public var barTintColor: UIColor?

    @objc public var barBackgroundImage: UIImage?
}

@objc public extension UINavigationItem {

    struct AssociatedKeys {
        static var mixKey: String?
    }

    @objc public var mix: MixUINavigationItem {
        if let obj = objc_getAssociatedObject(self, &AssociatedKeys.mixKey) as? MixUINavigationItem {
            return obj
        }
        else {
            let obj = MixUINavigationItem()
            objc_setAssociatedObject(self, &AssociatedKeys.mixKey, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return obj
        }
    }
}

@objc public class MixUINavigationItemManager: NSObject {

    private weak var vc: UIViewController?

    private let itemKeyPaths: [String] = [
        "disableInteractivePopGesture", "statusBarStyle", "barHidden",
        "barTitleTextAttributes", "barTintColor", "barBackgroundImage", "statusBarHidden"
    ]

    @objc public init(_ vc: UIViewController) {
        super.init()
        self.vc = vc;
        if let item = self.vc?.navigationItem.mix {
            self.itemKeyPaths.forEach { (key) in
                item.addObserver(self, forKeyPath: key, options: .new, context: nil)
            }
        }
    }

    @objc public func viewWillAppear(animated: Bool) {
        guard let vc = self.vc, let nav = vc.navigationController else { return }

        let item = vc.navigationItem.mix
        let bar = nav.navigationBar

        self.itemKeyPaths.forEach { (key) in
            var context: UnsafeMutableRawPointer?
            // view will appear时是不能禁用的
            if key == "disableInteractivePopGesture" {
                var lock = true
                context = UnsafeMutableRawPointer(&lock)
            }
            // 如果没有背景图，那就要用bar的背景图代替
            else if key == "barBackgroundImage" && item.barBackgroundImage == nil {
                if let image = bar.backgroundImage(for: .default) {
                    context = Unmanaged.passUnretained(image).toOpaque()
                }
            }
            self.observeValue(forKeyPath: key, of: item, change: nil, context: context)
        }

        vc.transitionCoordinator?.animate(alongsideTransition: { (context) in
            let fromVC = context.viewController(forKey: .from)
            let isPop = fromVC == nil ? true : !nav.viewControllers.contains(fromVC!)
            if !isPop { return }

            for view in bar.subviews {
                if let cls = NSClassFromString("_UINavigationBarContentView"), view.isKind(of: cls) {
                    for label in view.subviews {
                        guard !item.barHidden, let label = label as? UILabel, let text = label.text,
                            let atts = item.barTitleTextAttributes else { continue }
                        label.attributedText = NSAttributedString(string: text, attributes: atts)
                        break;
                    }
                }
                else if let cls = NSClassFromString("_UIBarBackground"), view.isKind(of: cls) {
                    for sview in view.subviews {
                        guard let sview = sview as? UIVisualEffectView else { continue }
                        for ssview in sview.subviews {
                            if ssview.alpha < 0.86 && !item.barHidden {
                                ssview.backgroundColor = item.barTintColor
                                break
                            }
                        }
                    }
                }
            }

        }, completion: nil)
    }

    @objc public func viewDidAppear(animated: Bool) {
        guard let item = self.vc?.navigationItem.mix else { return }
        self.observeValue(forKeyPath: "disableInteractivePopGesture", of: item, change: nil, context: nil)
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let vc = self.vc,
            let nav = vc.navigationController,
            nav.topViewController == vc,
            let item = self.vc?.navigationItem.mix,
            let object = object as? MixUINavigationItem,
            object == item else { return }

//        let bar = nav.navigationBar
        if keyPath == "disableInteractivePopGesture" {
//            var lock = context.u
//            BOOL lock = context;
//            if (lock) return;
//            BOOL isRoot = [nav.viewControllers firstObject] == self.vc;
//            nav.interactivePopGestureRecognizer.enabled = !isRoot && !item.disableInteractivePopGesture;
        }

    }
}
