//
//  FirstPageViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/3.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    var pageTitle_View = UIView()
    var welcome_Label = UILabel()
    
    var tableView1 = UITableView()
    var tableView2 = UITableView()
    var summary_View = UIView()
    
    var rowHeight = AppDelegate.itemHeight*1.5
    var headerHeight = AppDelegate.itemHeight*1.5
    
//    private var mainSelectedObserver: NSObjectProtocol?
//    private var redSelectedObserver: NSObjectProtocol?
//    private var greenSelectedObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** welcome page ****")

        setBackground()
        setPageTitle_View()
        setWelcome_Label()
        
        setTableViwe1()
        setTableViwe2()
        setSummaryView()
        
        tableView1.alpha = 0
        tableView2.alpha = 0
        summary_View.alpha = 0
        YLShowViewWithAnimation.show(view: tableView1)
        YLShowViewWithAnimation.show(view: tableView2)
        YLShowViewWithAnimation.show(view: summary_View)
        
        YLViewShadow.setTableViewShadow(tableView: tableView1)
        YLViewShadow.setTableViewShadow(tableView: tableView2)
        YLViewShadow.setViewShadow(view: summary_View)
        
        NotificationCenter.default.addObserver(forName: Notification.Name("changedTheme"), object: nil, queue: nil) { notification in
            self.reload()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackground(){
        view.backgroundColor = UIColor.white
        YLViewShadow.setViewControllerShadow(viewController: self)
    }
    
    func setPageTitle_View (){
        pageTitle_View = YLPageTitleView(title: "Home")
        view.addSubview(pageTitle_View)
    }
    
    func setWelcome_Label(){
        let firstName = AppDelegate.userStandardUserDefaults.string(forKey: "firstNameDefault")!
        let lastName = AppDelegate.userStandardUserDefaults.string(forKey: "lastNameDefault")!
        welcome_Label.text = "Welcome \(firstName) \(lastName). \nYou have logged in on your \(UIDevice.current.name)."
        welcome_Label.textColor = AppDelegate.companyGrey_Color
        welcome_Label.font = AppDelegate.fontTitle
        welcome_Label.textAlignment = .center
        
        let welcome_LabelWidth = view.frame.size.width - AppDelegate.margin*2
        let welcome_LabelHeight = AppDelegate.itemHeight
        let x = AppDelegate.margin
        let y = pageTitle_View.frame.origin.y + pageTitle_View.frame.size.height + AppDelegate.margin
        let frame = CGRect(x:x,y:y,width:welcome_LabelWidth, height:welcome_LabelHeight)
        welcome_Label.frame = frame
        view.addSubview(welcome_Label)
    }
    
    
    func setTableViwe1(){
        tableView1 = UITableView()
        let height = rowHeight+headerHeight
        let y = welcome_Label.frame.origin.y + welcome_Label.frame.size.height + AppDelegate.margin
        tableView1 = YLTableViewForWelcome(y: y, height: height)
        
        //设置数据源和代理
        tableView1.dataSource = self
        tableView1.delegate = self
        view.addSubview(tableView1)
    }
    
    func setTableViwe2(){
        tableView2 = UITableView()
        let height = rowHeight + headerHeight
        let y = tableView1.frame.origin.y + tableView1.frame.size.height + AppDelegate.margin
        tableView2 = YLTableViewForWelcome(y: y, height: height)
        
        //设置数据源和代理
        tableView2.dataSource = self
        tableView2.delegate = self
        view.addSubview(tableView2)

    }
    
    //代理设置cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell") as UITableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if tableView == tableView1 {
            cell.textLabel?.attributedText = makeAttributedString(title: "Available funds", subtitle: "$ 2,042.45")
        }
        else if tableView == tableView2{
            cell.textLabel?.attributedText = makeAttributedString(title: "Available funds", subtitle: "$ 48,675.80")
        }
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 2
        //cell.backgroundColor = AppDelegate.companyGrey_Color
        cell.textLabel?.textColor = UIColor.red
        cell.textLabel?.font = AppDelegate.fontContent
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerCell")
        //let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
        let imageView = UIImageView()
        let image_X = AppDelegate.margin
        let image_Y = CGFloat(0)
        let image_Width = headerHeight
        let image_Height = headerHeight
        let image_Frame = CGRect(x:image_X,y:image_Y,width:image_Width,height:image_Height)
        imageView.frame=image_Frame
        headerCell?.addSubview(imageView)
        
        let label = UILabel()
        let label_X = imageView.frame.origin.x+imageView.frame.size.width
        let label_Y = CGFloat(0)
        let label_Width = tableView1.frame.size.width - image_Width - AppDelegate.margin*2
        let label_Height = headerHeight
        let label_Frame = CGRect(x:label_X,y:label_Y,width:label_Width,height:label_Height)
        label.frame = label_Frame
        label.textColor = AppDelegate.companyGrey_Color
        label.font = AppDelegate.fontTitle
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        headerCell?.layer.backgroundColor = AppDelegate.lightestGrey_Color.withAlphaComponent(0.6).cgColor
        headerCell?.addSubview(label)
        
        //headerCell?.layer.borderWidth = 0.7
        //headerCell?.layer.borderColor = AppDelegate.companyGrey_Color.cgColor
        
        if tableView == tableView1{
            label.attributedText = makeAttributedString(title: "Smart Account", subtitle: "060-101 4533 2958")
            imageView.image = UIImage(named: "account")
        } else if tableView == tableView2{
            label.attributedText = makeAttributedString(title: "NetBank Saver", subtitle: "060-101 6839 1048")
            imageView.image = UIImage(named: "account")
        }
        return headerCell
    }
    
    func setSummaryView(){
        summary_View = UIView()
        let width = view.frame.size.width - AppDelegate.margin*2
        let height = rowHeight
        let x = AppDelegate.margin
        let y = tableView2.frame.origin.y+tableView2.frame.size.height + AppDelegate.margin
        let frame = CGRect(x:x, y:y, width:width, height:height)
        summary_View.frame = frame
        summary_View.backgroundColor = AppDelegate.companyRed_Color
//        summary_View.layer.cornerRadius = 3
        summary_View.layer.masksToBounds = false
        view.addSubview(summary_View)
        
//        let credits_View = UIView()
//        let creditsWidth = width/3*2
//        let creditsHeigh = height
//        let creditsX = CGFloat(0)
//        let creditsY = CGFloat(0)
//        let creditsFrame = CGRect(x: creditsX, y: creditsY, width:creditsWidth, height: creditsHeigh)
//        credits_View.frame = creditsFrame
//        credits_View.backgroundColor = AppDelegate.companyRed_Color
//        summary_View.addSubview(credits_View)
//        
//        let debits_View = UIView()
//        let debitsWidth = width/3
//        let debitsHeigh = height
//        let debitsX = creditsWidth
//        let debitsY = CGFloat(0)
//        let debitsFrame = CGRect(x: debitsX, y: debitsY, width:debitsWidth, height: debitsHeigh)
//        debits_View.frame = debitsFrame
//        debits_View.backgroundColor = AppDelegate.companyGrey_Color
//        summary_View.addSubview(debits_View)
//        
//        let labelWidth = debitsWidth - AppDelegate.margin*2
//        let labelHeight = height
//        let labelX = AppDelegate.margin
//        let labelY = CGFloat(0)
//        let labelFrame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
//        
//        let credits_Label = UILabel(frame: labelFrame)
//        credits_Label.attributedText = makeAttributedString(title: "Total credits", subtitle: "$ 92475.20")
//        credits_Label.textColor = UIColor.white
//        credits_Label.lineBreakMode = .byWordWrapping
//        credits_Label.numberOfLines = 2
//        credits_View.addSubview(credits_Label)
//        
//        let debits_Label = UILabel(frame: labelFrame)
//        debits_Label.attributedText = makeAttributedString(title: "Total debits", subtitle: "$ 0.0")
//        debits_Label.textColor = UIColor.white
//        debits_Label.lineBreakMode = .byWordWrapping
//        debits_Label.numberOfLines = 2
//        debits_View.addSubview(debits_Label)
        
        
        let labelWidth = width - AppDelegate.margin*2
        let labelHeight = height
        let labelX = AppDelegate.margin
        let labelY = CGFloat(0)
        let labelFrame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        let label = UILabel(frame: labelFrame)
        label.attributedText = makeAttributedString(title: "Total funds", subtitle: "$ 50,718.25")
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        summary_View.addSubview(label)
        
    }
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): AppDelegate.fontTitle, convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): AppDelegate.companyGrey_Color] as [String : Any]
        let subtitleAttributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font):  AppDelegate.fontContent,convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): AppDelegate.companyGrey_Color] as [String : Any]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: convertToOptionalNSAttributedStringKeyDictionary(titleAttributes) )
        let subtitleString = NSAttributedString(string: subtitle, attributes: convertToOptionalNSAttributedStringKeyDictionary(subtitleAttributes))
        
        titleString.append(subtitleString)
        
        return titleString
    }
    
    func reload(){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        for view in self.tableView1.subviews {
            view.removeFromSuperview()
        }
        for view in self.tableView2.subviews {
            view.removeFromSuperview()
        }
        for view in self.summary_View.subviews {
            view.removeFromSuperview()
        }
        setBackground()
        setPageTitle_View()
        setWelcome_Label()
        
        setTableViwe1()
        setTableViwe2()
        setSummaryView()
        
        tableView1.alpha = 0
        tableView2.alpha = 0
        summary_View.alpha = 0
        YLShowViewWithAnimation.show(view: tableView1)
        YLShowViewWithAnimation.show(view: tableView2)
        YLShowViewWithAnimation.show(view: summary_View)
        
        YLViewShadow.setTableViewShadow(tableView: tableView1)
        YLViewShadow.setTableViewShadow(tableView: tableView2)
        YLViewShadow.setViewShadow(view: summary_View)
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
