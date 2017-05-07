//
//  AnnotationView.swift
//  ScoutAR
//
//  Created by Ella on 4/26/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit

protocol AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView)
}

class AnnotationView: ARAnnotationView {
    var backgroundView: UIView?
    var titleLabel: UILabel?
    var distanceLabel: UILabel?
    var ratingLabel: UILabel?
    var pinImage: UIImageView?
    var openLabel: UILabel?
    var delegate: AnnotationViewDelegate?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        loadUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 70)
        titleLabel?.frame = CGRect(x: 66, y: 8, width: self.frame.size.width - 66, height: 22.0)
        distanceLabel?.frame = CGRect(x: 135.5, y: 47, width: self.frame.size.width - 135.5, height: 15.0)
        pinImage = UIImageView(frame: CGRect(x: 16, y: 8, width: 37.76, height: 54))
        ratingLabel?.frame = CGRect(x: 66, y: 29.5, width: self.frame.size.width - 66, height: 18.0)
        openLabel?.frame = CGRect(x: 66, y: 47, width: self.frame.size.width  - 66, height: 15.0)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouch(annotationView: self)
    }

    func loadUI() {
        titleLabel?.removeFromSuperview()
        distanceLabel?.removeFromSuperview()
        backgroundView?.removeFromSuperview()
        pinImage?.removeFromSuperview()
        openLabel?.removeFromSuperview()
        ratingLabel?.removeFromSuperview()

        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 70))
        backgroundView?.backgroundColor = UIColor(white: 1, alpha: 0.80)
        backgroundView?.layer.cornerRadius = 10.0
        self.addSubview(backgroundView!)

        pinImage = UIImageView(frame: CGRect(x: 16, y: 8, width: 37.76, height: 54))
        pinImage?.image = UIImage(named: "Pin")
        pinImage?.contentMode = UIViewContentMode.scaleAspectFit
        self.backgroundView?.addSubview(pinImage!)

        let label = UILabel(frame: CGRect(x: 66, y: 8, width: self.frame.size.width, height: 22.0))
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.numberOfLines = 1
        label.textColor = UIColor.black
        self.backgroundView?.addSubview(label)
        self.titleLabel = label

        distanceLabel = UILabel(frame: CGRect(x: 66, y: 47, width: self.frame.size.width, height: 15.0))
        distanceLabel?.textColor = UIColor.black
        distanceLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
        self.backgroundView?.addSubview(distanceLabel!)

        ratingLabel = UILabel(frame: CGRect(x: 66, y: 29.5, width: self.frame.size.width, height: 18.0))
        ratingLabel?.textColor = UIColor.black
        ratingLabel?.font = UIFont(name: "Montserrat-Regular", size: 14)
        self.backgroundView?.addSubview(ratingLabel!)

        openLabel = UILabel(frame: CGRect(x: 66, y: 47, width: self.frame.size.width, height: 18.0))
        openLabel?.font = UIFont(name: "Montserrat-Black", size: 12)
        self.backgroundView?.addSubview(openLabel!)

        if let annotation = annotation as? Place {
            titleLabel?.text = annotation.name
            distanceLabel?.text = String(format: "%.2f mi", annotation.distanceFromUser * 0.000621371)
            ratingLabel?.text = String("rating: \(annotation.rating)")

            if annotation.isOpen {
                openLabel?.text = "Open"
                openLabel?.textColor = UIColor(red: 63/255.0, green: 195/255.0, blue: 128/255.0, alpha: 1)
            } else {
                openLabel?.text = "Closed"
                openLabel?.textColor = UIColor(red: 248/255.0, green: 40/255.0, blue: 22/255.0, alpha: 1)
            }
        }
    }
}
