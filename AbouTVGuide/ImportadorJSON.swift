//
//  ImportadorJSON.swift
//  AbouTVGuide
//
//  Created by Luis Felipe Sobral on 20/06/17.
//  Copyright © 2017 AbouTV. All rights reserved.
//

import Foundation

class ImportadorJSON {
    
    func importaSerie(serie: NSDictionary) -> Serie {
        let id = importaId(serie: serie)
        let nome = importaNome(serie: serie)
        let generos : [String] = importaGeneros(serie: serie)
        let status = importaStatus(serie: serie)
        let tempoDuracao = importaTempo(serie: serie)
        let horario = importaHorario(serie: serie)
        let dias : [String] = importaDias(serie: serie)
        let rating = importaRating(serie: serie)
        let canal = importaCanal(serie: serie)
        let imagemURL = importaURLImagem(serie: serie)
        let descricao = importaDescricao(serie: serie)
        
        return Serie(id: id, nome: nome, generos: generos, status: status, tempoDuracao: tempoDuracao, horario: horario, dias: dias, rating: rating, canal: canal, imagemURL: imagemURL, descricao: descricao)
    }
    
    private func importaId(serie: NSDictionary) -> Int {
        if let id = serie.value(forKey: "id") as? Int {
            return id
        }
        
        return 0
    }
    
    private func importaNome(serie: NSDictionary) -> String {
        if let nome = serie.value(forKey: "name") as? String {
            return nome
        }
        
        return ""
    }
    
    private func importaGeneros(serie: NSDictionary) -> [String] {
        if let generos = serie.value(forKey: "genres") as? [String] {
            return generos
        }
        
        return []
    }
    
    private func importaStatus(serie: NSDictionary) -> String {
        if let status = serie.value(forKey: "status") as? String {
            return status
        }
        
        return ""
    }
    
    private func importaTempo(serie: NSDictionary) -> Int {
        if let tempo = serie.value(forKey: "runtime") as? Int {
            return tempo
        }
        
        return 0
    }
    
    private func importaHorario(serie: NSDictionary) -> String {
        if let schedule = serie.value(forKey: "schedule") as? NSDictionary {
            if let horario = schedule.value(forKey: "time") as? String {
                return horario
            }
        }
        
        return ""
    }
    
    private func importaDias(serie: NSDictionary) -> [String] {
        if let schedule = serie.value(forKey: "schedule") as? NSDictionary {
            if let dias = schedule.value(forKey: "days") as? [String] {
                return dias
            }
        }
        
        return []
    }
    
    private func importaRating(serie: NSDictionary) -> Double {
        if let rating = serie.value(forKey: "rating") as? NSDictionary {
            if let media = rating.value(forKey: "average") as? Double {
                return media
            }
        }
        
        return 0.0
    }
    
    private func importaCanal(serie: NSDictionary) -> String {
        if let canal = serie.value(forKey: "network") as? NSDictionary {
            if let nomeCanal = canal.value(forKey: "name") as? String {
                return nomeCanal
            }
        }
        
        return ""
    }
    
    private func importaURLImagem(serie: NSDictionary) -> String {
        if let imagem = serie.value(forKey: "image") as? NSDictionary {
            if let url = imagem.value(forKey: "original") as? String {
                return url
            }
        }
        
        return ""
    }
    
    private func importaDescricao(serie: NSDictionary) -> String {
        if let descricao = serie.value(forKey: "summary") as? String {
            return descricao
        }
        
        return ""
    }
}
