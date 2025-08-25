//
//  RatingController.swift
//

import UIKit

protocol CellDelegate: AnyObject {
    func saveRatingButtonTapped(with starsRating: Int, at row: Int)
}

class RatingController: UIStackView {
    
    weak var delegate: CellDelegate?
    
    var row: Int = 0
    
    var starsRating = 0 // var starsRating: CGFloat = 0
    var starsEmptyPicName = "star" // star_empty_small - change it to your empty star picture name
    var starsFilledPicName = "star.fill" // star_filled_small - change it to your filled star picture name
    //  var allowHalfStars = true
    
    override func draw(_ rect: CGRect) {
        
        let starButtons = self.subviews.filter{$0 is UIButton}
        var starTag = 1 //  var starTag: CGFloat = 1.0
        
        for button in starButtons {
            
            if let button = button as? UIButton{
                
                if #available(iOS 13.0, *) {
                    if let starImage = UIImage(systemName: starsEmptyPicName) {
                        button.setImage(starImage, for: .normal)
                    }
                } else {
                    // Fallback on earlier versions
                }
                
//                button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                button.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
                button.tag = starTag // button.tag = Int(starTag)
                starTag = starTag + 1 // starTag += 1.0
            }
        }
       setStarsRating(rating:starsRating)
    }
    func setStarsRating(rating:Int){ // func setStarsRating(rating: CGFloat)
        
        self.starsRating = rating
        let stackSubViews = self.subviews.filter{$0 is UIButton}
        
        
        /*
         
         func setStarsRating(rating: CGFloat) {
                 self.starsRating = rating
                 let stackSubViews = self.subviews.filter { $0 is UIButton }
                 
                 for subView in stackSubViews {
                     if let button = subView as? UIButton {
                         let tag = CGFloat(button.tag)
                         if allowHalfStars {
                             let remainder = rating - tag
                             
                             if remainder >= 0.5 {
                                 button.setImage(UIImage(named: starsFilledPicName), for: .normal)
                             } else if remainder > 0 {
                                 button.setImage(UIImage(named: "star_half_small"), for: .normal) // Replace with your half-star image
                             } else {
                                 button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                             }
                         } else {
                             if tag <= rating {
                                 button.setImage(UIImage(named: starsFilledPicName), for: .normal)
                             } else {
                                 button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                             }
                         }
                     }
                 }
             }
         
         */
        
        
        
        for subView in stackSubViews {
            if let button = subView as? UIButton{
                if button.tag > starsRating {
                    
                    if #available(iOS 13.0, *) {
                        if let starImage = UIImage(systemName: starsEmptyPicName) {
                            button.setImage(starImage, for: .normal)
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    
//                    button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                }else{
                    
                    if #available(iOS 13.0, *) {
                        if let starImage = UIImage(systemName: starsFilledPicName) {
                            button.setImage(starImage, for: .normal)
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    
//                    button.setImage(UIImage(named: starsFilledPicName), for: .normal)
                }
            }
        }
    }
    @objc func pressed(sender: UIButton) {
        print("Vivek pressed star rating and now the rating value is ",sender.tag)

        setStarsRating(rating: sender.tag)
        
        delegate?.saveRatingButtonTapped(with: sender.tag, at: row)
    }
}
