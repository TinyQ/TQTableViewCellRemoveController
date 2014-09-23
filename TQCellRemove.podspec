
Pod::Spec.new do |s|

  s.name         = "TQCellRemove"
  s.version      = "0.0.1"
  s.summary      = "A table view cell remove animation with FBPOP."

  s.description  = <<-DESC
                   A table view cell remove animation with FBPOP.

                   DESC

  s.homepage     = "https://github.com/TinyQ/TQTableViewCellRemoveController"
  s.license      = "MIT (example)"
  s.source       = { :git => "https://github.com/TinyQ/TQTableViewCellRemoveController.git", :tag => "1.0.0" }


  s.source_files  = "TQRemoveController/**/*.{h,m}"
  s.requires_arc = true
end
