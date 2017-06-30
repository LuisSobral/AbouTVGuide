//
//  SerieDetailViewController.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 30/06/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var horario: UILabel!
    
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
        self.descricao.text = serie?.descricao
        
        var gen = ""
        
        for genero in (serie?.generos)!
        {
            gen = gen + genero + ", "
        }
        
        generos.text = gen
        
        var days = ""
        
        for dia in (serie?.dias)!
        {
            days = days + dia + ", "
        }
        
        dias.text = days
        
        horario.text = serie?.horario
    }
}
