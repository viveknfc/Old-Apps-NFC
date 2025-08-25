//
//  EmpEvaluationPopup.swift
//  CWA
//
//  Created by NFC Solutionsusa on 03/08/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit
import FloatRatingView

class EmpEvaluationPopup: UIView {
    let borderColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var floatingView: FloatRatingView!
    
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var whiteBGView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var empEvaluationLbl: UILabel!

    @IBOutlet weak var whiteBGTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var superViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollSubViewHeightConstraint: NSLayoutConstraint!

    func setupUI(){
        
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        floatingView.type = .wholeRatings
        floatingView.backgroundColor = UIColor.clear
        self.whiteBGView.layer.borderColor = UIColor.black.cgColor
        self.whiteBGView.layer.borderWidth = 1
        
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = borderColor.cgColor
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        customView.backgroundColor = borderColor
        
        commentTextView.inputAccessoryView = customView
        
        let DoneBtn = UIButton.init()
        DoneBtn.frame = CGRect(x:UIScreen.main.bounds.size.width - 80,y:4,width: 60,height: 38)
        DoneBtn.addTarget(self, action: #selector(self.doneBtnTapped), for: .touchUpInside)
        DoneBtn.setTitle("Done", for: .normal)
        DoneBtn.setTitleColor(UIColor.white, for: .normal)
        DoneBtn.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
        customView.addSubview(DoneBtn)
        lblTitle.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
    }
    
     @objc func doneBtnTapped(sender: UIButton)  {
self.commentTextView.resignFirstResponder()
    }
    func removeCommentPopupViewFromSuperView(){
        
        self.whiteBGView.transform =  .identity
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            
            self.whiteBGView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
            self.removeFromSuperview()
            
        })
    }
    
    func ShowPopup(superView:UIView){
        superView.addSubview(self)
        self.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        
        self.whiteBGView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            self.whiteBGView.transform = .identity
        }, completion: {(finished: Bool) -> Void in
            // do something once the animation finishes, put it here
        })
        //        self.commentTextView.becomeFirstResponder()
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
