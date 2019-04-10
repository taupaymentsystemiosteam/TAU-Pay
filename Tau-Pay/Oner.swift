import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var recommendText: UITextField!
    @IBOutlet var Oner: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Oner(_ sender: Any) {
        
        if recommendText.text == nil{
            createAnimatedPopUp(title: "Hata", message: "Öğrenci numarası girmediniz.")
            return
        }
        
        let alert = UIAlertController(title: "Emin misiniz",message:"Bu öğrenciyi önermek istediğinize emin misiniz?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:"Eminim", style: UIAlertAction.Style.default, handler: {(action) in self.recommendRequest()
        }))
        
        alert.addAction(UIAlertAction(title: "İptal", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    func recommendRequest(){
        let json = ["id": recommendText.text!]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/recommend", json: json)
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve tekrar deneyiniz.")
            return
        }
            
        else if response.error != nil {
            // Handle improper connection
            createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
            return
        } else {
        createAnimatedPopUp(title: "Başarılı", message: "Öğrenci önerilmiştir.")
        }
    }
    func createAnimatedPopUp(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Tamam",style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
}
