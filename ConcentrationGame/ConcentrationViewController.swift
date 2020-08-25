//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Hz on 2020/2/6.
//  Copyright © 2020年 Hz. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int{
        //get{//当计算属性只有get没set时,可省略
            return (cardButtons.count+1)/2
        //}
    }
    
    private(set) var flipCount = 0{
        didSet{
            updateFlipCountLabel()
        }
    }
    private func updateFlipCountLabel(){
        let attributes:[NSAttributedStringKey:Any]=[
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips:\(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    private var emojiChoices : Array<String> = ["👻","🐶","🐱","🍑","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷","🐵","🐔","🦆"]
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender){
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender)//点击显示牌面再点击翻回来的方法
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{print("chosen card was not in cardButtons")}
    }
    private func updateViewFromModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
    }
    private var emoji = [Int:String]()
    private func emoji(for card:Card) -> String{
        //每点到一张牌,随机分配一个图
        if emoji[card.identifier] == nil,emojiChoices.count > 0 {//if嵌套if的时候可用逗号分隔
            /* //为0或负数的话,arc4random处理会出错,因为只接受0到正整数区间内的数
                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
                emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
            */ //可以换成下面给Int加extension的方式
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            }
//        if emoji[card.identifier] != nil{
//            return emoji[card.identifier]!
//        }else{
//            return "?"
//        }
        return emoji[card.identifier] ?? "?"//等阶于上面
    }
    
    @IBAction private func restartGame(_ sender: UIButton) {
        flipCount = 0//重新来一局
        for index in cardButtons.indices{
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            cardButtons[index].setTitle("", for: .normal)
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
        }
    }
    
    //暂时不用了
    func flipCard(withEmoji emoji:String,on button:UIButton){
        if button.currentTitle == emoji{
            button.setTitle("", for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        }else{
            button.setTitle(emoji, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

//extension可以在不碰别的class代码时也能给它加var或func
extension Int{//给Int添加生成随机数的功能(属性),使得一个整数有点语法比如5.arc4random就是生成0-5的随机数
    var arc4random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))//self就是Int自己,这写法很酷吧
        }else if self < 0 {//虽然本游戏用不到,但考虑0和负数能使所有情况都包含进去,任何用途都能使用本extension
            return -Int(arc4random_uniform(UInt32(abs(self))))//self就是Int自己,这写法很酷吧
        }else {return 0}
    }
}

