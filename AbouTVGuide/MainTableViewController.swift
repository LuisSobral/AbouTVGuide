//
//  TableViewController.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 20/06/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import UIKit

var serie: Serie? = nil
var serieFavoritas = ListaSeries()

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    private let listaSeries = ListaSeries()
    private var seriesPrincipais = ListaSeries()
    private var seriesFiltradas = ListaSeries()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        CarregadorJSON().carregaTodasSeries { series in
            var contador = 0
            
            for serieJSON in series {
                let serie = ImportadorJSON().importaSerie(serie: serieJSON as! NSDictionary)
                
                if contador < 5 {
                    self.seriesPrincipais.series.append(serie)
                    contador = contador + 1
                }
                
                self.listaSeries.series.append(serie)
            
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
        
        searchBar()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seriesFiltradas.series.count == 0 {
            return seriesPrincipais.series.count
        }
        
        else {
            return seriesFiltradas.series.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var serieCelula: Serie
        
        if seriesFiltradas.series.count == 0 {
            serieCelula = seriesPrincipais.series[indexPath.row]
        }
        
        else {
            serieCelula = seriesFiltradas.series[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if let imagem = NSURL(string: serieCelula.imagemURL) {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: imagem as URL)
                
                if data != nil {
                    DispatchQueue.main.async {
                        cell.imagemSerie.image = UIImage(data: data!)
                    }
                }
            }
        }
        
        cell.nomeSerie.text = serieCelula.nome
        cell.ratingSerie.text = String(format: "%.1f", serieCelula.rating)
                
        return cell
    }
    
    func searchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.delegate = self as UISearchBarDelegate
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.seriesFiltradas.series = []
            self.tableView.reloadData()
        }
        
        else {
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -/:;()$&@.,?!'")
            
            if searchText.rangeOfCharacter(from: characterset.inverted) != nil {
                let alert = UIAlertController(title: "Desculpe", message: "Nao somos o twitter e nao trabalhamos com emojis ou bandeiras :(", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.seriesFiltradas.series = []
                self.tableView.reloadData()
            }
            
            else {
                self.seriesFiltradas.series = self.listaSeries.series.filter({ (serie) -> Bool in
                    return serie.nome.lowercased().contains(searchText.lowercased())
                })
            
                if self.seriesFiltradas.series.count == 0 {
                    let texto = searchText.replacingOccurrences(of: " ", with: "%20")
                    CarregadorJSON().carregaBusca(show: texto) { series in
                        for serieJSON in series {
                            if let json = (serieJSON as! NSDictionary).value(forKey: "show") as? NSDictionary {
                            
                                let serie = ImportadorJSON().importaSerie(serie: json)
                        
                                self.seriesFiltradas.series.append(serie)
                        
                                OperationQueue.main.addOperation({
                                    self.tableView.reloadData()
                                })
                            }
                        }
                
                    }
                }
                
                else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        tableView.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if seriesFiltradas.series.count == 0 {
            serie = seriesPrincipais.series[indexPath.row]
        }
        else {
            serie = seriesFiltradas.series[indexPath.row]
        }
        
        performSegue(withIdentifier: "mostrarDetalhe", sender: self)
    }
}
