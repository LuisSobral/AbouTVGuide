//
//  FavoritosTableTableViewController.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 01/07/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import UIKit
import CoreData


class FavoritosTableTableViewController: UITableViewController {
    
    var serieFavoritas = ListaSeries()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SerieFavorita")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0
            {
                for result in results {
                    serie = Serie(id: ((result as AnyObject).value(forKey: "id") as? Int)!, nome: ((result as AnyObject).value(forKey: "nome") as? String)!, generos: ((result as AnyObject).value(forKey: "generos") as? [String])!, status: ((result as AnyObject).value(forKey: "status") as? String)!, tempoDuracao: ((result as AnyObject).value(forKey: "tempoDuracao") as? Int)!, horario: ((result as AnyObject).value(forKey: "horario") as? String)!, dias: ((result as AnyObject).value(forKey: "dias") as? [String])!, rating: ((result as AnyObject).value(forKey: "rating") as? Double)!, canal: ((result as AnyObject).value(forKey: "canal") as? String)!, imagemURL: ((result as AnyObject).value(forKey: "imagemURL") as? String)!, descricao: ((result as AnyObject).value(forKey: "descricao") as? String)!)
                    
                    self.serieFavoritas.series.append(serie!)
                }
            }
        }
        catch {
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serieFavoritas.series.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if let imagem = NSURL(string: serieFavoritas.series[indexPath.row].imagemURL) {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: imagem as URL)
                
                if data != nil {
                    DispatchQueue.main.async {
                        cell.imagemSerie.image = UIImage(data: data!)
                    }
                }
            }
        }
        
        cell.nomeSerie.text = serieFavoritas.series[indexPath.row].nome
        cell.ratingSerie.text = String(format: "%.1f", serieFavoritas.series[indexPath.row].rating)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        serie = serieFavoritas.series[indexPath.row]
        
        performSegue(withIdentifier: "mostrarDetalhe", sender: self)
    }
 

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SerieFavorita")
            
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                
                if results.count > 0
                {
                    for result in results {
                        let identificador = ((result as AnyObject).value(forKey: "id") as? Int)!
                        
                        if identificador == serieFavoritas.series[indexPath.row].id {
                            context.delete(result as! NSManagedObject)
                            serieFavoritas.series.remove(at: indexPath.row)
                            
                            OperationQueue.main.addOperation({
                                self.tableView.reloadData()
                            })
                            
                            return
                        }
                    }
                }
            }
            
            catch {
                
            }
        }
    }
}
