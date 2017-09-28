//
//  FormVC.swift
//  connect
//
//  Created by Pivot Graphics on 26/09/2017.
//  Copyright © 2017 connect. All rights reserved.
//

import UIKit
import CoreData

class FormVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var companyTxt: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var addPhoneBtn: UIButton!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var addEmailBtn: UIButton!
    
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var websiteTxt: UITextField!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTxt: UITextField!
    
    @IBOutlet weak var socialsView: UIView!
    @IBOutlet weak var addSocialsBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var phoneNumberscount = 0
    var phoneNumbers: [String] = []
    
    var emailsCount = 0
    var emails: [String] = []
    
    var socialsCount = 0
    var socials: [String] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alignment()
        
        //phoneNumberTxt.delegate = self
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
      
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("Keyboard showing -- \(scrollView.frame.size.height) ")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            scrollView.frame.size.height = self.view.frame.height - keyboardSize.height
                print("Keyboard done -- \(scrollView.frame.size.height) - \(keyboardSize.height)")
        }
    }

    
    @IBAction func createContactBtn_click(_ sender: Any) {
        
        addContact()
    }
    

    
    func addItem(type: String, view: UIView, index: Int, keys: [String]){
        print("Adding")
        if index < 3 {
            let position: CGFloat = CGFloat(index*35)
            print("postion ------ \(position)")
            
            let title = UILabel(frame: CGRect(x: 0, y: position, width: 80, height: 30))
            title.text = "\(keys[index])   "
            title.font = UIFont.systemFont(ofSize: 13)
            title.backgroundColor = UIColor.white
            title.addRightBorder(UIColor.groupTableViewBackground, width: 1)
            title.sizeToFit()
            
            let text = UITextField(frame: CGRect(x: title.frame.size.width, y: position, width: view.frame.size.width - title.frame.size.width, height: 30))
            text.setLeftPaddingPoints(10)
            view.addSubview(title)
            view.addSubview(text)
            text.becomeFirstResponder()
            text.setBottomBorder()
            
            
            switch type {
            case "phone":
                UIView.animate(withDuration: 0.3, animations: ({
                    text.keyboardType = .numberPad
                    
                    self.phoneNumberView.frame.size.height = self.phoneNumberView.frame.size.height + 30
                    self.addPhoneBtn.frame.origin.y = self.addPhoneBtn.frame.origin.y + 35
                    
                    self.emailView.frame.origin.y = self.emailView.frame.origin.y + 30
                    self.websiteView.frame.origin.y = self.websiteView.frame.origin.y + 30
                    self.addressView.frame.origin.y = self.addressView.frame.origin.y + 30
                    self.socialsView.frame.origin.y = self.socialsView.frame.origin.y + 30
                    
                    self.scrollView.contentSize.height = self.scrollView.contentSize.height + 30
                }))
                
                phoneNumberscount = phoneNumberscount + 1
            
            case "email":
                text.keyboardType = UIKeyboardType.emailAddress
                UIView.animate(withDuration: 0.3, animations: ({
                    self.emailView.frame.size.height = self.emailView.frame.size.height + 35
                    self.addEmailBtn.frame.origin.y = self.addEmailBtn.frame.origin.y + 35
                    
                    self.websiteView.frame.origin.y = self.websiteView.frame.origin.y + 30
                    self.addressView.frame.origin.y = self.addressView.frame.origin.y + 30
                    self.socialsView.frame.origin.y = self.socialsView.frame.origin.y + 30
                    
                    self.scrollView.contentSize.height = self.scrollView.contentSize.height + 30
                }))
                
                emailsCount = emailsCount + 1
                
            case "social":
                UIView.animate(withDuration: 0.3, animations: ({
                    
                    print("Adding social \(index)")
                    
                    self.socialsView.frame.size.height = self.socialsView.frame.size.height + 35
                    self.addSocialsBtn.frame.origin.y = self.addSocialsBtn.frame.origin.y + 35
                    
                    self.addressView.frame.origin.y = self.addressView.frame.origin.y + 30
                    self.scrollView.contentSize.height = self.scrollView.contentSize.height + 30
                }))
                
                socialsCount = socialsCount + 1

            default:
                break
            }
            

            
            
        }
    }

    func addContact(){
        print("saving...")
        
        guard let _context = managedObjectContext else { return }

        // Using the Managed Object Context, lets create a new entry into entity "Task".
        let object = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: self.managedObjectContext!) as! Contact
        print(object)

        
        object.name = nameTxt.text?.firstUppercased
        object.last_name = lastNameTxt.text?.firstUppercased
        object.company = companyTxt.text?.firstUppercased

        //Extract Phone numbers
        for view in self.phoneNumberView.subviews as [UIView] {
            if let textField = view as? UITextField {

                phoneNumbers.append(textField.text!)
            }
        }

        switch phoneNumbers.count {
        case 1:
            object.personal_phone = phoneNumbers[0]
            object.work_phone = ""
            object.home_phone = ""
        case 2:
            object.personal_phone = phoneNumbers[0]
            object.work_phone = phoneNumbers[1]
            object.home_phone = ""
        case 3:
            object.personal_phone = phoneNumbers[0]
            object.work_phone = phoneNumbers[1]
            object.home_phone = phoneNumbers[2]
        default:
            object.personal_phone = ""
            object.work_phone = ""
            object.home_phone = ""
        }

        object.website = websiteTxt.text

        //Extract Emails
        for view in self.emailView.subviews as [UIView] {
            if let textField = view as? UITextField {

                emails.append(textField.text!)
            }
        }

        switch emails.count {
        case 1:
            object.email1 = emails[0]
            object.email2 = ""
            object.email3 = ""
        case 2:
            object.email1 = emails[0]
            object.email2 = emails[1]
            object.email3 = ""
        case 3:
            object.email1 = emails[0]
            object.email2 = emails[1]
            object.email3 = emails[2]
        default:
            object.email1 = ""
            object.email2 = ""
            object.email3 = ""
        }

        //Extract Socials
        for view in self.socialsView.subviews as [UIView] {
            if let textField = view as? UITextField {

                socials.append(textField.text!)
            }
        }

        switch socials.count {
        case 1:
            object.twitter = socials[0]
            object.facebook = ""
            object.linkdin = ""
        case 2:
            object.twitter = socials[0]
            object.facebook = socials[1]
            object.linkdin = ""
        case 3:
            object.twitter = socials[0]
            object.facebook = socials[1]
            object.linkdin = socials[2]
        default:
            object.twitter = ""
            object.facebook = ""
            object.linkdin = ""
        }

        object.address = addressTxt.text


        object.completed = false

        do {
            // Then we try to persist the new entry.
            // And if everything went successfull the fetched results controller
            // will react and from the delegate methods it will call the reload
            // of the table view.
            try _context.save()
            //tableView.reloadData()
            print("Saved!")
            let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("contactcreated"), object: nil)
                        self.navigationController?.popViewController(animated: true)
        } catch {
            print("not Saved")
        }

    }
    
    
    @IBAction func addPhoneBtn_click(_ sender: Any) {
        //addContact()
        addItem(type: "phone", view: phoneNumberView, index: phoneNumberscount, keys: ["Personal","Business","Home"])
    
    }

    @IBAction func addEmailBtn_click(_ sender: Any) {
        addItem(type: "email", view: emailView, index: emailsCount, keys: ["Email 1","Email 2","Emails 3"])
        
        
    }
    @IBAction func addSocialsBtn_click(_ sender: Any) {
        addItem(type: "social", view: socialsView, index: socialsCount, keys: ["Twitter","Facebook","Linkdin"])
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func alignment(){
        
        let width = self.view.frame.size.width
        let navHeight = (self.navigationController?.navigationBar.frame.size.height)! + 20
        //let navHeight = (self.navigationController?.navigationBar.frame.size.height)! + 10
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: navHeight))
        topView.backgroundColor = UIColor(red: 251/255, green: 250/255, blue: 255/255, alpha: 1.0)
        self.view.addSubview(topView)
        scrollView.frame = CGRect(x: 0, y: 10, width: width, height: self.view.frame.size.height)
       
        
        profileImg.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = 50/2
        profileImg.clipsToBounds = true
        
        nameTxt.frame = CGRect(x: 90, y: 10, width: width - 100, height: 30)
        nameTxt.setBottomBorder()
        lastNameTxt.frame = CGRect(x: 90, y: nameTxt.frame.origin.y + 35, width: width - 100, height: 30)
        lastNameTxt.setBottomBorder()
        companyTxt.frame = CGRect(x: 90, y:  lastNameTxt.frame.origin.y + 35, width: width - 100, height: 30)
        companyTxt.setBottomBorder()
        
        
        
        phoneNumberView.frame = CGRect(x: 10, y: companyTxt.frame.origin.y + 60, width: width - 20, height: 30)
        addPhoneBtn.frame = CGRect(x: 0, y: 0, width: phoneNumberView.frame.size.width, height: 30)
        addPhoneBtn.titleEdgeInsets.left = 10;
        addPhoneBtn!.addBottomBorder(UIColor.groupTableViewBackground, height: 1)

        
        emailView.frame = CGRect(x: 10, y: phoneNumberView.frame.origin.y + 60, width: width - 20, height: 30)
        addEmailBtn.frame = CGRect(x: 0, y: 0, width: emailView.frame.size.width, height: 30)
        addEmailBtn.titleEdgeInsets.left = 10;
        addEmailBtn!.addBottomBorder(UIColor.groupTableViewBackground, height: 1)
        
        websiteView.frame = CGRect(x: 10, y: emailView.frame.origin.y + 60, width: width - 20, height: 30)
        websiteTxt.frame = CGRect(x: 0, y: 0, width: websiteView.frame.size.width, height: 30)
        websiteTxt.setBottomBorder()
        
        socialsView.frame = CGRect(x: 10, y: websiteView.frame.origin.y + 60, width: width - 20, height: 30)
        addSocialsBtn.frame = CGRect(x: 0, y: 0, width: socialsView.frame.size.width, height: 30)
        addSocialsBtn.titleEdgeInsets.left = 10;
        addSocialsBtn!.addBottomBorder(UIColor.groupTableViewBackground, height: 1)
        
        
        addressView.frame = CGRect(x: 10, y: addressView.frame.origin.y + 60, width: width - 20, height: 40)
        addressTxt.frame = CGRect(x: 0, y: 0, width: addressView.frame.size.width, height: 25)
        addressTxt.setBottomBorder()
        
        
        scrollView.contentSize = CGSize(width: width, height: addressView.frame.origin.y + 50)
        
//        for view in self.view.subviews as [UIView] {
//            if let textField = view as? UITextField {
//                textField.setBottomBorder()
//            }
//           
//        }
        
    }

}



extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

extension UIView {
    

    
    func addBottomBorder(_ color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.height,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.leading,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.leading,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1, constant: 0))
    }

    func addRightBorder(_ color: UIColor, width: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutAttribute.width,
                                                relatedBy: NSLayoutRelation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutAttribute.width,
                                                multiplier: 1, constant: width))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.bottom,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutAttribute.top,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self,
                                              attribute: NSLayoutAttribute.top,
                                              multiplier: 1, constant: 0))
    }
}
