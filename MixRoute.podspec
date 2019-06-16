Pod::Spec.new do |s|
    s.name = 'MixRoute'
    s.version = '1.0.5'
    s.summary = 'Mix Route'
    s.authors = { 'Eric Long' => 'longminxiang@163.com' }
    s.license = 'MIT'
    s.homepage = "https://github.com/longminxiang/MixRoute"
    s.source  = { :git => "https://github.com/longminxiang/MixRoute.git", :tag => "v" + s.version.to_s }
    s.requires_arc = true
    s.ios.deployment_target = '8.0'
    s.dependency 'MixExtention', '~> 1.0'

    s.source_files = 'Classes/**/*.{h,m}'
end
