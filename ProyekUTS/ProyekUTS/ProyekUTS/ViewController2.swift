//
//  ViewController2.swift
//  ProyekUTS
//
//  Created by Kelvin Sidharta Sie on 04/10/23.
//

import UIKit

struct OngkirItem {
    var nama: String
    var code: String
    var service: String
    var value: Int
    var estimate: String
}

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var originText: String?
    var destinationText: String?
    var resultsArray: [Results] = []
    var resultsArray30: [Results] = []
    
    var asal:String?
    var tujuan:String?
    var berat: Int?
    
    var OngkirItems: [OngkirItem] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var asalTujuanLabel: UILabel!
    @IBOutlet weak var beratLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        print(originText ?? "")
//        print(destinationText ?? "")
        // Do any additional setup after loading the view.
        
        if !originText!.isEmpty && !destinationText!.isEmpty{
            self.asalTujuanLabel.text = (asal ?? "") + " ke " + (tujuan ?? "")
            self.beratLabel.text = "@\(berat ?? 0) gram"
            
            var counter: Int = 0
            
            let headers = [
                "key": "ae8145fa36e484106b45936fd6189765",
                
                "content-type": "application/x-www-form-urlencoded"
            ]
            
            guard let originID = self.originText, let destinationID = self.destinationText else {
                print("OriginID or DestinationID is nil")
                return
            }

            let courierList = ["jne", "tiki", "pos"]

            let weight = berat

            for courier in courierList {
                let postData = NSMutableData()
                postData.append("origin=\(originID)".data(using: String.Encoding.utf8)!)
                postData.append("&destination=\(destinationID)".data(using: String.Encoding.utf8)!)
                postData.append("&weight=\(weight ?? 0)".data(using: String.Encoding.utf8)!)
                postData.append("&courier=\(courier)".data(using: String.Encoding.utf8)!)

                let request = NSMutableURLRequest(url: NSURL(string: "https://api.rajaongkir.com/starter/cost")! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData as Data

                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if let error = error {
                        print(error)
                    } else {
                        if let data = data {
    //                        print("API response: \(String(data: data, encoding: .utf8) ?? "No data")")
                            counter += 1
                            self.parseJSON(theData: data, courier: courier, resultsArray: &self.resultsArray, counter: counter)
    //                        print("cekOngkir completed for courier: \(courier)")
                        }
                    }
                })
                dataTask.resume()
            }
            self.originText?.removeAll()
            self.destinationText?.removeAll()
//            self.tableView.reloadData()
        }
        
    }
    
    
    func parseJSON(theData: Data, courier: String, resultsArray: inout [Results], counter: Int) {
            let decoder = JSONDecoder()
            do {
                let decodeData = try decoder.decode(CostDataModel.self, from: theData)
                resultsArray.append(contentsOf: decodeData.rajaongkir.results)
//                print(resultsArray)
                if (counter <= 3) {
                    self.OngkirItems.removeAll()
                    self.resultsArray30 = resultsArray

                    for i in self.resultsArray30 {
//                        print(i.name)
//                        print(i.code)
//                        print("=======")
                        for j in i.costs {
//                            print(j.service)
//                            print(j.cost[0].value)
//                            print(j.cost[0].etd)
                            self.OngkirItems.append(OngkirItem(nama: i.name, code: i.code, service: j.service, value: j.cost[0].value, estimate: j.cost[0].etd))
                        }
//                        print("=======")
//                        print()
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(error)
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OngkirItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! TableViewCell

        let ongkirItem = OngkirItems[indexPath.row]
        
        if ongkirItem.code.uppercased() == "JNE" {
            cell.logoKurir.image = UIImage(named: "jne.png")
        }
        if ongkirItem.code.uppercased() == "TIKI" {
            cell.logoKurir.image = UIImage(named: "tiki.png")
        }
        if ongkirItem.code.uppercased() == "POS" {
            cell.logoKurir.image = UIImage(named: "pos.png")
        }
        cell.logoKurir.layer.cornerRadius = cell.logoKurir.frame.height / 32
        cell.namaLabel.text = String(ongkirItem.nama)
        cell.codeLabel.text = String(ongkirItem.code).uppercased() + " - " + String(ongkirItem.service)
//        cell.serviceLabel.text = String(ongkirItem.service)
        if ongkirItem.estimate.count < 4 {
            cell.serviceLabel.text = "Duration: " + String(ongkirItem.estimate) + " HARI"
        }
        else {
            cell.serviceLabel.text = "Duration: " + String(ongkirItem.estimate)
        }
        
        cell.valueLabel.text = "Rp\(String(ongkirItem.value))"
        
        
        return cell
    }
}
