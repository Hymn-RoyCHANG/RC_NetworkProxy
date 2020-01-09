Pod::Spec.new do |spec|
  spec.name = 'RC_NetworkProxy'
  spec.version = '0.1.0'
  spec.ios.deployment_target = '8.0'

  spec.homepage = 'https://github.com/Hymn-RoyCHANG/RC_NetworkProxy'
  spec.license = 'MIT'
  spec.author = { 'Roy CHANG' => 'roychang_tech@163.com' }
  spec.source = { :git => 'https://github.com/Hymn-RoyCHANG/RC_NetworkProxy.git', :tag => spec.version }
  spec.summary = 'RC_NetworkProxy is a simple network proxy protocol for sending POST and GET etc.'

  spec.source_files  = 'RC_NetworkProxy/RC_NetworkProxy.{h,m}'
  spec.public_header_files = 'RC_NetworkProxy/RC_NetworkProxy.h'

  spec.requires_arc = true
  spec.framework  = 'Foundation'

  spec.subspec 'RC_NetworkProtocol_Help' do |shelp|
    shelp.source_files = 'RC_NetworkProxy/RC_NetworkProtocol_Help/*.{h,m}'
    shelp.public_header_files = 'RC_NetworkProxy/RC_NetworkProtocol_Help/*.h'
  end
  
  spec.subspec 'RC_NetworkProtocol_Imp' do |simp|
    simp.dependency 'AFNetworking', '~> 3.2.1'
    simp.dependency 'RC_NetworkProxy/RC_NetworkProtocol_Help'

    simp.source_files = 'RC_NetworkProxy/RC_NetworkProtocol_Imp/*.{h,m}'
    simp.public_header_files = 'RC_NetworkProxy/RC_NetworkProtocol_Imp/*.h'
  end

end
