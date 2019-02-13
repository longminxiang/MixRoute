//
//  Route.swift
//  MixRoute
//
//  Created by Eric on 2018/11/18.
//  Copyright © 2018 YOOEE. All rights reserved.
//

import Foundation

@objc public class NavItem: NSObject, Codable {
    @objc public var title: String?
    
    @objc public var navigationItem: UINavigationItem {
        let item = UINavigationItem(title: self.title ?? "")
        return item
    }
    
    enum CodingKeys: String, CodingKey {
        case title
    }
}

@objc public class TabItem: NSObject, Codable {
    @objc public var title: String?
    @objc public var image: String?
    @objc public var selImage: String?
    
    @objc public var tabBarItem: UITabBarItem {
        var img, selImg: UIImage?
        if let image = self.image { img = UIImage(named: image)?.withRenderingMode(.alwaysOriginal) }
        if let selImage = self.selImage { selImg = UIImage(named: selImage)?.withRenderingMode(.alwaysOriginal) }
        let item = UITabBarItem(title: self.title, image: img, selectedImage: selImg)
        return item
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case image
        case selImage
    }
}

@objc public class Route: NSObject, Codable {
    
    @objc public let name: String
    
    private var _style: UInt?
    @objc public var style: MixViewControllerRouteStyle {
        set {
            self._style = newValue.rawValue
        }
        get {
            return MixViewControllerRouteStyle(rawValue: self._style ?? 0) ?? .push
        }
    }
    
    @objc public var nav: NavItem?
    
    @objc public var tab: TabItem?
    
    @objc public var tabRoutes: [Route]?

    @objc public var navigationClass: String?
    
    @objc public var vcRoute: MixRoute? {
        guard let route = MixRoute(name: MixRouteNameFrom(self.name)) else { return nil }
        let params = MixRouteViewControllerParams()
        params.style = self.style
        params.navigationItem = self.nav?.navigationItem
        params.tabBarItem = self.tab?.tabBarItem
        if let navClass = self.navigationClass {
            params.navigationControllerClass = NSClassFromString(navClass)
        }
        if let tabRoutes = self.tabRoutes {
            var routes: [MixRoute] = []
            tabRoutes.forEach({ (route) in
                if let mixRoute = route.vcRoute {
                    routes.append(mixRoute)
                }
            })
            params.tabRoutes = routes
        }
        route.params = params
        return route
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case _style = "style"
        case nav
        case tab
        case tabRoutes
        case navigationClass
    }
    
    @objc public class func route(dictionary: NSDictionary) -> Route? {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        let route = try? JSONDecoder().decode(Route.self, from: data)
        return route
    }
}
