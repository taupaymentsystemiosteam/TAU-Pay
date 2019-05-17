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
        
        let onerText = NSLocalizedString("Oner", comment: "").localized()
        
        studentNumberText.text = "Okul Numarasi".localized() + ":"
        Oner.setTitle(onerText, for: UIControl.State.normal)
    }
    
    @IBAction func Oner(_ sender: Any) {
        
        if recommendText.text == nil{
            ConstantViewFunctions.createAnimatedPopUp(title: "Hata", message: "Öğrenci numarası girmediniz.", view: self, buttons: "Tamam")
            return
        }
        
        let alert = UIAlertController(title: "Emin misiniz",message:"Bu öğrenciyi önermek istediğinize emin misiniz?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:"Eminim", style: UIAlertAction.Style.default, handler: {(action) in self.recommendRequest()
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
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
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve tekrar deneyiniz.", view: self, buttons: "Tamam")
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
                    ConstantViewFunctions.createAnimatedPopUp(title: "Başarılı", message: "Öğrenci önerilmiştir.", view: self, buttons: "Tamam")
                }
            }
        }
        
    }
    
}
