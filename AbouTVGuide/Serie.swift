//
//  Serie.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 20/06/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import Foundation

class Serie {
    var id = 0
    var nome = ""
    var generos : [String] = []
    var status = ""
    var tempoDuracao = 0
    var horario = ""
    var dias : [String] = []
    var rating = 0.0
    var canal = ""
    var imagemURL = ""
    var descricao = ""
    
    init(id: Int, nome: String, generos: [String], status: String, tempoDuracao: Int, horario: String, dias: [String], rating: Double, canal: String,
         imagemURL: String, descricao: String) {
        self.id = id
        self.nome = nome
        self.generos = generos
        self.status = status
        self.tempoDuracao = tempoDuracao
        self.horario = horario
        self.dias = dias
        self.rating = rating
        self.canal = canal
        self.imagemURL = imagemURL
        self.descricao = descricao
    }
    
}
