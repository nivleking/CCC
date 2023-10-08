//
//  ViewController.swift
//  ProyekUTS
//
//  Created by Kelvin Sidharta Sie on 04/10/23.
//

import UIKit

class ViewController: UIViewController {
    var originCityID: String?
    var destinationCityID: String?
//    var flag: Bool = false
//    var resultsArray = [Results]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoApp.image = UIImage(systemName: "shippingbox.fill")
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewController2 {
            let destinationVC = segue.destination as? ViewController2
            destinationVC?.originText = self.originCityID ?? ""
            destinationVC?.destinationText = self.destinationCityID ?? ""
            
            destinationVC?.asal = originTextField.text ?? ""
            destinationVC?.tujuan = destinationTextField.text ?? ""
            destinationVC?.berat = Int( weightTextField.text ?? "0")
        }
    }
    @IBOutlet weak var logoApp: UIImageView!
    
    @IBOutlet weak var originTextField: UITextField!
    
    @IBOutlet weak var destinationTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBAction func cekKota(_ sender: UITextField) {
        let headers = ["key": "ae8145fa36e484106b45936fd6189765"]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/city")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    self.parseCity(theData: data)
                }
            }
        })
        dataTask.resume()
    }
    
    func parseCity(theData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CityDataModel.self, from: theData)
//            print(decodeData)
            DispatchQueue.main.async {
                if let results = decodeData.rajaongkir.results {
                    self.originCityID = nil // Clear the previous value
                    self.destinationCityID = nil // Clear the previous value

                    if let originText = self.originTextField.text?.lowercased(),
                       let destinationText = self.destinationTextField.text?.lowercased() {
                        for city in results {
                            if originText == city.city_name.lowercased() {
                                self.originCityID = city.city_id
                            }
                            if destinationText == city.city_name.lowercased() {
                                self.destinationCityID = city.city_id
                            }
                            if self.originCityID != nil && self.destinationCityID != nil {
                                break
                            }
                        }

                        if let originCityID = self.originCityID {
                            print("ID kota origin untuk \(originText): \(originCityID)")
                        } else {
                            print("ID kota destination untuk \(originText) tidak ditemukan.")
                        }

                        if let destinationCityID = self.destinationCityID {
                            print("ID kota destination untuk \(destinationText): \(destinationCityID)")
                        } else {
                            print("ID kota destination untuk \(destinationText) tidak ditemukan.")
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }


}

