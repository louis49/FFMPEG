Pod::Spec.new do |s|
s.name         = "FFmpeg"
s.version      = "2.3.3"
s.summary      = "FFmpeg static libraries compiled for iOS"

s.platform     = :ios

s.source   = { :git => 'https://github.com/louis49/FFMPEG.git'}
s.default_subspec = 'ffmpeg'


#s.prepare_command = <<-CMD
#cd "$PODS_ROOT"
#./build-x264.sh
#./build-ffmpeg.sh
#CMD


s.subspec 'ffmpeg' do |s|
    s.source_files = 'fat/include/**/*.h', 'fat/include/*.h'
    s.preserve_paths = 'fat/lib/*.a'
    s.vendored_libraries = 'fat/lib/*.a'
    s.frameworks = 'AVFoundation', 'libiconv.dylib', 'libbz2.dylib', 'libz.dylib'
    s.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/FFmpeg/fat/include", "LIBRARY_SEARCH_PATHS" => "${PODS_ROOT}/FFmpeg/fat/lib" }
end


end