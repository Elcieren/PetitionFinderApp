//
//  ViewController.swift
//  Project7
//
//  Created by Eren Elçi on 4.10.2024.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var allPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose, target: self, action: #selector(tapInformation))
        
        navigationItem.leftBarButtonItems =  [
             UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promtForID)),
             UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.reply, target: self, action: #selector(allData))
             ]
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            // Asenkron URLSession kullanımı
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                // Hata kontrolü
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                // Veri alındığında işle
                if let data = data {
                    self?.parse(json: data)
                }
            }
            
            // Görevi başlat
            task.resume()
        }
    }
    
    @objc func allData() {
        petitions = allPetitions
        tableView.reloadData()
    }
    
    
    @objc func promtForID(){
        let ac = UIAlertController(title: "Arama", message: "Aramak istediğiniz dilekçe İD girin", preferredStyle: UIAlertController.Style.alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Ara", style: UIAlertAction.Style.default) { [weak self , weak ac] _ in
            if let id = ac?.textFields?[0].text {
                self?.filterPetitions(by: id)
            }
               
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    
    func filterPetitions(by id: String) {
        let filteredPetitions = allPetitions.filter { $0.id == id }
            if filteredPetitions.isEmpty {
                showError(title: "Bilgilendirme", mesagge: "İD Eşlşemesi Bulunmadı")
            } else {
                petitions = filteredPetitions
                tableView.reloadData()
            }
    }
    
    
    
    @objc func tapInformation(){
        
        let alert = UIAlertController(title: "Veri Bilgilendirmesi", message: "Veriler https://www.hackingwithswift.com/samples/petitions-1.json gelmektedir ", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel))
        present(alert, animated: true)
        
    }
    
    func showError(title: String , mesagge: String){
        let ac = UIAlertController(title: title, message: mesagge, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
                     present(ac, animated: true)
    }
    
    // JSON verisini çözme
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            petitions = jsonPetitions.results
            
            
            // UI işlemleri ana thread'de yapılmalıdır
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    // Tablo satır sayısı
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    // Her bir hücrede görüntülenecek veriler
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var context = cell.defaultContentConfiguration()
        
        // Hücreyi petition verileriyle doldur
        let petition = petitions[indexPath.row]
        context.text = petition.title
        context.secondaryText = petition.body
        cell.contentConfiguration = context
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

