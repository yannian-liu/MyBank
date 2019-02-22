//
//  YLPinViewController.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/9.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

//
//  PinPageLayout.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/12.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit


class YLPinViewController: UIViewController {
    var background_View = YLBackground(imageName: "pinBackground")
    var wrong_View = UIView()
    
    var n1_Button = UIButton()
    var n2_Button = UIButton()
    var n3_Button = UIButton()
    var n4_Button = UIButton()
    var n5_Button = UIButton()
    var n6_Button = UIButton()
    var n7_Button = UIButton()
    var n8_Button = UIButton()
    var n9_Button = UIButton()
    var n0_Button = UIButton()
    var fingerprint_Button = UIButton()
    var delete_Button = UIButton()
    var keyboardPanel_View = UIView()
    
    var pinPanel_View = UIView()
    var pin1_ImageView = UIImageView()
    var pin2_ImageView = UIImageView()
    var pin3_ImageView = UIImageView()
    var pin4_ImageView = UIImageView()
    
    var pin_IntArray = [Int]()
    var pinCreat1_IntArray = [Int]()
    var pinCreat2_IntArray = [Int]()
    // 1 is for first created pin, 2 is for second created pin
    var pinCreatIndex = 0
    
    var pinBig_Png = UIImage(named: "pinBig")
    var pinSmall_Png = UIImage(named: "pinSmall")
    
    var title_Label = UILabel()
    var hint_Label = UILabel()
    
    var logOut_Button = UIButton()
    var forgotPin_Button = UIButton()
    
    var request_JsonObject:NSMutableDictionary = NSMutableDictionary()
    
    var isJustWrong = false
    
    var error_Label = UILabel()
    var loading_AIView = YLActivityIndicatorView(frame: CGRect(x: 0,y:0,width: CGFloat(0),height:CGFloat(0)))

    
    let topColorWrong: UIColor = UIColor(red:224.0/255.0, green:102.0/255.0, blue: 102.0/255.0, alpha: 1)
    let bottomColorWrong: UIColor = UIColor(red: (234/255.0), green: (153/255.0), blue: (153/255.0), alpha: 1)
    
    var isAllowTouchIdAuth = false
    
    override func viewDidLoad() {
        print("\n**** pin view controller ****")
        print(": have pin: ", AppDelegate.userStandardUserDefaults.bool(forKey: "pinStatusDefault"))
        
        pinCreatIndex = setInitialPinCreateIndex()
        // ********** Set Background ********** //
        setInitialBackground()
        
        // ********** Set wrong Background ********** //
        setWrongBackground()
        
        // ********** Set number button ********** //
        setNumberButton()
        
        // ********** Set pin area ********** //
        setInitialPinArea()
        
        // ********** Set title label ********** //
        setInitialTitle_Label()
        title_Label.text = setInitialTitleLabelText()        
        
        // ********** Set hint label ********** //
        setInitialHint_Label()
        //setHint_Label()
        
        // ********** Set logOut_Button ********** //
        setTopLeftButton()
        // ********** Set forgotPin_Button ********** //
        setTopRightButton()
        
        // ********** Set initError_Label ********** //
        initError_Label()
        
        // ********** Layout of loading activity indicator ********** //
        initAIView()
        
        
        NotificationCenter.default.addObserver(forName: Notification.Name("resetChangePinViewController"), object: nil, queue: nil) { notification in
            
            self.reset()
        }
        authTouchIDAsDefaultAction()
        
        fingerprint_Button.isHidden = isFingerprintButtonHidden()

    }
    
    func setInitialBackground(){
        background_View.setBlurEffect()
        self.view.addSubview(background_View)
        //self.view.backgroundColor = AppDelegate.companyGrey_Color
        YLViewShadow.setViewControllerShadow(viewController: self)

    }
    
