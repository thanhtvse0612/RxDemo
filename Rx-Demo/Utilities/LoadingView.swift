//
//  LoadingView.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/26/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import RxCocoa
import RxSwift

public class LoadingView: UIView {
    let indicatorView : UIActivityIndicatorView?
    static var loadingView = LoadingView(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect) {
        indicatorView = UIActivityIndicatorView()
        super.init(frame: frame)
        self.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        indicatorView?.color = UIColor.red
        
        if let indicatorView = indicatorView {
            self.addSubview(indicatorView)
            indicatorView.center = CGPoint(x: self.bounds.size.width/2 - indicatorView.frame.size.width/2,
                                           y: self.bounds.size.height/2 - indicatorView.frame.size.height/2)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoading(_ isShow:Bool)  {
        let window = UIApplication.shared.windows[0]
        
        if isShow {
            window.addSubview(self)
            indicatorView?.startAnimating()
        } else {
            self.removeFromSuperview()
            indicatorView?.stopAnimating()
        }
    }
}

extension Reactive where Base:LoadingView  {
    public var isShowing: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { loadingView, active in
            loadingView.showLoading(active)
        }
    }
}
