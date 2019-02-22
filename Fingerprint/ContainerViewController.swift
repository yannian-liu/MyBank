import UIKit

class ContainerViewController: UIViewController {
    var isFromRegisterPage = Bool()
    fileprivate var menuButtonTapped: NSObjectProtocol?
    var menuChild_ViewControllerArray = [UIViewController]()

    var leftViewController: UIViewController? {
        willSet{
            if self.leftViewController != nil {
                if self.leftViewController!.view != nil {
                    self.leftViewController!.view!.removeFromSuperview()
                }
                self.leftViewController!.removeFromParent()
            }
        }
        
        didSet{
            
            self.view!.addSubview(self.leftViewController!.view)
            self.addChild(self.leftViewController!)
        }
    }
    
    var rightViewController: UIViewController? {
        willSet {
            if self.rightViewController != nil {
                if self.rightViewController!.view != nil {
                    self.rightViewController!.view!.removeFromSuperview()
                }
                self.rightViewController!.removeFromParent()
            }
        }
        
        didSet{
            
            self.view!.addSubview(self.rightViewController!.view)
            self.addChild(self.rightViewController!)
        }
    }
    
    var tempViewController: UIViewController? {
        willSet{
            if self.tempViewController != nil {
                if self.tempViewController!.view != nil {
                    self.tempViewController!.view!.removeFromSuperview()
                }
                self.tempViewController!.removeFromParent()
            }
        }
        
        didSet{
            
            self.view!.addSubview(self.tempViewController!.view)
            self.addChild(self.tempViewController!)
        }
    }
    
    var menuShown: Bool = false
    var swipeRight_SwipeGR = UISwipeGestureRecognizer()
    var swipeLeft_SwipeGR = UISwipeGestureRecognizer()
    
    var menu_Button : YLMenuButton!
    var menu_Buttonframe_init: CGRect!
    var menu_Buttonframe_changed: CGRect!
    
    var menuMove_Float : CGFloat!
    
    var bubble_View: UIView!

    
//    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
//        showMenu()
//        
//    }
//    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
//        hideMenu()
//    }
//    
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        showMenu()
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        hideMenu()
    }
    
    
    @objc func showMenu() {
        hideBubble_View()
        UIView.animate(withDuration: 0.3, animations: {
            self.rightViewController!.view.frame = CGRect(x: self.view.frame.origin.x + self.menuMove_Float, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            self.menu_Button.frame = self.menu_Buttonframe_changed
        }, completion: { (Bool) -> Void in
            self.menuShown = true
        })
    }
    
    @objc func hideMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.rightViewController!.view.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            self.menu_Button.frame = self.menu_Buttonframe_init
        }, completion: { (Bool) -> Void in
            self.menuShown = false
        })
        self.view.bringSubviewToFront(self.menu_Button);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** container page ****")

        menuMove_Float = view.frame.size.width/5*4
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // FOLLOE MAYBE UINavigationController
        let welcomeController: UIViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        let menuViewController: MenuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController")as! MenuViewController

        self.leftViewController = menuViewController
        self.rightViewController = welcomeController
        
        let menuChild0_ViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController")
        let menuChild1_ViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "ChangePinViewController")
        let menuChild3_ViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "ManageDevicesViewController")
        let menuChild4_ViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController")
        
        
        menuChild_ViewControllerArray = [menuChild0_ViewController,menuChild1_ViewController,menuChild4_ViewController,menuChild3_ViewController,menuChild4_ViewController,]
        
        for i in 0...menuChild_ViewControllerArray.count-1 {
            NotificationCenter.default.addObserver(forName: Notification.Name("selected_\(i)"), object: nil, queue: nil) { notification in
                
                // menuChild_ViewControllerArray[1] is the changePinViewController, if access changePinViewController again, it will be reload.
                if i == 1{
                    if self.rightViewController != self.menuChild_ViewControllerArray[i]  {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetChangePinViewController"), object: self)
                    }
                }
                
                self.menuChild_ViewControllerArray[i].view.frame = (self.rightViewController?.view.frame)!
                self.rightViewController = self.menuChild_ViewControllerArray[i]
                self.hideMenu()
            }

        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("menu_ButtonTapped"), object: nil, queue: nil) { notification in
            if(self.menuShown) {
                self.menuShown = false
                self.hideMenu()
            } else if(self.menuShown == false){
                self.menuShown = true
                self.showMenu()
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("ContainerToPinAuth"), object: nil, queue: nil) { notification in
            print("@ log out from container @")
            //YLLogOutClearance.clearAll()
            
            self.performSegue(withIdentifier: "ContainerToPinAuth_Segue", sender: notification)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("goHome"), object: nil, queue: nil) { notification in
            print("@ go home @")

            self.tempViewController = welcomeController
            self.tempViewController?.view.frame = CGRect(x: self.view.frame.size.width, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)

            
            UIView.animate(withDuration: 0.3, animations: {
                welcomeController.view.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: { (Bool) -> Void in
                self.rightViewController = welcomeController
                self.menu_Button.frame = self.menu_Buttonframe_init
                self.menuShown = false
                self.view.bringSubviewToFront(self.menu_Button);

            })
        }

        initBubble_View()
        initMenu_Button()


    }
    
    func initMenu_Button(){
        let menu_ButtonWidth = CGFloat(30.0)
        let menu_ButtonHeight = CGFloat(30.0)
        menu_Buttonframe_init = CGRect(x: self.view.frame.origin.x + 20, y:self.view.frame.origin.y+25, width: menu_ButtonWidth, height: menu_ButtonHeight)
        menu_Buttonframe_changed = CGRect(x: self.view.frame.origin.x + 20 + menuMove_Float, y:self.view.frame.origin.y+25, width: menu_ButtonWidth, height: menu_ButtonHeight)
        
        menu_Button = YLMenuButton(frame: menu_Buttonframe_init)
        view.addSubview(menu_Button)
    }
    
    func initBubble_View(){
        let viewWidth = view.frame.size.width
        let viewHeight = view.frame.size.height - CGFloat(70)
        let viewX = CGFloat(0)
        let viewY = CGFloat(70)
        let viewFrame = CGRect(x:viewX, y:viewY, width:viewWidth, height:viewHeight)
        bubble_View = UIView(frame: viewFrame)
        
        let bubbleBackground_View = YLBackground()
        bubbleBackground_View.setBlurEffect()
        bubble_View.addSubview(bubbleBackground_View)
        
        let bubbleImageWidth = CGFloat(150)
        let bubbleImageHeight = CGFloat(120)
        let bubbleImageX = AppDelegate.margin*4
        let bubbleImageY = AppDelegate.margin*2
        let bubbleImageFrame = CGRect(x:bubbleImageX, y:bubbleImageY, width: bubbleImageWidth, height:bubbleImageHeight)
        
        let bubbleImageView = YLBubbleView(frame: bubbleImageFrame)
        bubble_View.addSubview(bubbleImageView)
        
        if isFromRegisterPage == true {
            bubble_View.isHidden = false
        } else {
            bubble_View.isHidden = true
        }
        view.addSubview(bubble_View)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideBubble_View()
    }
    
    func hideBubble_View(){
        UIView.animate(withDuration: 0.3, animations: {
            self.bubble_View.alpha = 0
        }, completion: { _ in
            self.bubble_View.isHidden = true
        })
    }

}
