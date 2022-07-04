//
//  InviteViaTextVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 19/06/22.
//

import UIKit
import MessageUI
import Contacts
import ContactsUI


class InviteViaTextVC:BaseViewController, StoryboardSceneBased,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate{
    
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.merchant.rawValue, bundle: nil)
    var inviteLink = ""
   // var contacts = [CNContact]()
    var contactList = [ContactsModel]()
    var allContactList = [ContactsModel]()
    var selectedContactList = [ContactsModel]()
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var btnInvite: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inviteLink = "Hey! Please download our TimeClock App with the link below. \n Your referral code is \(Defaults.shared.currentUser?.merchantReferenceNumber ?? "").\n https://lite.testbryteportal.com/referral/\(Defaults.shared.currentUser?.merchantReferenceNumber ?? "")"
       // contacts = self.getContactFromCNContact()
        contactList = ContactsModel.generateModelArray()
        allContactList =  contactList
        print(contactList)
        self.tblview.reloadData()
        searchbar.delegate = self
        
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {

        view.endEditing(true)
    }
    func getContactFromCNContact() -> [CNContact] {

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            ] as [Any]

        //Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        // Iterate all containers and append their contacts to our results array
        for container in allContainers {

            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)

            } catch {
                print("Error fetching results for container")
            }
        }

        return results
    }
    @IBAction func backClicked(sender:UIButton){
        self.popVC()
    }
    func preparePhoneList()->[String]{
        var numbers = [String]()
        for contact in self.selectedContactList{
            if let number = contact.phoneNumber.first{
                numbers.append(number)
            }
        }
        return numbers
    }
    @IBAction func inviteClicked(sender:UIButton){
        let numbers = self.preparePhoneList()
        if selectedContactList.count > 0{
            
            if (MFMessageComposeViewController.canSendText()) {
        
                let controller = MFMessageComposeViewController()
                controller.body = self.inviteLink
                controller.recipients = numbers
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }

}
extension InviteViaTextVC:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.contactList = self.allContactList
        }else{
            let searchedArray = self.allContactList.filter({$0.givenName.lowercased().contains(searchText.lowercased()) || ($0.phoneNumber.first?.lowercased() ?? "").contains(searchText.lowercased()) || $0.familyName.lowercased().contains(searchText.lowercased()) })
            self.contactList = searchedArray
        }
      
        self.tblview.reloadData()
    }
}
extension InviteViaTextVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblview.dequeueReusableCell(withIdentifier: ContactCell.reuseIdentifier, for: indexPath as IndexPath) as! ContactCell
        let contact = self.contactList[indexPath.row]
        cell.lblName.text = contact.givenName + " " + contact.familyName
        cell.lblPhone.text = contact.phoneNumber.first
        cell.imageview.image = contact.image
        cell.btnCheck.isSelected = false
        cell.btnCheck.addTarget(self, action:#selector(self.checkClicked(sender:)), for: .touchUpInside)
        cell.btnCheck.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    @objc func checkClicked(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.selectedContactList.append(contactList[sender.tag])
           
        }else{
            self.selectedContactList = self.selectedContactList.filter({$0.phoneNumber != contactList[sender.tag].phoneNumber})
        }
        if selectedContactList.count > 0{
            btnInvite.alpha = 1.0
        }else{
            btnInvite.alpha = 0.5
        }
        print( self.selectedContactList.count)
    }
    
    
}
class ContactsModel : NSObject {
    let givenName: String
    let familyName: String
    let phoneNumber: [String]
    let emailAddress: String
    var identifier: String
    var image: UIImage

    init(givenName:String, familyName:String, phoneNumber:[String], emailAddress:String, identifier:String, image:UIImage) {
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.identifier = identifier
        self.image = image
    }

    class func generateModelArray() -> [ContactsModel]{
        let contactStore = CNContactStore()
        var contactsData = [ContactsModel]()
        let key = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactImageDataKey,CNContactThumbnailImageDataKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
        try? contactStore.enumerateContacts(with: request, usingBlock: { (contact, stoppingPointer) in
            let givenName = contact.givenName
            let familyName = contact.familyName
            let emailAddress = contact.emailAddresses.first?.value ?? ""
            let phoneNumber: [String] = contact.phoneNumbers.map{ $0.value.stringValue }
            let identifier = contact.identifier
            var image = UIImage()
            if contact.thumbnailImageData != nil{
                image = UIImage(data: contact.thumbnailImageData!)!

            }else if  contact.thumbnailImageData == nil ,givenName.isEmpty || familyName.isEmpty{
                image = UIImage()
            }
            contactsData.append(ContactsModel(givenName: givenName, familyName: familyName, phoneNumber: phoneNumber, emailAddress: emailAddress as String, identifier: identifier, image: image))
        })
        return contactsData
    }
}
