
  <details>
    <summary><h2>Uygulma Amacı</h2></summary>
    Proje Amacı
   Bu uygulama, JSON formatında sağlanan petisyon verilerini çekerek kullanıcıya liste halinde sunar. Kullanıcılar, belirli bir ID girerek bu veriler arasında arama yapabilir ve filtreleme yapabilirler
  </details> 
  
  <details>
    <summary><h2>Kullanıcı Problemi:</h2></summary>
    Proje Amacı
   Kullanıcıların büyük veri setleri içinde belirli bir öğeyi hızlıca bulmalarını sağlamak
  </details> 

  <details>
    <summary><h2>Veri Modeli</h2></summary>
    SON verisindeki her bir petisyonu temsil eder. Codable protokolü sayesinde JSON verisi kolayca çözülür.
    
    ```
    struct Petition: Codable {
    var id: String
    var title: String
    var body: String
    }

    ```
  </details> 

  <details>
    <summary><h2>eri Çekme ve İşleme</h2></summary>
    Asenkron olarak veri çeker ve JSON verisini çözer.

    
    ```
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
    // Hata kontrolü ve veri işleme
    }
    task.resume()

    ```
  </details> 

  <details>
    <summary><h2>JSON Çözme</h2></summary>
    SON verisini Petitions modeline çevirir ve tabloyu günceller.
    
    ```
    func parse(json: Data) {
    let decoder = JSONDecoder()
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
        allPetitions = jsonPetitions.results
        petitions = jsonPetitions.results
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    }
    
    ```
  </details> 


  <details>
    <summary><h2>Filtreleme İşlevi</h2></summary>
    filter Metodu: allPetitions dizisindeki her bir Petition nesnesini kontrol eder ve id parametresiyle eşleşenleri       filteredPetitions dizisine ekler.Hata Kontrolü: Eğer filtrelenmiş dizi boşsa, kullanıcıya bir hata mesajı gösterilir.Veri      Güncelleme: Filtrelenmiş veriler tabloya yüklenir.
    
    ```
    func filterPetitions(by id: String) {
    let filteredPetitions = allPetitions.filter { $0.id == id }
    if filteredPetitions.isEmpty {
        showError(title: "Bilgilendirme", message: "ID Eşleşmesi Bulunamadı")
    } else {
        petitions = filteredPetitions
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    }
    ```
  </details> 

  <details>
    <summary><h2>DetailViewController</h2></summary>
    WKWebView, web içeriğini göstermek için modern ve performanslı bir yöntemdir. UIWebView'ın yerine tercih edilmesi     önerilir.HTML içeriğini yüklemek için loadHTMLString metodu kullanılmıştır. Bu, hızlı ve basit bir yöntemdir ancak daha     karmaşık senaryolar için load metodunu kullanarak harici web sayfaları da yüklenebilir.
    
    ```
    override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let detailItem = detailItem else { return }
    
    let html = """
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style> body { font-size: 150%; } </style>
    </head>
    <body>
    \(detailItem.body)
    </body>
    </html>
    """
    
    webView.loadHTMLString(html, baseURL: nil)
    }

    ```
  </details> 


<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">US Amerika Dilekçelerin Listelenmesi</h4>
            <img src="https://github.com/user-attachments/assets/26aa7dd2-31ae-4ce8-87b9-a50f6b71b0a2" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Dilekçe İD araması</h4>
            <img src="https://github.com/user-attachments/assets/4d1be2a6-f165-46c2-8f03-c90de9ba911f" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">İD Arama Sonucu</h4>
            <img src="https://github.com/user-attachments/assets/c1b35ef6-9133-4a2c-8a7f-27978ed92ad1" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Çekilen Dilekçeyi Web Gösterilemesi</h4>
            <img src="https://github.com/user-attachments/assets/08348c5a-d9dd-4bbb-8ddb-a80189b183c8" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Verinin Gelidiği Json</h4>
            <img src="https://github.com/user-attachments/assets/184804c1-8216-4a2e-bb76-9b7b00e8d78c" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
