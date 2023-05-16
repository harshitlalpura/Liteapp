//
//  LoginViewController.swift
//  Liteapp
//
//  Created by Navroz Huda on 07/06/22.
//

import UIKit
import SideMenu
import ObjectMapper

extension UIImage{
    static let selectedImage = UIImage(named:"ic_selected")
    static let unselectedImage = UIImage(named:"ic_unselected")
}
class LoginViewController: BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var vwGradiantContainer: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var passwordValidationView: UIView!
    
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    
    @IBOutlet weak var emailTextValidationView: UIView!
    @IBOutlet weak var passwordTextValidationView: UIView!
    @IBOutlet weak var lblTermsAndPrivacy: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnChangeLanguage: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    var privacyText : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.vwGradiantContainer.setGradientBackground()
        }
        
        lblTitle.text = NSLocalizedString("We've made time tracking easier. Let's get started", comment: "TitleText")
        lblEmail.text = NSLocalizedString("Email", comment: "EmailLabel")
        txtEmail.placeholder = NSLocalizedString("Enter Email", comment: "EmailPlaceholder")
        lblPassword.text = NSLocalizedString("Password", comment: "PasswordLabel")
        txtPassword.placeholder = NSLocalizedString("Enter Password", comment: "PasswordPlaceholder")
        btnForgotPassword.setTitle(NSLocalizedString("Forgot Password?", comment: "ForgotPasswordButton"), for: .normal)
        lblRegister.text = NSLocalizedString("Don't have an account?", comment: "RegisterLabel")
        btnRegister.setTitle(NSLocalizedString("Register here", comment: "RegisterButton"), for: .normal)
        btnLogin.setTitle(NSLocalizedString("Login", comment: "LoginButton"), for: .normal)
        lblEmailError.text = NSLocalizedString("Please enter email", comment: "lblEmailError")
        lblPasswordError.text = NSLocalizedString("Please enter password", comment: "lblPasswordError")
        
        let quote = NSLocalizedString("English|Spanish", comment: "btnChangeLanguage")
        let attributedQuote = NSMutableAttributedString(string: quote)
        attributedQuote.addAttribute(.foregroundColor, value: UIColor(hex: "#B6C2D0"), range: NSRange(location: 7, length: 8))
        
        
        btnChangeLanguage.setAttributedTitle(attributedQuote, for: .normal)
        // Do any additional setup after loading the view.
        if let forgotPasswordEmpId = Defaults.shared.forgotPasswordEmpId{
            //Open Reset Password Screen
            let vc = ResetPasswordVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
            vc.empId = forgotPasswordEmpId
            self.pushVC(controller:vc)
        }
        
