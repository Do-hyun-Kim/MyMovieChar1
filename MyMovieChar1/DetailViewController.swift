//
//  DetailViewController.swift
//  MyMovieChar1
//
//  Created by Kim dohyun on 2018. 2. 28..
//  Copyright © 2018년 Kim dohyun. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    
    @IBOutlet var wv : UIWebView!
    
    var mvo : MovieVO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog(" detail = \(self.mvo.detail) title = \(self.mvo.title)")
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
       
        if let url = self.mvo?.detail {
            if let urlobj = URL(string: url){
                let req = URLRequest(url: urlobj)
                self.wv.loadRequest(req)
            }else{
                let alert = UIAlertController(title: "오류", message: "잘못된 URL입니다", preferredStyle: .alert)
                
                let connection = UIAlertAction(title: "확인", style: .cancel) {
                    (_) in
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }
                alert.addAction(connection)
                self.present(alert, animated: false, completion: nil)
            }
            }else{
                let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .cancel) {
                    (_) in
                 _ = self.navigationController?.popViewController(animated: true)
                
            }
            alert.addAction(cancel)
            self.present(alert, animated: false, completion: nil)
            
        }
        
    }
    
}
