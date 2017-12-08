Pod::Spec.new do |s|

  s.name         = "LPMWeakRefArray"
  s.version      = "0.0.1"
  s.summary      = "LPMWeakRefArray. 弱引用数组"
  s.description  = <<-DESC
                    LPMWeakRefArray 一个弱引用数组 数组元素被释放时自动删除item 而非将item置空 
                   DESC

  s.homepage     = "https://github.com/JaylonPan/LPMWeakRefArray"
  s.source       = {:git => "https://github.com/JaylonPan/LPMWeakRefArray.git", :tag => "#{s.version}"}
  s.license      = { :type => 'MIT', :text => <<-LICENSE
                      Copyright 2017
                      JaylonPan
                    LICENSE
                    }
  s.author       = { "Jaylon" => "269003942@qq.com" }
  s.platform     = :ios, "8.0"
  s.source_files  = "LPMWeakRefArray.{h,m}"
  s.header_dir = 'LPMWeakRefArray'
  
end