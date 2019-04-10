import UIKit

class ProfileTabController: UIViewController {

    @IBOutlet weak var nameBox: UILabel!
    @IBOutlet weak var numberBox: UILabel!
    @IBOutlet weak var shuttleBalance: UILabel!
    @IBOutlet weak var cafeteriaBalance: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Constants.TOKEN == "") {
            return
        }
        
        var person = Constants.SendRequestGetDictionary(request: "/customer/get-info", json: [:])
        if person.connectionError {
            print("Connection Error!")
        } else if (person.error != nil) {
            print("error \(person.error)")
        } else {
            nameBox.text = person.info!["name"] as! String
            numberBox.text = person.info!["id"] as! String
        }
    }
}
