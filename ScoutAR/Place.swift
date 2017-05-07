//
//  Place.swift
//  ScoutAR
//
//  Created by Ella on 4/25/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit
import CoreLocation

class Place: ARAnnotation {
    let id: String
    let name: String
    let formattedPhone: String
    let formattedAddress: String
    let rating: Double
    let isOpen: Bool
    let category: String
    let tier: Int
    let tipText: String
    let userName: String
    let userImageURL: String
    let photoURL: String

    init(location: CLLocation, id: String, name: String, formattedPhone: String, formattedAddress: String, rating: Double, isOpen: Bool, category: String, tier: Int, tipText: String, userName: String, userImageURL: String, photoURL: String) {
        self.id = id
        self.name = name
        self.formattedPhone = formattedPhone
        self.formattedAddress = formattedAddress
        self.rating = rating
        self.isOpen = isOpen
        self.category = category
        self.tier = tier
        self.tipText = tipText
        self.userName = userName
        self.userImageURL = userImageURL
        self.photoURL = photoURL

        super.init()
        self.location = location
    }

    static func create(from dictionary: [String: Any]) -> Place? {
        guard let venue = dictionary["venue"] as? [String: Any] else { return nil }
        guard let id = venue["id"] as? String else { return nil }
        guard let name = venue["name"] as? String else { return nil }

        guard let rating = venue["rating"] as? Double else { return nil }

        guard let contact = venue["contact"] as? [String: Any] else { return nil }
        guard let formattedPhone = contact["formattedPhone"] as? String else { return nil }

        guard let jsonLocation = venue["location"] as? [String: Any] else { return nil }
        guard let lat = jsonLocation["lat"] as? CLLocationDegrees else { return nil }
        guard let lng = jsonLocation["lng"] as? CLLocationDegrees else { return nil }
        let location = CLLocation(latitude: lat, longitude: lng)

        guard let addressArray = jsonLocation["formattedAddress"] as? [String] else { return nil }
        let formattedAddress = "\(addressArray[0]) \n\(addressArray[1])"

        guard let hours = venue["hours"] as? [String: Any] else { return nil }
        guard let isOpen = hours["isOpen"] as? Bool else { return nil }

        guard let categories = venue["categories"] as? [[String: Any]] else { return nil }
        guard let categoryGroup = categories.first else { return nil }
        guard let category = categoryGroup["shortName"] as? String else { return nil }

        guard let price = venue["price"] as? [String: Any] else { return nil }
        guard let tier = price["tier"] as? Int else { return nil }

        guard let tips = dictionary["tips"] as? [[String: Any]] else { return nil }
        guard let tipsGroup = tips.first else { return nil }
        guard let tipText = tipsGroup["text"] as? String else { return nil }
        guard let user = tipsGroup["user"] as? [String: Any] else { return nil }
        guard let firstName = user["firstName"] as? String else { return nil }
        guard let lastName = user["lastName"] as? String else { return nil }
        let userName = firstName + " " + lastName
        guard let photo = user["photo"] as? [String: Any] else { return nil }
        guard let photoPrefix = photo["prefix"] as? String else { return nil }
        guard let photoSuffix = photo["suffix"] as? String else { return nil }
        let userImageURL = photoPrefix + "100x100" + photoSuffix

        guard let photos = venue["photos"] as? [String: Any] else { return nil }
        guard let groups = photos["groups"] as? [[String: Any]] else { return nil }
        guard let groupsGroup = groups.first else { return nil }
        guard let items = groupsGroup["items"] as? [[String: Any]] else { return nil }
        guard let itemsGroup = items.first else { return nil }
        guard let prefix = itemsGroup["prefix"] as? String else { return nil }
        guard let suffix = itemsGroup["suffix"] as? String else { return nil }
        let photoURL = prefix + "original" + suffix

        return Place(location: location, id: id, name: name, formattedPhone: formattedPhone, formattedAddress: formattedAddress, rating: rating, isOpen: isOpen, category: category, tier: tier, tipText: tipText, userName: userName, userImageURL: userImageURL, photoURL: photoURL)
    }

    func convertStringToURLToImage(from string: String) -> UIImage? {
        let url = URL(string: string)
        if let data = try? Data(contentsOf: url!) {
            return UIImage(data: data)
        }
        return nil
    }
}
