#
#  Be sure to run `pod spec lint SPLogManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SPLogManager"
  s.version      = "0.0.1"
  s.summary      = "A simple log manager support file logger and dynamic log level setting."

  s.description  = <<-DESC
                   SPLogManager is a simple class which manage CocoaLumberjack and NSLogger.
                   SPLogManager provide dynamic log level with type checking.
                   DESC

  s.homepage     = "https://github.com/hsin919/NSLogger-CocoaLumberjack-connector"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "BSD"
  # s.license      = { :type => "BSD", :file => "LICENSE" }
  
  s.author             = { "hsin" => "hsin919@gmail.com" }
  # Or just: s.author    = "hsin"
  # s.authors            = { "hsin" => "hsin919@gmail.com" }
  s.social_media_url   = "https://twitter.com/hsin919"

  s.ios.platform   = :ios, '5.0'
  s.osx.platform   = :osx, '10.7'

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #
  s.source       = { :git => "https://github.com/hsin919/NSLogger-CocoaLumberjack-connector.git", :commit => 'e67398426fab61908730428675257b730d12a62d' }
  #s.source       = { :git => "https://github.com/hsin919/NSLogger-CocoaLumberjack-connector.git", :tag => "0.0.1" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  #s.source_files  = '*.{h,m}'
  s.source_files  = '*.{h,m}', 'SPLogManager/*.{h,m}'

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "CocoaLumberjack"
  s.dependency "NSLogger"

end