//        txtEmail.text = "davemannn"
//        txtPassword.text = "Mascot@2205"
        txtPassword.delegate = self
        setupTermsAndPrivacyLabel()
    }
    override func viewDidAppear(_ animated: Bool) {
//        if let code = Defaults.shared.referralCode{
//            self.showToast(message:"\(code)", font: UIFont.RobotoRegular(size:20.0))
//        }
    }
    func checkTextValidation(){
        if txtEmail.text!.count < 1{
            self.emailTextValidationView.isHidden = false
        }else{
            self.emailTextValidationView.isHidden = true
        }
        if txtPassword.text!.count < 1{
            self.passwordTextValidationView.isHidden = false
        }else{
            self.passwordTextValidationView.isHidden = true
        }
       
    }
    
    func setupTermsAndPrivacyLabel(){
        
        privacyText = NSLocalizedString("By signing up, you agree to our End User License Agreement and Privacy Policy.", comment: "privacyText")
        lblTermsAndPrivacy.text = privacyText
        lblTermsAndPrivacy.textColor =  UIColor.white
        let underlineAttriString = NSMutableAttributedString(string: privacyText)
        let range1 = (privacyText as NSString).range(of: NSLocalizedString("End User License Agreement", comment: "UserAgreementText"))
        let range2 = (privacyText as NSString).range(of: NSLocalizedString("Privacy Policy", comment: "PrivacyPolicy"))
        let rangeFull = (privacyText as NSString).range(of: privacyText)
        let fontSize = lblTermsAndPrivacy.font.pointSize
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range2)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        underlineAttriString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: rangeFull)
        lblTermsAndPrivacy.attributedText = underlineAttriString
        lblTermsAndPrivacy.isUserInteractionEnabled = true
        lblTermsAndPrivacy.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (privacyText as NSString).range(of: NSLocalizedString("End User License Agreement", comment: "UserAgreementText"))
        let privacyRange = (privacyText as NSString).range(of: NSLocalizedString("Privacy Policy", comment: "PrivacyPolicy"))
        
        if gesture.didTapAttributedTextInLabel(label: lblTermsAndPrivacy, inRange: termsRange) {
            print("Tapped terms")
            let vc = TermsPrivacyStaticPagesVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
            vc.isForTerms = true
            self.pushVC(controller:vc)
        } else if gesture.didTapAttributedTextInLabel(label: lblTermsAndPrivacy, inRange: privacyRange) {
            print("Tapped privacy")
            let vc = TermsPrivacyStaticPagesVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
            vc.isForTerms = false
            self.pushVC(controller:vc)
        } else {
            print("Tapped none")
        }
    }
    
    @objc func messageTapped(sender:UIButton){
        
    }
    @IBAction func loginClicked(sender:UIButton){
        checkTextValidation()
        if checkValidation(){
            self.loginAPI()
        }
    }
    @IBAction func registerClicked(sender:UIButton){
        let vc = OnboardingRegisterVC.instantiate()
        self.pushVC(controller:vc)
    }
    func loginAPI(){
        let parameter = ["emp_username":txtEmail.text!,"emp_work_email":txtEmail.text!,"emp_password":txtPassword.text!]
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints: APIEndPoints.login(), param: parameter) { success, response, error in
            if let res = response{
                print(res)
                let user = Mapper<EmployeeData>().map(JSONObject:res)
                Defaults.shared.currentUser = user?.empData?.first
                print(Defaults.shared.currentUser?.merchantName ?? "")
                Defaults.shared.passLen = self.txtPassword.text?.length
                if user?.status ?? 0 == 0{
     
                    self.showAlert(alertType:.validation, message: user?.message ?? "")
                    return
                }
                if let empType = Defaults.shared.currentUser?.empType{
                    if empType == "E"{
                        let vc = DashBoardVC.instantiate()
                        self.pushVC(controller:vc)
                    }else if empType == "S"{
                        if user?.empData?.first?.merchantProfileCompleted == "Y"{
                            let vc = DashBoardVC.instantiate()
                            self.pushVC(controller:vc)
                        }else{
                            let vc = SettingsVC.instantiate()
                            vc.setupProfile = true
                            self.pushVC(controller:vc)
                        }
                    }
                }
            }else if let err = error{
                print(err)
            }
        }
    }
    func checkValidation()->Bool{
        if txtEmail.text!.count < 1{
          
           // self.showAlert(alertType:.validation, message: "Please enter valid username")
            return false
        }
        if txtPassword.text!.count > 1{
            if txtPassword.text!.isValidPassword == false{
                self.showAlert(alertType:.validation, message: NSLocalizedString("Please enter valid password", comment: "ValidPassword"))
                return false
            }
        }
        return true
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: Any) {
        let vc = ForgotPasswordVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
        self.pushVC(controller:vc)
    }
    @IBAction func btnChangeLanguageTapped(_ sender: Any) {
        if(UserDefaults.standard.value(forKey: "AppleLanguage") as! String == "en" )
        {
            UserDefaults.standard.set("es", forKey: "AppleLanguage")
        }
        else
        {
            UserDefaults.standard.set("en", forKey: "AppleLanguage")
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.currentLanguage = UserDefaults.standard.value(forKey: "AppleLanguage") as! String
        Bundle.swizzleLocalization()
        self.viewDidLoad()
    }
    
    
}
extension LoginViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    func updatePasswordValidation(str:String){
            if str == ""{
                imgvwminimumCharacter.image = UIImage.unselectedImage
                imgvwCapitalLetter.image = UIImage.unselectedImage
                imgvwLowercaseLetter.image = UIImage.unselectedImage
                imgvwNumber.image = UIImage.unselectedImage
                imgvwSpecialCharacter.image = UIImage.unselectedImage
            }
         
            if str.count >= 8{
                imgvwminimumCharacter.image = UIImage.selectedImage
            }else{
                imgvwminimumCharacter.image = UIImage.unselectedImage
            }
           let capitalLetterRegEx  = ".*[A-Z]+.*"
           let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            if texttest.evaluate(with: str){
                imgvwCapitalLetter.image = UIImage.selectedImage
            }else{
                imgvwCapitalLetter.image = UIImage.unselectedImage
            }
          
            let lowercaseLetterRegEx  = ".*[a-z]+.*"
            let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
             if texttest3.evaluate(with: str){
                 imgvwLowercaseLetter.image = UIImage.selectedImage
             }else{
                 imgvwLowercaseLetter.image = UIImage.unselectedImage
             }

           let numberRegEx  = ".*[0-9]+.*"
           let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            if texttest1.evaluate(with: str){
                imgvwNumber.image = UIImage.selectedImage
            }else{
                imgvwNumber.image = UIImage.unselectedImage
            }

           let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
           let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if texttest2.evaluate(with: str){
                imgvwSpecialCharacter.image = UIImage.selectedImage
            }else{
                imgvwSpecialCharacter.image = UIImage.unselectedImage
            }
        
    }
}
extension UIViewController{
    func showAlert(alertType:AlertType = .success,message:String = "",subTitle:String = ""){
        let vc = CustomAlertViewController.instantiate()
        vc.alertType = alertType
        if alertType == .success{
            vc.successMessage = message
        }else if alertType == .validation{
            vc.validationMessage = message
        }else if alertType == .failed{
            vc.failureMessage = message
        }
        
        self.presentVC(controller:vc)
    }
}
