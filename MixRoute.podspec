Pod::Spec.new do |s|
    s.name = 'MixRoute'
    s.version = '1.0.0'
    s.summary = 'Mix Route'
    s.authors = { 'Eric Long' => 'longminxiang@163.com' }
    s.license = 'MIT'
    s.homepage = "https://github.com/longminxiang/MixRoute"
    s.source  = { :git => "https://github.com/longminxiang/MixRoute.git", :tag => "v" + s.version }
    s.requires_arc = true
    s.ios.deployment_target = '8.0'

    s.source_files = 'Classes/**/*.{h,m}'
end
