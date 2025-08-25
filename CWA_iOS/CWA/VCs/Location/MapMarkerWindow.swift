//
//  MapMarkerWindow.swift
//  CWA
//
//  Created by NFC User on 1/28/19.
//  Copyright © 2019 NFC Solutionsusa. All rights reserved.
//

import UIKit
 
protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: EmpLocModel)
}

class MapMarkerWindow: UIView {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var publicTime: UILabel!
    @IBOutlet weak var vehicleTime: UILabel!
    @IBOutlet weak var walklabel: UILabel!
    
    @IBOutlet weak var busImage: UIImageView!
    @IBOutlet weak var walkImageView: UIImageView!
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var tempositionLogo: UIImageView!
    
    weak var delegate: MapMarkerDelegate?
    var spotData: EmpLocModel?
    
    
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
 }
