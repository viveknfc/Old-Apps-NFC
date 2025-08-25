//
//  EvaluateEmpCommentView.swift
//  CWA
//
//  Created by NFC Solutionsusa on 18/07/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit

class EvaluateEmpCommentView: UIView {
    
    @IBOutlet weak var whiteBGView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var lblTitle: UILabel!

    let borderColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    
    func setupUI(divColor: UIColor){
        
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        self.whiteBGView.layer.borderColor = UIColor.black.cgColor
        self.whiteBGView.layer.borderWidth = 1
        lblTitle.backgroundColor = divColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = borderColor.cgColor
    }
    
//    @IBAction func closeButtonTapped(_ sender: Any) {
//        
//        self.removeCommentPopupViewFromSuperView()
//        
//    }
    
    
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
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
