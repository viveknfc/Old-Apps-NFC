//
//  UploadPhotoViewController.swift
//  EWA
//
//  Created by NFC India on 05/12/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage



class UploadPhotoViewController: BaseViewController {
    
    
    @IBOutlet weak var uploadPhotoList: UICollectionView!
    
    var photoList = [PhotoList]() // list of photo objects
    var photoListObject:JSON = JSON.null
    
    @IBOutlet weak var noRecordsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhotoList()
        self.title = "Upload Photo"
        
    }
    
    // getPhotoList server call method
    func getPhotoList()
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            
            ServerService.showActivityIndicatory(uiView:self.view)
            let params = ["CandidateId":UserDefaults.standard.object(forKey:"cID") as! String] as [String : Any]
            ServerService.getPhotoList(self, params:params, method:"POST", accessToken:Constants.Token, acces: true, callBack: self.getPhotoListData(response:))
        }
        else
        {
            ServerService.hideProgressView()
            ServerService.ShowAlertMessage(ErrorMessage:"Make sure your device is connected to the internet", title: "No internet connection", view:self)
            
        }
    }
    
    // response from the server for getPhotoList()
    func getPhotoListData(response:AnyObject)->()
    {
        photoList.removeAll()
        ServerService.hideProgressView()
        photoListObject = response as! JSON
        print("****** photoList data is ************\n",photoListObject)
        noRecordsLbl.text = photoListObject["Message"].stringValue
        
        if photoListObject["MessageStatus"].intValue == 1
        {
            if photoListObject["UploadPhotoModelList"].arrayValue.count>0
            {
            for p in 0..<photoListObject["UploadPhotoModelList"].arrayValue.count
            {
                
              let photo = PhotoList.init(photoId:photoListObject["UploadPhotoModelList"][p]["Id"].stringValue, photoLink: photoListObject["UploadPhotoModelList"][p]["Photo"].stringValue, photoUpdatedDate: photoListObject["UploadPhotoModelList"][p]["CreateDate"].stringValue)

               photoList.append(photo)
            }
            }
            else
            {
                noRecordsLbl.text = "No records to display"
                uploadPhotoList.backgroundColor = .clear
            }
            
        }
        
        uploadPhotoList.reloadData()
   }

}

//END OF CLASS






//EXTENSIONS

extension UploadPhotoViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"uploadPhoto", for:indexPath) as! UploadPhotoCollectionViewCell
    
        cell.photoImageView.image = UIImage(data:Data(base64Encoded:photoList[indexPath.row].photoLink)!)
        cell.dateLabel.text! = Constants.convertDateForPhoto(string:photoList[indexPath.row].photoUpdatedDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:(self.view.bounds.size.width/2)-15, height: (self.view.bounds.size.width/2)-15)
    }
    
}
