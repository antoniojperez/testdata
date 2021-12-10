//
//  ViewController.swift
//  testdata
//
//  Created by Antonio on 9/12/21.
//

import UIKit
import Alamofire


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 

    @IBOutlet weak var tabla: UITableView!

    var datos: [ItemList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Montamos la URL a partir del string
        let dominio = "https://code-challenge-e9f47.web.app/transactions.json"
        guard let url = URL(string: dominio) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
    
            let decoder = JSONDecoder()
            //Creamos un Formateador de fechas para que convierta el string en Date directamente y lo asignamos al JSONDecoder
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let listResult = try! decoder.decode([Result<ItemList, DecodingError>].self, from: data)
             let list: [ItemList] = listResult.compactMap {try? $0.get()}
             // TODO una funcion que ordene y compruebe duplicados a la par
            let prefinal = list.sorted(by: {  $0.id < $1.id  && $0.date > $1.date })
            let final = self.removeDuplicateElements(posts: prefinal)
            self.datos = final.sorted(by: {  $0.date > $1.date })
        
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
        }
        
        self.tabla.delegate = self
        self.tabla.dataSource = self

        task.resume()
  
        
    }

    
    func removeDuplicateElements(posts: [ItemList]) -> [ItemList] {
        var uniquePosts = [ItemList]()
        for post in posts {
            if !uniquePosts.contains(where: { $0.id == post.id }) {
                uniquePosts.append(post)
            }
        }
        return uniquePosts
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "Cell") as! DataCell
        let fila = self.datos[indexPath.row]
        
        cell.configure(fila.date, amount: fila.amount ?? 0.0, fee: fila.fee ?? 0.0, id: fila.id)
        return cell
    }
   
}


