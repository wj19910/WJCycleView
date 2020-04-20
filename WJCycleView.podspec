
Pod::Spec.new do |s|
  s.name             = 'WJCycleView'
  s.version          = '0.0.6'
  s.summary          = 'An infinite automatic scroll loop effect for ios.'
  s.homepage         = 'https://github.com/wj19910/WJCycleView'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Wangjing' => '827476559@qq.com' }
  s.source           = { :git => 'https://github.com/wj19910/WJCycleView.git', :tag => 'v' + s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = "WJCycleView/*.{h,m}"
end
