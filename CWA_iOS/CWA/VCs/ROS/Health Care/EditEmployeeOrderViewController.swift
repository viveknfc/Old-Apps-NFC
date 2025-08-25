//
//  EditEmployeeOrderViewController.swift
//  CWA
//
//  Created by NFC Solutionsusa on 19/03/18.
//  Copyright © 2018 NFC Solutionsusa. All rights reserved.
//

import UIKit


@objc protocol EditEmployeeOrderDelegate: class{
    
    func selectedEmployeeOrder(_ emps: NSMutableArray)
}

class EditEmployeeOrderViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return EmployeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as UITableViewCell?
        if !(cell != nil) {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
 
        let  emp = EmployeeList[indexPath.row] as! NewEmployee
        let  empObj:NewEmployee = emp as NewEmployee
        let name =   empObj.Name
        cell?.textLabel?.text = name
        
        if empObj.isSelected == "0"{
            cell?.backgroundColor = UIColor.white
        }else{
            cell?.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        }
        return cell!
    }
    

    var EmployeeList = NSMutableArray()
    var SelectedEmployeeList = NSMutableArray()
    @IBOutlet weak var empTableView: UITableView!
    @IBOutlet weak var topNavigationView: UIView!

    weak var delegate: EditEmployeeOrderDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        topNavigationView.backgroundColor = UIColor(hexString:UserDefaults.standard.object(forKey:"ColorCode")as! String)
         empTableView.tableFooterView = UIView()

empTableView.layer.borderColor = UIColor.lightGray.cgColor
empTableView.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let  emp = EmployeeList[indexPath.row] as! NewEmployee
            let  empObj:NewEmployee = emp as NewEmployee
            if SelectedEmployeeList.contains(empObj){
                empObj.isSelected = "0"
                empObj.isCheckedInRoaster = "0"
                SelectedEmployeeList.remove(empObj)
                
            }else{
                empObj.isSelected = "1"
                empObj.isCheckedInRoaster = "1"
                SelectedEmployeeList.add(empObj)
            }
            EmployeeList.replaceObject(at: indexPath.row, with: empObj)

        tableView.reloadData()
    }
    
    //MARK: BUTTON ACTIONs
     @IBAction func moveUpBtnTapped(_ sender: UIButton){
        if SelectedEmployeeList == EmployeeList{
            //nothing to move up
        }else{
            
            var indexOfObj = -1
            
            let indexArray = NSMutableArray()
            for e in SelectedEmployeeList{
                let  eObj:NewEmployee = e as! NewEmployee
                let eObjCandID = eObj.CandidateId
                for emp in EmployeeList{
                    let  empObj:NewEmployee = emp as! NewEmployee
                    let empObjCandID = empObj.CandidateId
                    if eObjCandID == empObjCandID{
                        indexOfObj = EmployeeList.index(of: eObj)
                        if indexArray.contains(indexOfObj){}else{
                            indexArray.add(indexOfObj)}
                    }
                }
            }
             let a = NSArray.init(array: indexArray)
            let sortedArray = a.ascendingArrayWithKeyValue(key: "")
            
             if sortedArray.contains(0){
                //if any element is on top no need to move up again
            }else{
                //decrease indexpath of array and reload tableview
                var index = -1
                for i  in sortedArray{
                    index = Int(String(describing: i))!
                    //                    print(index)
                    if index > 0 {
                        swap(&EmployeeList[index], &EmployeeList[index - 1])
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.empTableView.reloadData()
                    })
                }
            }
            
        }//end of else
        
    }
    @IBAction func moveDownBtnTapped(_ sender: UIButton){
        if SelectedEmployeeList == EmployeeList{
            //nothing to move down
        }else{
            var indexOfObj = -1
            let indexArray = NSMutableArray()
            for e in SelectedEmployeeList{
                let  eObj:NewEmployee = e as! NewEmployee
                let eObjCandID = eObj.CandidateId
                for emp in EmployeeList{
                    let  empObj:NewEmployee = emp as! NewEmployee
                    let empObjCandID = empObj.CandidateId
                    if eObjCandID == empObjCandID{
                        indexOfObj = EmployeeList.index(of: eObj)
                        if indexArray.contains(indexOfObj){}else{
                            indexArray.add(indexOfObj)}
                    }
                }
            }
            //            print(indexArray)
            
            let a = NSArray.init(array: indexArray)
            let sortedArray = a.discendingArrayWithKeyValue(key: "")
            
            //            print(sortedArray)
            
            if sortedArray.contains(EmployeeList.count - 1){
                //if any element is on down no need to move down again
            }else{
                //increase indexpath of array and reload tableview
                var index = -1
                for i  in sortedArray{
                    index = Int(String(describing: i))!
                    //                    print(index)
                    if EmployeeList.count - 1 > index {
                        swap(&EmployeeList[index], &EmployeeList[index + 1])
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.empTableView.reloadData()
                    })
                }
            }
            
        }//end of else
    }
    
     @IBAction func clearEntryBtnTapped(_ sender: UIButton){
        
        
        for emp in SelectedEmployeeList {
            let  empObj:NewEmployee = emp as! NewEmployee
            if EmployeeList.contains(empObj){
                empObj.isCheckedInRoaster = "0"
                empObj.isSelected = "0"
                EmployeeList.remove(empObj)
            }
        }
         SelectedEmployeeList.removeAllObjects()
        
        empTableView.reloadData()
        
    }
    @IBAction func clearAllBtnTapped(_ sender: UIButton){
        
        for emp in EmployeeList {
            let  empObj:NewEmployee = emp as! NewEmployee
            empObj.isSelected = "0"
            EmployeeList.remove(empObj)
        }
        EmployeeList.removeAllObjects()
        SelectedEmployeeList.removeAllObjects()
        empTableView.reloadData()
        
        
    }
    @IBAction func DoneBtnTapped(_ sender: UIButton){
        if SelectedEmployeeList.count > 0{
        }else{
//            self.ShowAlertMessage(message: "Please select candidate before submitting.", title: "")
        }
        delegate?.selectedEmployeeOrder(EmployeeList)
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func closeBtnTapped(_ sender: UIButton){
        delegate?.selectedEmployeeOrder(EmployeeList)

        self.dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
print("deinit method is called")
    }

}
