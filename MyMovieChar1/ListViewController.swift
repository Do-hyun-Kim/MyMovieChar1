//
//  ListViewController.swift
//  MyMovieChar1
//
//  Created by Kim dohyun on 2018. 2. 18..
//  Copyright © 2018년 Kim dohyun. All rights reserved.
//

import UIKit


class ListViewController: UITableViewController {
    
   
    
   var list : [MovieVO] = {
        var detalist = [MovieVO]()
        
   
        return detalist
    }()
    var page = 1
    
    @IBOutlet var morebtn: UIButton!
    @IBAction func more(_ sender: AnyObject) {
        self.page += 1
        
       
        self.callMovieAPI()
        
        
        
        self.tableView.reloadData()
        
        
        
    }
    
    func callMovieAPI()  {
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=30&genreId=&order=releasedateasc"
        let apiurl : URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiurl)
        
        do {
            let apidictionary = try! JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            let hoppin = apidictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                
                
                
                
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"]as! NSString).doubleValue)
                let url : URL! = URL(string: mvo.thumbnail!)
                let imagedata = try! Data(contentsOf : url)
                mvo.thumbnailImage = UIImage(data: imagedata)
                
                
                self.list.append(mvo)
                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                
                if(self.list.count >= totalCount) {
                    self.morebtn.isHidden = true
                    let alert = UIAlertController(title: "마지막 목록입니다", message: "죄송하지만 마지막목록입니다", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                    alert.addAction(alertAction)
                }
                
                
                
            }
            
        } catch  {
            NSLog("Parser Error")
            
        }
        
    }
    
    override func viewDidLoad() {
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=1&count=10&genreId=&order=releasedateasc"
        let apiurl : URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiurl)
        
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("APIResult = \(log)")
        do {
            let apidictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apidictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie =  movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail =  r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                let url : URL! = URL(string: mvo.thumbnail!)
                let imagedata = try! Data(contentsOf : url)
                mvo.thumbnailImage = UIImage(data: imagedata)
                
                self.list.append(mvo)
            }
            
        } catch  {
            
            NSLog("Main Parser Error")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //주어진 행에 맞는 데이터 소스를 읽어 온다
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")! as! MoviewCell
        
        cell.title.text = row.title
        cell.desc.text = row.description
        cell.opendate.text = row.opendate
        cell.rating.text = "\(row.rating!)"
       
        DispatchQueue.main.async(execute: {
            cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
            
        })
       
        
        return cell                                                                                                                                                                                                                                                                     
    }
    func getThumbnailImage(_ index : Int) -> UIImage {
        
        let mvo = self.list[index]
        
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        }else{
            let url : URL! = URL(string: mvo.thumbnail!)
            let imageDate = try! Data(contentsOf : url)
            mvo.thumbnailImage = UIImage(data: imageDate)
            return mvo.thumbnailImage!
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_detail" {
            
           //sender 인자로 캐스팅 하여 테이블 셀 객체로 변환 한다
            let cell = sender as! MoviewCell
            //첫번째 인자값을 이용하여 사용자가 몇번째 행을선책했는지 확인한다
            let path = self.tableView.indexPath(for: cell)
            //api영화 데이터 배열중에서 선택된 행에 데이터를 추출한다
            let movieinfo = self.list[path!.row]
            
            let detailvc = segue.destination as? DetailViewController
            detailvc?.mvo = movieinfo
            
            
        }
    }
    
    
    
    
    
}
