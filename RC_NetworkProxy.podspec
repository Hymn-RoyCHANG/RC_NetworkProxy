Pod::Spec.new do |spec|
  spec.name = 'RC_NetworkProxy'
  spec.version = '0.1.5'
  spec.ios.deployment_target = '8.0'

  spec.homepage = 'https://github.com/Hymn-RoyCHANG/RC_NetworkProxy'
  spec.license = 'MIT'
  spec.author = { 'Roy CHANG' => 'roychang_tech@163.com' }
  spec.source = { 
                  :git => 'https://github.com/Hymn-RoyCHANG/RC_NetworkProxy.git', 
                  :tag => spec.version
                }
  spec.summary = 'RC_NetworkProxy is a simple network proxy protocol for sending POST and GET etc.'

  #, 'RC_NetworkProxy/RC_NetworkProtocol_Imp/*.{h,m}'
  spec.source_files  = 'RC_NetworkProxy/*.{h,m}'

  spec.requires_arc = true
  spec.frameworks  = 'Foundation'

  spec.subspec 'RC_NetworkProtocol_Help' do |shelp|
    
    shelp.source_files = 'RC_NetworkProxy/RC_NetworkProtocol_Help/*.{h,m}'
  end
  
  spec.subspec 'RC_NetworkProtocol_Imp' do |simp|
    
    simp.ios.dependency 'AFNetworking', '~> 3.2.1'
    simp.ios.dependency 'RC_NetworkProxy/RC_NetworkProtocol_Help'

    simp.source_files = 'RC_NetworkProxy/RC_NetworkProtocol_Imp/*.{h,m}'
  end

end
