//
//  TollChargesViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 29/06/2021.
//

import UIKit

class TollChargesViewController: UIViewController, Storyboarded, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let vehicleTypes = ["Car (F1)", "Wagon (F2)", "Coaster (F3)", "Bus (F4)", "Truck 2/3 Axle (F5)", "Trailer (F6)"]
    let motorways = ["M-1 Toll Charges", "M-2 Toll Charges", "M-3 Toll Charges", "M-9 Toll Charges"]
    let motorwayCode = ["M1", "M2", "M3", "M9"]
    let vehicleTypeCode = ["F1", "F2", "F3", "F4", "F5", "F6"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TollChargesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TollChargesTableViewCell.identifier)

        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "tollCharges".localized()
    }

    @IBAction func backPressed(_ sender: UIButton) {
        Router.pop(from: self)
    }
}


extension TollChargesViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return motorwayCode.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleTypeCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TollChargesTableViewCell.identifier, for: indexPath) as! TollChargesTableViewCell
        cell.configure(title: vehicleTypes[indexPath.row])
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HistoryTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = ColorConstants.white
        let label = UILabel()
        label.frame = CGRect.init(x: 30, y: 10, width: headerView.frame.width / 2, height: headerView.frame.height-10)
        label.text = motorways[section]
        label.font = FontConstants.bold?.withSize(16)
        label.textColor = ColorConstants.orange
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var link = ApiConstants.url + "static/TOLL_RATES_PDF/MOTORWAY_CODE/VEHCILE_CODE.pdf"
        link = link.replacingOccurrences(of: "MOTORWAY_CODE", with: motorwayCode[indexPath.section])
        link = link.replacingOccurrences(of: "VEHCILE_CODE", with: vehicleTypeCode[indexPath.row])
        Router.showWebView(from: self, with: link)
    }
    
}