    func setWrongBackground(){
        wrong_View.frame = self.view.frame
        wrong_View.backgroundColor = self.topColorWrong
        wrong_View.alpha = 0.3
        wrong_View.isHidden = true
        self.view.addSubview(wrong_View)
    }
    
    
    func initError_Label(){
        let y = hint_Label.frame.origin.y+hint_Label.frame.size.height
        error_Label = YLErrorLabel(y: y)
        self.view.addSubview(self.error_Label)
    }
    
    func initAIView(){
        let loading_AIViewWidth = view.frame.size.width
        let loading_AIViewHeight = loading_AIViewWidth
        let y = keyboardPanel_View.frame.origin.y+keyboardPanel_View.frame.size.height*3/8 - loading_AIViewHeight/2
        let loading_AIViewframe = CGRect(x: 0, y: y, width:loading_AIViewWidth, height:loading_AIViewHeight)
        
        let color_UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        loading_AIView = YLActivityIndicatorView(frame: loading_AIViewframe, type:.ballScaleMultiple, color: color_UIColor, padding: 20)
        self.view.addSubview(loading_AIView)
    }
    
    func setNumberButton(){
        
        // decide the keyboard size according to device (ipad or iphone)
        if self.view.frame.size.width <= 414 {
            let keyboardPanel_Width = self.view.frame.size.width - AppDelegate.margin*8
            let keyboardPanel_Height = keyboardPanel_Width*4/3
            let keyboardPanel_Rect = CGRect(x: (self.view.frame.size.width - keyboardPanel_Width)/2,
                                            y: self.view.frame.size.height - keyboardPanel_Height - AppDelegate.margin * 2,
                                            width: keyboardPanel_Width, height: keyboardPanel_Height)
            keyboardPanel_View.frame = keyboardPanel_Rect
            
            
        } else {
            let keyboardPanel_Width = self.view.frame.size.width/2
            let keyboardPanel_Height = keyboardPanel_Width*4/3
            let keyboardPanel_Rect = CGRect(x: (self.view.frame.size.width - keyboardPanel_Width)/2,
                                            y: (self.view.frame.size.height - keyboardPanel_Height)/2,
                                            width: keyboardPanel_Width, height: keyboardPanel_Height)
            
            
            keyboardPanel_View.frame = keyboardPanel_Rect
        }
        
        self.view.addSubview(keyboardPanel_View)
        
        // decide button layout and function
        let n1_Png = UIImage(named: "n1")
        let n2_Png = UIImage(named: "n2")
        let n3_Png = UIImage(named: "n3")
        let n4_Png = UIImage(named: "n4")
        let n5_Png = UIImage(named: "n5")
        let n6_Png = UIImage(named: "n6")
        let n7_Png = UIImage(named: "n7")
        let n8_Png = UIImage(named: "n8")
        let n9_Png = UIImage(named: "n9")
        let fingerprint_Png = UIImage(named: "fingerprint")
        let n0_Png = UIImage(named: "n0")
        //let delete_Png = UIImage(named: "delete")
        
        let n1w_Png = UIImage(named: "n1w")
        let n2w_Png = UIImage(named: "n2w")
        let n3w_Png = UIImage(named: "n3w")
        let n4w_Png = UIImage(named: "n4w")
        let n5w_Png = UIImage(named: "n5w")
        let n6w_Png = UIImage(named: "n6w")
        let n7w_Png = UIImage(named: "n7w")
        let n8w_Png = UIImage(named: "n8w")
        let n9w_Png = UIImage(named: "n9w")
        let fingerprintw_Png = UIImage(named: "fingerprintw")
        let n0w_Png = UIImage(named: "n0w")
        //let deletew_Png = UIImage(named: "deletew")
        let keyboard_ButtonArray = [n1_Button, n2_Button, n3_Button, n4_Button, n5_Button,n6_Button, n7_Button, n8_Button, n9_Button,fingerprint_Button, n0_Button,  delete_Button]
        let keyboard_ImangeArray = [n1_Png, n2_Png, n3_Png, n4_Png, n5_Png, n6_Png, n7_Png, n8_Png,n9_Png,  fingerprint_Png, n0_Png, nil]
        let keyboard_ImangeWhiteArray = [n1w_Png, n2w_Png, n3w_Png, n4w_Png, n5w_Png, n6w_Png, n7w_Png, n8w_Png,n9w_Png,  fingerprintw_Png, n0w_Png, nil]
        
        let buttonCellWeight = keyboardPanel_View.bounds.width / 3.0
        let buttonCellHeight = keyboardPanel_View.bounds.height / 4.0
        
        let button_Rect = CGRect(x: 0, y: 0, width: buttonCellWeight, height: buttonCellHeight)
        
        for j in 0..<4 {
            for i in 0..<3 {
                let buttonCell_Rect = CGRect(x: buttonCellWeight * CGFloat(i),
                                             y: buttonCellHeight * CGFloat(j),
                                             width: buttonCellWeight, height: buttonCellHeight)
                let buttonCell_View = UIView()
                buttonCell_View.translatesAutoresizingMaskIntoConstraints = false
                buttonCell_View.frame = buttonCell_Rect
                //buttonCell_View.layer.borderWidth = 0.5
                buttonCell_View.layer.borderColor = UIColor.gray.cgColor
                keyboardPanel_View.addSubview(buttonCell_View)
                
                keyboard_ButtonArray[i + j*3].frame = button_Rect
                keyboard_ButtonArray[i + j*3].setImage(keyboard_ImangeArray[i + j*3], for: .normal)
                keyboard_ButtonArray[i + j*3].setImage(keyboard_ImangeWhiteArray[i + j*3], for: .highlighted)
                buttonCell_View.addSubview(keyboard_ButtonArray[i + j*3])
                
            }
            
        }
        
        // delete button don't have image:
        keyboard_ButtonArray[11].setTitle("Delete", for: .normal)
        keyboard_ButtonArray[11].setTitleColor(UIColor.white, for: .normal)
        keyboard_ButtonArray[11].setTitleColor(UIColor.lightText, for: .highlighted)
        keyboard_ButtonArray[11].titleLabel?.font = AppDelegate.fontTitle
        
        // set button actions
        for i in 0...11 {
            keyboard_ButtonArray[i].tag = i
            if i<=8 || i == 10 {
                keyboard_ButtonArray[i].addTarget(self, action: #selector(self.number_ButtonAction), for: .touchDown)
            } else if i == 9 {
                keyboard_ButtonArray[i].addTarget(self, action: #selector(self.fingerprint_ButtonAction), for: .touchDown)
            } else {
                keyboard_ButtonArray[i].addTarget(self, action: #selector(self.delete_ButtonAction), for: .touchDown)
            }
        }
    }
    
    func setInitialPinArea(){
        let pin_ImageViewArray = [pin1_ImageView, pin2_ImageView, pin3_ImageView, pin4_ImageView]

        let pinWidth = view.frame.size.width/6.9
        let pinHeight = pinWidth
        
//        let pinPanelWidth = pinWidth.multiplied(by: 4)
        let pinPanelWidth = pinWidth*4
        let pinPanelHeight = pinHeight
        
        let pinPanel_Rect = CGRect(x: (self.view.frame.size.width - pinPanelWidth)/2, y: (keyboardPanel_View.frame.origin.y/2 ), width: pinPanelWidth, height: pinPanelHeight)
        pinPanel_View.frame = pinPanel_Rect
        self.view.addSubview(pinPanel_View)
        
        for i in 0...3 {
            pin_ImageViewArray[i].frame = CGRect(x: pinWidth * CGFloat(i), y: 0, width:pinWidth ,height:pinHeight)
            pin_ImageViewArray[i].image = pinSmall_Png
            pinPanel_View.addSubview(pin_ImageViewArray[i])
            
        }
    }
    
    
    func setInitialTitle_Label(){
        
        title_Label.textColor = UIColor.white
        title_Label.font = AppDelegate.fontContent
        title_Label.textAlignment = .center
        
        let title_LabelWidth = self.view.frame.size.width
        let title_LabelHeight = CGFloat(30)
        
        let title_LabelRect = CGRect(x: self.view.frame.origin.x, y:pinPanel_View.frame.origin.y - title_LabelHeight, width: title_LabelWidth, height:title_LabelHeight)
        title_Label.frame = title_LabelRect
        self.view.addSubview(title_Label)
    }
    
    func setInitialHint_Label(){
        hint_Label.isHidden = false
        hint_Label.text = ""
        hint_Label.textColor = UIColor.white
        hint_Label.font = AppDelegate.fontHint
        hint_Label.textAlignment = .center
        
        let hint_LabelWidth = self.view.frame.size.width
        let hint_LabelHeight = CGFloat(30)
        let hint_LabelRect = CGRect(x: self.view.frame.origin.x, y:pinPanel_View.frame.origin.y + pinPanel_View.frame.size.height, width: hint_LabelWidth, height:hint_LabelHeight)
        hint_Label.frame = hint_LabelRect
        self.view.addSubview(hint_Label)
    }
    
    
    @objc func number_ButtonAction(_ sender: AnyObject){
        var pinInput = 0
        if  sender.tag != nil && sender.tag <= 8 {
            pinInput = sender.tag + 1
        } else {
            pinInput = 0
        }
        pin_IntArray.append(pinInput)
        modifyPinArea()
        
    }
    
    // need to be orverride
    @objc func fingerprint_ButtonAction(_ sender: AnyObject){
        
    }
    
    
    @objc func delete_ButtonAction(_ sender: AnyObject){
        if pin_IntArray.count >= 1{
            pin_IntArray.remove(at: pin_IntArray.count-1)
            modifyPinArea()
        }
        
    }
    
    func modifyPinArea(){
        if pin_IntArray.count == 0{
            pin1_ImageView.image = pinSmall_Png
            pin2_ImageView.image = pinSmall_Png
            pin3_ImageView.image = pinSmall_Png
            pin4_ImageView.image = pinSmall_Png
            
            
        } else if pin_IntArray.count == 1 {
            pin1_ImageView.image = pinBig_Png
            pin2_ImageView.image = pinSmall_Png
            pin3_ImageView.image = pinSmall_Png
            pin4_ImageView.image = pinSmall_Png
            if isJustWrong == true {
                hint_Label.text = ""
                wrong_View.isHidden=true
                isJustWrong = false
            }
            
        } else if pin_IntArray.count == 2 {
            pin1_ImageView.image = pinBig_Png
            pin2_ImageView.image = pinBig_Png
            pin3_ImageView.image = pinSmall_Png
            pin4_ImageView.image = pinSmall_Png
        } else if pin_IntArray.count == 3 {
            pin1_ImageView.image = pinBig_Png
            pin2_ImageView.image = pinBig_Png
            pin3_ImageView.image = pinBig_Png
            pin4_ImageView.image = pinSmall_Png
        } else {
            pin1_ImageView.image = pinBig_Png
            pin2_ImageView.image = pinBig_Png
            pin3_ImageView.image = pinBig_Png
            pin4_ImageView.image = pinBig_Png
            connectServerWithPin()
        }
    }

    
    // need to be override
    func connectServerWithPin(){
        
    }
    
    func setTopLeftButton(){
    }
    func topLeftButtonAction (_ sender: AnyObject){
    }
    func setTopRightButton(){
    }
    func topRightButtonAction (_ sender: AnyObject){
    }
    // need to be override
    func reset(){
    }
    
    // need to be override
    func setInitialTitleLabelText()->String{
        return String()
    }
    
    func setInitialPinCreateIndex()->Int{
        return 0
    }
    
    func authTouchIDAsDefaultAction(){
        
    }
    
    func isFingerprintButtonHidden()->Bool{
        return false
    }
    

    
}
