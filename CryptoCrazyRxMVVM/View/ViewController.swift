//
//  ViewController.swift
//  CryptoCrazyRxMVVM
//
//  Created by Furkan Kaya on 8.01.2024.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cryptoList = [Crypto]()
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let cryptoVM = CryptoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupBindings()
        cryptoVM.requestData()
        
        
    }
    
    private func setupBindings() {
        cryptoVM
            .loading
            .bind(to: self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // cryptoVM (CryptoViewModel) sınıfının 'error' özelliğini takip ediyoruz.
        cryptoVM
            .error
            // Veriyi çekme ve ekranda gösterme işlemleri farklı thread'lerde gerçekleşiyor.
            // 'observe(on:)' metodu, verinin hangi thread üzerinde gözlemleneceğini belirler.
            .observe(on: MainScheduler.asyncInstance)
            // Abonelik, bir hata string'i içerdiğinde çalışacak olan blok.
            .subscribe { errorString in
                // Hata mesajını konsola yazdırıyoruz.
                print("Hata Oluştu: \(errorString)")
            }
            // 'disposeBag', aboneliklerin düzenli bir şekilde serbest bırakılmasını sağlar.
            // Bu, bellek sızıntılarını önlemek için önemlidir.
            .disposed(by: disposeBag)
        
        // cryptoVM (CryptoViewModel) sınıfının 'cryptos' özelliğini takip ediyoruz.
        cryptoVM
            .cryptos
            // Veriyi çekme ve ekranda gösterme işlemleri farklı thread'lerde gerçekleşiyor.
            // 'observe(on:)' metodu, verinin hangi thread üzerinde gözlemleneceğini belirler.
            .observe(on: MainScheduler.asyncInstance)
            // Abonelik, kripto listesi değiştiğinde çalışacak olan blok.
            .subscribe { cryptos in
                // Yeni kripto listesini güncelliyoruz.
                self.cryptoList = cryptos
                // TableView'ı güncelliyoruz.
                self.tableView.reloadData()
            }
            // 'disposeBag', aboneliklerin düzenli bir şekilde serbest bırakılmasını sağlar.
            // Bu, bellek sızıntılarını önlemek için önemlidir.
            .disposed(by: disposeBag)
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }


}

