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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imagem = NSURL(string: (serie!.imagemURL)) {
            DispatchQueue.global().async {
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
        self.descricao.text = descricaoUm?.replacingOccurrences(of: "</p>", with: "")
        var gen = ""
        
        var cont = 0
        
        for genero in (serie?.generos)!
        {
            if cont != (serie?.generos.count)! - 1 {
                gen = gen + genero + ", "
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
            print("SAVED")
        }
        catch {
            //error
        }

    }
}
