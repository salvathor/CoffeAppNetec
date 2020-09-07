//
//  MenuController.swift
//  coffeAppNetec
//
//  Created by Arlen Peña on 01/09/20.
//  Copyright © 2020 Arlen Peña. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var tblFavorites: UITableView!
    
    var user = "Invitado"
    var products = [Product]()
    var favoriteProducts = [Product]()
  
    var titleToSend = ""
    var productsToSend = [Product]()
    
    let menu = ["Bebidas","Postres","Emparedados"]
    let imgMenu = ["cafe2.png","mufin2.png","sandwich.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenu.delegate = self
        tblMenu.dataSource = self
        tblFavorites.dataSource = self
        tblFavorites.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lblWelcome.text = user
        createProducts()
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "subCategorySegue" {
          let vcd = segue.destination as! SubcategoryController
          vcd.myTitle = titleToSend
          vcd.products = productsToSend
        }
    }
    
    func createProducts() {
      products.removeAll()
      favoriteProducts.removeAll()
      
      products.append(Product(name: "Mokaccino", description: "cafe con chocolate", category: .drink, price: "50", size:.small ,favorite:false, quantity: 1, img: "cafe2.png"))
      products.append(Product(name: "Caramelo", description: "cafe de caramelo", category: .drink, price: "60", size: .small, favorite: false, quantity: 1, img: "cafe2.png") )
      products.append(Product(name: "Expresso", description: "cafe expresso", category: .drink, price: "40", size: .small, favorite: false, quantity:1, img: "cafe2.png"))
      products.append(Product(name: "Galleta de chocolate", description: "Galleta de chispas de chocolate", category: .dessert, price: "30", size:.unique , favorite:false, quantity: 1, img: "mufin2.png"))
      products.append(Product(name: "Muffin de arandanos", description: "Muffin de Arandanos", category: .dessert, price: "35",size:.unique, favorite: true, quantity:1, img: "mufin2.png"))
      products.append(Product(name: "Emparedado de jamon Serrano", description: "Emparedado de jamon serrano", category: .sandwich, price: "90", size: .unique, favorite: true,quantity:1, img: "sandwich.png"))
      products.append(Product(name: "Sandwich de Queso", description: "Sandwich de 3 Quesos", category: .sandwich, price: "90", size:.unique , favorite:false, quantity: 1, img: "sandwich.png"))
      products.append(Product(name: "Emparedado Vegetariano", description: "Emparedado de vegetales rostizados", category:.sandwich, price:"85", size: .unique, favorite: false, quantity: 1, img:"sandwich.png"))
      products.append(Product(name:"Pastel de zanahoria",description: "Rebanada de pastel de zanahoria", category: .dessert, price: "80", size:.small, favorite:true, quantity: 1, img: "mufin2.png"))
      
      favoriteProducts = products.filter({$0.favorite == true})
      dump(favoriteProducts)
      DispatchQueue.main.async {
        self.tblMenu.reloadData()
        self.tblFavorites.reloadData()
      }
    }
    
}

extension MenuController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if tableView == tblFavorites{
          rows = favoriteProducts.count
        }else if tableView == tblMenu {
          rows = menu.count
      }
      return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      var c = UITableViewCell()
      if tableView == tblMenu {
        c = tblMenu.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellController
        (c as! CellController).lblNameCategory.text = menu[indexPath.row]
        (c as! CellController).imgCategory.image = UIImage(named: imgMenu[indexPath.row])
        
        //return c
      }else if tableView == tblFavorites{
        c = tblFavorites.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CellFavorites
        (c as! CellFavorites).nameFavorite.text = favoriteProducts[indexPath.row].name
        (c as! CellFavorites).imgFavorite.image = UIImage(named: favoriteProducts[indexPath.row].img)
        
        //return c
      }
      return c
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if tableView == tblMenu {
          //print(Category.drink.numeration())
          var filter:Category?
          titleToSend = menu[indexPath.row]
          switch indexPath.row {
            case 0:
              filter = .drink
            case 1:
              filter = .dessert
            case 2:
              filter = .sandwich
            default:
              filter = Category.none
          }
          productsToSend = products.filter({$0.category == filter})
          //dump(productsToSend)
          performSegue(withIdentifier: "subCategorySegue", sender: nil)
      }
      
    }

}
