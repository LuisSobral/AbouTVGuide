//
//  SerieDetailViewController.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 30/06/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import UIKit
import CoreData

class SerieDetailViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var nota: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var duracao: UILabel!
    @IBOutlet weak var canal: UILabel!
    @IBOutlet weak var descricao: UILabel!
    @IBOutlet weak var generos: UILabel!
    @IBOutlet weak var dias: UILabel!
    @IBOutlet weak var favorito: UIButton!
    var serieFavoritas = ListaSeries()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carregaDados()
        carregaFavoritos()
        confereFavorito()
    }
    
    private func confereFavorito() {
        for favoritoSerie in serieFavoritas.series {
            if serie?.id == favoritoSerie.id {
                favorito.isEnabled = false
            }
        }
    }
    
    private func carregaFavoritos() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SerieFavorita")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0
            {
                for result in results {
                    let serieNova = Serie(id: ((result as AnyObject).value(forKey: "id") as? Int)!, nome: ((result as AnyObject).value(forKey: "nome") as? String)!, generos: ((result as AnyObject).value(forKey: "generos") as? [String])!, status: ((result as AnyObject).value(forKey: "status") as? String)!, tempoDuracao: ((result as AnyObject).value(forKey: "tempoDuracao") as? Int)!, horario: ((result as AnyObject).value(forKey: "horario") as? String)!, dias: ((result as AnyObject).value(forKey: "dias") as? [String])!, rating: ((result as AnyObject).value(forKey: "rating") as? Double)!, canal: ((result as AnyObject).value(forKey: "canal") as? String)!, imagemURL: ((result as AnyObject).value(forKey: "imagemURL") as? String)!, descricao: ((result as AnyObject).value(forKey: "descricao") as? String)!)
                    
                    self.serieFavoritas.series.append(serieNova)
                }
            }
        }
        catch {
            
        }
    }
    
    private func carregaDados() {
        
        if let imagem = NSURL(string: (serie!.imagemURL)) {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: imagem as URL)
                
                if data != nil {
                    DispatchQueue.main.async {
                        self.img.image = UIImage(data: data!)
                    }
                }
            }
        }
        
        self.nome.text = serie?.nome
        self.nota.text = String(format: "%.1f", (serie!.rating))
        self.status.text  = serie?.status
        self.duracao.text  = String(describing: serie?.tempoDuracao)
        self.canal.text = serie?.canal
        let descricaoUm = serie?.descricao.replacingOccurrences(of: "<p>", with: "")
        let descricaoDois = descricaoUm?.replacingOccurrences(of: "<b>", with: "")
        let descricaoTres = descricaoDois?.replacingOccurrences(of: "</b>", with: "")
        self.descricao.text = descricaoTres?.replacingOccurrences(of: "</p>", with: "")
        var gen = ""
        
        var cont = 0
        
        for genero in (serie?.generos)!
        {
            if cont != (serie?.generos.count)! - 1 {
                gen = gen + genero + ", "
            }
            
            else {
                gen = gen + genero
            }
            
            cont = cont + 1
        }
        
        generos.text = gen
        
        var days = ""
        
        for dia in (serie?.dias)!
        {
            days = days + dia + ", "
        }
        
        dias.text = days + (serie?.horario)!
        
    }
    
    @IBAction func saveToFavorites(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let newSerie = NSEntityDescription.insertNewObject(forEntityName: "SerieFavorita", into: managedContext)
        
        newSerie.setValue(serie!.id, forKey: "id")
        newSerie.setValue(serie!.nome, forKey: "nome")
        newSerie.setValue(serie!.imagemURL, forKey: "imagemURL")
        newSerie.setValue(serie!.rating, forKey: "rating")
        newSerie.setValue(serie!.status, forKey: "status")
        newSerie.setValue(serie!.tempoDuracao, forKey: "tempoDuracao")
        newSerie.setValue(serie!.canal, forKey: "canal")
        newSerie.setValue(serie!.generos, forKey: "generos")
        newSerie.setValue(serie!.descricao, forKey: "descricao")
        newSerie.setValue(serie!.dias, forKey: "dias")
        newSerie.setValue(serie!.horario, forKey: "horario")
        
        do{
            try managedContext.save()
            favorito.isEnabled = false
        }
        catch {
            //error
        }

    }
}
