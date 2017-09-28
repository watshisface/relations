//
//  ContactDetailsVC.swift
//  connect
//
//  Created by Marvin Manzi on 9/26/17.
//  Copyright © 2017 connect. All rights reserved.
//

import UIKit

class ContactDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var ContactNameLbl: UILabel!
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var callLbl: UILabel!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
   
    var contact : Contact!
    
    var items : [(String ,String)] = []
    
    var imgHeight: CGFloat = 0.0
    var tableStart: CGFloat = 0.0
    var nameStart: CGFloat = 0.0
    var callBtnStart: CGFloat = 0.0
    var messageBtnStart: CGFloat = 0.0
    var EmailBtnStart: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        ContactNameLbl.text = contact.name! + " " + contact.last_name!
        
        items = [
                 ("Company Name", contact.company!),
                 ("Person Number", contact.personal_phone!),
                 ("Work Number", contact.work_phone!),
                 ("Home Number", contact.home_phone!),
                 ("Website", contact.website!),
                 ("First Email", contact.email1!),
                 ("Second Email", contact.email2!),
                 ("Thrid Email", contact.email3!),
                 ("Twitter", contact.twitter!),
                 ("Facebook", contact.facebook!),
                 ("Linkdin", contact.linkdin!),
                 ("Address", contact.address!)]

        alignment()
        
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // First we get a cell from the table view with the identifier "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let (key, value) = items[indexPath.row]
        
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = value
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let (key, value) = items[indexPath.row]
        if value == "" {
            return 0.0  // collapsed
        }
        // expanded with row height of parent
        return 64.0
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if scrollView.contentOffset.y < 15 && scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.3, animations: ({
                self.profileImg.frame.origin.y = self.imgHeight - scrollView.contentOffset.y
                self.ContactNameLbl.frame.origin.y = self.nameStart - scrollView.contentOffset.y
                self.tableView.frame.origin.y = self.tableStart - scrollView.contentOffset.y
                
                self.callBtn.frame.origin.y = self.callBtnStart - scrollView.contentOffset.y
                self.messageBtn.frame.origin.y = self.messageBtnStart - scrollView.contentOffset.y
                self.emailBtn.frame.origin.y = self.EmailBtnStart - scrollView.contentOffset.y
                
                self.callLbl.isHidden = false
                self.messageLbl.isHidden = false
                self.emailLbl.isHidden = false
            }))
            print("Scrolling \(scrollView.contentOffset.y) -- \(imgHeight)--\(self.profileImg.frame.size.height) --- \( self.tableView.frame.origin.y)")
        }
        
        if scrollView.contentOffset.y > 15 {
            UIView.animate(withDuration: 0.3, animations: ({
                self.profileImg.frame.origin.y = self.imgHeight - 15
                self.tableView.frame.origin.y = self.tableStart - 15
                self.ContactNameLbl.frame.origin.y = self.nameStart - 15
                self.callBtn.frame.origin.y = self.callBtnStart - 15
                self.messageBtn.frame.origin.y = self.messageBtnStart - 15
                self.emailBtn.frame.origin.y = self.EmailBtnStart - 15
                
                self.callLbl.isHidden = true
                self.messageLbl.isHidden = true
                self.emailLbl.isHidden = true
            }))
            print("Scrolling greater than 15")
        }
        
        if scrollView.contentOffset.y < 0 {
            UIView.animate(withDuration: 0.3, animations: ({
                self.profileImg.frame.origin.y = self.imgHeight
                self.tableView.frame.origin.y = self.tableStart
                self.ContactNameLbl.frame.origin.y = self.nameStart
                self.callBtn.frame.origin.y = self.callBtnStart
                self.messageBtn.frame.origin.y = self.messageBtnStart
                self.emailBtn.frame.origin.y = self.EmailBtnStart
                
            }))
            print("Scrolling less than 0")
        }
        
        
        
//        if scrollView.contentOffset.y == 0.0 {
//            self.alignment()
//        }
    }
    
  
    @IBAction func editBtn_click(_ sender: Any) {
        print("Cliccked")
        let editView = storyboard?.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        editView.contact = contact
        self.navigationController?.pushViewController(editView, animated: false)
    }
    
    
    
    func alignment(){
        let width = self.view.frame.size.width
        
        profileImg.frame = CGRect(x: width/2 - 40, y: 60, width: 80, height: 80)
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = 80/2
        profileImg.clipsToBounds = true
        imgHeight = self.profileImg.frame.origin.y
        
        ContactNameLbl.frame = CGRect(x: 20, y: profileImg.frame.origin.y + 90, width: width - 40, height: 30)
        nameStart = profileImg.frame.origin.y + 90
        
        callBtn.center = CGPoint(x: width/2 - 60, y: ContactNameLbl.center.y + 40)
        callLbl.center = CGPoint(x: width/2 - 60, y: ContactNameLbl.center.y + 70)
        callBtnStart = ContactNameLbl.frame.origin.y + 35
        
        messageBtn.center = CGPoint(x: width/2, y: ContactNameLbl.center.y + 40)
        messageLbl.center = CGPoint(x: width/2, y: ContactNameLbl.center.y + 70)
        messageBtnStart = ContactNameLbl.frame.origin.y + 35
        
        emailBtn.center = CGPoint(x: width/2 + 60, y: ContactNameLbl.center.y + 40)
        emailLbl.center = CGPoint(x: width/2 + 60, y: ContactNameLbl.center.y + 70)
        EmailBtnStart = ContactNameLbl.frame.origin.y + 35
        
     
        
        
        tableView.frame = CGRect(x: 0, y: callLbl.frame.origin.y + 40, width: width, height: self.view.frame.size.height - callLbl.frame.origin.y - 40)
        tableStart = callLbl.frame.origin.y + 40
        
        
    }

}

extension UIButton {
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        
        guard let imageView = self.imageView,
            let titleLabel = self.titleLabel else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1;
        let imageSize = imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake((imageSize.height+gap)*sign, -imageSize.width, 0, 0);
        
        let titleSize = titleLabel.bounds.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height+gap)*sign, 0, 0, -titleSize.width);
    }
}
