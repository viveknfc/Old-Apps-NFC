//
//  ViewPayStubTableViewCell.swift
//  EWA
//
//  Created by NFC India on 25/09/18.
//  Copyright © 2018 NFC. All rights reserved.
//

import UIKit

class ViewPayStubTableViewCell: UITableViewCell {
    
    @IBOutlet weak var legalName: UILabel!
    @IBOutlet weak var localOffice: UILabel!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var ssnNumber: UILabel!
    @IBOutlet weak var payPeriod: UILabel!
    @IBOutlet weak var checkDate: UILabel!
    @IBOutlet weak var checkNumber: UILabel!
    @IBOutlet weak var grossPay: UILabel!
    @IBOutlet weak var fica: UILabel!
    @IBOutlet weak var medicare: UILabel!
    @IBOutlet weak var fit: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var disabilitypay: UILabel!
    @IBOutlet weak var fortyOneK: UILabel!
    @IBOutlet weak var totalHour: UILabel!
    @IBOutlet weak var totalDandA: UILabel!
    @IBOutlet weak var netpay: UILabel!
    @IBOutlet weak var ytdGross: UILabel!
    @IBOutlet weak var ficaYTD: UILabel!
    @IBOutlet weak var medicareYTD: UILabel!
    @IBOutlet weak var fitYTD: UILabel!
    @IBOutlet weak var ytdState: UILabel!
    @IBOutlet weak var ytdCity: UILabel!
    @IBOutlet weak var ytdDisability: UILabel!
    @IBOutlet weak var ytdForOneK: UILabel!
    @IBOutlet weak var earningsTableView: UITableView!
    @IBOutlet weak var miscTableView: UITableView!
    var earningsArray = [Earnings]()
    var miscArray = [MiscAdjustments]()
    var clientDetails = [ClientDetails]()
    @IBOutlet weak var earningsConstant: NSLayoutConstraint!
    @IBOutlet weak var miscConstrain: NSLayoutConstraint!
    @IBOutlet weak var noteLabel: PaddingLabel!
    
    @IBOutlet weak var caAH: UILabel!
    @IBOutlet weak var sfAH: UILabel!
    @IBOutlet weak var okAH: UILabel!
    @IBOutlet weak var emAH: UILabel!
    
    @IBOutlet weak var caACH: UILabel!
    @IBOutlet weak var sfACH: UILabel!
    @IBOutlet weak var okACH: UILabel!
    @IBOutlet weak var emACH: UILabel!
    
    @IBOutlet weak var codeTableView: UITableView!
    
    @IBOutlet weak var codeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paidSickLeave: UIView!
    
    @IBOutlet weak var paidSickLeaveHeight: NSLayoutConstraint!
    @IBOutlet weak var paidSickAmountLabel: UILabel!
    @IBOutlet weak var payPeriodHours: UILabel!
    
    @IBOutlet weak var paidSickTotalBalanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//UITableView DataSource and Delegate Methods

extension ViewPayStubTableViewCell:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == codeTableView
        {
            return 220
        }
        else if tableView == miscTableView
        {
            return 40
        }
        else
        {
            return 50
        }
    }
}
extension ViewPayStubTableViewCell:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == earningsTableView
        {
            return earningsArray.count
        }
        else if tableView == codeTableView
        {
            return clientDetails.count
        }
        else
        {
            return miscArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == miscTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"mCell") as! MiscAdjTableViewCell
            cell.descriLabel.text = miscArray[indexPath.row].adjustments
            cell.amountLabel.text = miscArray[indexPath.row].ytd
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == codeTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"pcCell") as! PayStubCodeTableViewCell
            cell.code.text = " "+clientDetails[indexPath.row].code
            cell.clientName.text = " "+clientDetails[indexPath.row].clientName
            cell.clientAddress.text = " "+clientDetails[indexPath.row].clientAddress
            cell.clientPhone.text = " "+clientDetails[indexPath.row].clientPhone
            cell.regRate.text = " "+clientDetails[indexPath.row].regRate
            cell.otRate.text = " "+clientDetails[indexPath.row].otRate
            cell.doubleTime.text = " "+clientDetails[indexPath.row].doubleTimeRate
            cell.totalHours.text = " "+clientDetails[indexPath.row].totalHours
            cell.selectionStyle = .none
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:"eCell") as! EarningsTableViewCell
            if earningsArray[indexPath.row].code == "0"
            {
                cell.code.text = ""
            }
            else
            {
                cell.code.text = earningsArray[indexPath.row].code
            }
            cell.division.text = earningsArray[indexPath.row].division
            cell.descri.text = earningsArray[indexPath.row].description
            cell.unit.text = earningsArray[indexPath.row].units
            cell.rate.text = earningsArray[indexPath.row].rate
            cell.earnings.text = earningsArray[indexPath.row].earnings
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    
    
    
}


