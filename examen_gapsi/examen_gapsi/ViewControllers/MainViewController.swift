//
//  MainViewController.swift
//  examen_gapsi
//
//  Created by Adolfo Lozada Serena on 24/04/21.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    
    let cellIdentifier = "cell"
    private var items: [Items]? = nil
    
    let loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recortar boton 'Buscar'
        searchButton.layer.cornerRadius = 5
        
        // Se agrega un loader
        self.view.addSubview(loadingView)
    }
    
    // MARK: - Actions
    
    @IBAction func tapAction(_ sender: Any) {
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func searchAction() {
        searchTextField.resignFirstResponder()
        
        guard let searchString = searchTextField.text else {
            return
        }
        
        if searchString.count > 0 {
            // Mostrar loader
            loadingView.showLoadingView()
            
            // Ejecutar búsqueda
            let escapedString = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            NSLog("Buscar: " + escapedString)
            let connectionManager = ConnectionManager()
            connectionManager.connectionSearchResults(escapedString) { (response) in
                //Ocultar loader
                self.loadingView.hideLoadingView()
                
                // conección correcta
                if response.code == 0 {
                    // Redibujar tabla
                    let result = response.object as! Result
                    if result.totalResults ?? 0 > 0 {
                        self.items = result.items
                    } else {
                        self.items = nil
                    }
                    self.searchTableView.reloadData()
                    
                    // Guardar búsqueda
                    Searchs.saveSearch(title: searchString)
                }
                // error con la conección
                else {
                    let alertController = UIAlertController(title: nil, message: response.message, preferredStyle: .alert)
                    let acceptAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                    alertController.addAction(acceptAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 > 0 {
            if let searchs = Searchs.completeSearch(title: textField.text!){
                for search in searchs {
                    NSLog("complete \(search.title)")
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction()
        
        return true
    }
    
    // MARK: - TableView Delegate + DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        let item = items?[indexPath.row]
        cell.textLabel?.text = item?.title
        cell.textLabel?.numberOfLines = 2
        cell.detailTextLabel?.text = "Price: $" + (item?.price)!
        cell.imageView?.image = UIImage(named: "not_available.png")
        
        if let urlPhoto = item?.image {
            if let imageURL = URL(string: (urlPhoto)){
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else {return}
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
            else {
                // Error al cargar la imagen
                //cell.imageView?.image = UIImage(named: "")
            }
        }
        else {
            // No hay url de imagen
            //cell.imageView?.image = UIImage(named: "")
        }
        
        return cell
    }

}
