//
//  TableViewController.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 20/06/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import UIKit

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
        
        var serie: Serie
        
        if seriesFiltradas.series.count == 0 {
            serie = seriesPrincipais.series[indexPath.row]
        }
        
        else {
            serie = seriesFiltradas.series[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if let imagem = NSURL(string: serie.imagemURL) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imagem as URL)
                
                if data != nil {
                    DispatchQueue.main.async {
                        cell.imagemSerie.image = UIImage(data: data!)
                    }
                }
            }
        }
        
        cell.nomeSerie.text = serie.nome
        cell.ratingSerie.text = String(format: "%.1f", serie.rating)
        
        return cell
    }
    
    func searchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.seriesFiltradas.series = []
        }
        
        else {
            self.seriesFiltradas.series = self.listaSeries.series.filter({ (serie) -> Bool in
                return serie.nome.lowercased().contains(searchText.lowercased())
            })
        }
        
        self.tableView.reloadData()
    }

}
