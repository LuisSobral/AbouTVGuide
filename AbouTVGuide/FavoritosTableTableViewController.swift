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
            DispatchQueue.global().async {
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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
