//
//  BrandHelplineViewController.Swift
//  CarConnect
//
//  Created by Saurabh Sharma on 10/17/17.
//  Copyright © 2017 Aritron Technologies. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON
import Toast_Swift

struct BrandHelpCellData {
    
    let cell2 : Int!
    let text : String!
    let text2 : String!
    let image : UIImage!
    
    
}

class BrandHelplineViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var BrandHelplineList : [BrandHelpline] = [BrandHelpline]()
    var selectedMenuItem : Int = 0
    @IBOutlet var tableView2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = MySideMenu()
        getBrandHelplineList()
    }
    
    func getBrandHelplineList(){
        let token : String = UserDefaults.standard.string(forKey: "token")!
        
        // Parameters
        let parameters: [String: Any] = ["token":token]
        
        //Alamofire Request
        Alamofire.request(WebUrl.BRAND_HELPLINE_URL+"?token="+UserDefaults.standard.string(forKey: "token")!, method: .post,parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            // print("NewCarJsonResponse: \(response.result)")
            
/*****************Response Success *****************/
            switch response.result {
            case .success (let value):let json = JSON(value)
            print("JSON: \(json)")
            let status = json["status"].stringValue
            if (status == WebUrl.SUCCESS_CODE){
                let data = json["data"].array
                
                for i in data! {
                    let usedcarList = i["helplinecontactList"].array // Read Json Object
                    
                    for dataModel in usedcarList! {      // Parse Json Array
                        let id = dataModel["id"].stringValue
                        let brandName = dataModel["brandName"].stringValue
                        let brandImage = dataModel["brandImage"].stringValue
                        let contact = dataModel["contact"].stringValue
                        
                        let myimage = WebUrl.HELPLINE_IMAGE_URL+brandImage
                        
              self.BrandHelplineList.append(BrandHelpline(id: id, brandName: brandName, brandImage: myimage, contact: contact))

                    }
                    
                    self.tableView2.reloadData()
                }
            }
                
/***************** Network Error *****************/
            case .failure (let error):
                self.view.makeToast("Network Error")
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BrandHelplineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
        let cell2 = Bundle.main.loadNibNamed("BrandHelplineTableViewCell", owner:self, options: nil)?.first as!BrandHelplineTableViewCell
        
        let url = URL(string: BrandHelplineList[indexPath.row].brandImage)!
        cell2.imageViewBrand.af_setImage(withURL: url)
        
            cell2.LblCarName.text = BrandHelplineList[indexPath.row].brandName
            cell2.LblMobNo.text = BrandHelplineList[indexPath.row].contact
            return cell2
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160;//Choose your custom row height
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func HometoggleSideMenuBtn(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
        print("Home Menu Button")
    }
    
 
}

