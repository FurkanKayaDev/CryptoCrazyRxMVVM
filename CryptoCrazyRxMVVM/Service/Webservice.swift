//
//  Webservice.swift
//  CryptoCrazyRxMVVM
//
//  Created by Furkan Kaya on 8.01.2024.
//

import Foundation

// CryptoError enum'u, Webservice tarafından fırlatılabilen hata durumlarını temsil eder.
public enum CryptoError: Error {
    case serverError // Sunucu hatası durumu
    case parsingError // Parse hatası durumu
}

class Webservice {
    
    // Veri çekme işlemini gerçekleştiren fonksiyon.
    // Parametreler:
    //   - url: Verinin çekileceği URL.
    //   - completion: Asenkron veri çekme işlemi tamamlandığında çağrılacak kapanış bloğu.
    func downloadCurrencies(url: URL, completion: @escaping (Result<[Crypto], CryptoError>) -> ()) {
        
        // URLSession ile asenkron olarak veriyi çekiyoruz.
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Hata durumu kontrolü.
            if let _ = error {
                // Hata durumu varsa .serverError döndürülüyor.
                completion(.failure(.serverError))
            } else if let data = data {
                // Veri başarıyla çekildiyse, JSONDecoder ile veriyi çözümlüyoruz.
                let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data)
                
                if let cryptoList = cryptoList {
                    // Veriyi başarıyla parse ettiysek .success durumu ile döndürüyoruz.
                    completion(.success(cryptoList))
                } else {
                    // Parse işlemi başarısız olduysa .parsingError durumu ile döndürülüyor.
                    completion(.failure(.parsingError))
                }
                
            }
            
        }.resume() // URLSession task'ını başlatıyoruz.
    }
    
}
