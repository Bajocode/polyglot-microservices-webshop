//
//  ViewController.swift
//  frontend-ios
//
//  Created by Fabijan Bajo on 26/10/2020.
//

import UIKit
import RxSwift
import Moya

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        MicroserviceClient
            .execute(CatalogRequest.GetProducts())
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (products) in
                print(products)
            }, onError: { (error) in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

