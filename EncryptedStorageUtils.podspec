
Pod::Spec.new do |s|
s.name                  = 'EncryptedStorageUtils'
s.version               = '1.3'
s.summary               = '加密存储'
s.homepage              = 'https://github.com/heroims/EncryptedStorageUtils'
s.license               = { :type => 'MIT', :file => 'README.md' }
s.author                = { 'heroims' => 'heroims@163.com' }
s.source                = { :git => 'https://github.com/heroims/EncryptedStorageUtils.git', :tag => "#{s.version}" }
s.platform              = :ios, '6.0'
s.source_files          = 'EncryptedStorageUtils/*.{h,m}'
s.requires_arc          = true
end
