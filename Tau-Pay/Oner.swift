import UIKit

class ThirdViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var DikkatText: UILabel!
    @IBOutlet weak var recommendText: UITextField!
    @IBOutlet var Oner: UIButton!
    @IBOutlet weak var studentNumberText: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        self.recommendText.delegate = self;
          updateLanguage()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
          NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
    }
    
    @objc func updateLanguage()
    {
        DikkatText.text = NSLocalizedString("Bu sayfada yardıma ihtiyacı olanlar listesine girmesi için bir öğrenci önerebilirsiniz. Bu öğrencinin listeye girip girmemesi için karar verilecektir.", comment: " ").localized()

        
        studentNumberText.text = "Okul Numarasi".localized() + ":"
        Oner.setTitle("Oner".localized(), for: UIControl.State.normal)
    }
    
    @IBAction func Oner(_ sender: Any) {
        
        if recommendText.text == nil || recommendText.text == ""{
            ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: "Öğrenci numarası girmediniz.".localized(), view: self, buttons: "Tamam")
            return
        }
        
        let alert = UIAlertController(title: "Emin Misin?".localized(),message:"Bu öğrenciyi önermek istediğinize emin misiniz?".localized(), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:"Eminim".localized(), style: UIAlertAction.Style.default, handler: {(action) in self.recommendRequest()
        }))
        
        alert.addAction(UIAlertAction(title: "İptal".localized(), style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == recommendText {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func recommendRequest() {
        let queue = DispatchQueue(label: "request")
        queue.async {
            let json = ["id": self.recommendText.text!]
            
            let response = Constants.SendRequestGetString(requestType: "/customers/recommend", json: json)
            DispatchQueue.main.async {
                if response.connectionError {
                    // Handle connection error
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: "Bağlantı Hatası".localized(), view: self, buttons: "Tamam".localized())
                    return
                }
                    
                else if response.error != nil {
                    // Handle improper connection
                    if(response.error == "403") {
                        ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat".localized(), message: "Hesabınıza başka bir cihazdan giriş yapıldı".localized(), view: self)
                        return
                    }
                    ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Hatalı Giriş", comment: " ").localized(), view: self, buttons: "Tamam".localized())
                    return
                
                } else {
                    ConstantViewFunctions.createAnimatedPopUp(title: "Başarılı".localized(), message: "Öğrenci önerilmiştir.".localized(), view: self, buttons: "Tamam".localized())
                }
            }
        }
        
    }
    
}
