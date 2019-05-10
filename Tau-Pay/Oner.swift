import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet var DikkatText: UITextView!
    @IBOutlet weak var recommendText: UITextField!
    @IBOutlet var Oner: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
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
                        ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat!", message: "Hesabınıza başka bir cihazdan giriş yapıldı", view: self)
                        return
                    }
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata", message: "Hatalı giriş", view: self, buttons: "Tamam")
                    return
                } else {
                    ConstantViewFunctions.createAnimatedPopUp(title: "Başarılı", message: "Öğrenci önerilmiştir.", view: self, buttons: "Tamam")
                }
            }
        }
        
    }
    
}
