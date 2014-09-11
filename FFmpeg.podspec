Pod::Spec.new do |s|
s.name         = "FFmpeg"
s.version      = "2.3.3"
s.summary      = "FFmpeg static libraries compiled for iOS"
s.requires_arc = false

s.platform     = :ios


s.source   = { :git => 'https://github.com/louis49/FFMPEG.git', :tag => '2.3.3' }

s.prepare_command = <<-CMD

export PATH=/opt/local/bin:/usr/bin:/bin:/opt/local/bin:/usr/local/bin
cd "$PODS_ROOT"
echo "$PODS_ROOT"
#rm -rf "fat-x264"
#rm -rf "fat-ffmpeg"

./build-x264.sh
#./build-ffmpeg.sh

rm -rf "x264"
rm -rf "scratch-x264"
rm -rf "thin-x264"

rm -rf "ffmpeg-2.3.3"
rm -rf "scratch"
rm -rf "thin"
CMD

s.public_header_files = '**/*.h'
s.preserve_paths = '**/*.a'
s.library = 'x264'
s.xcconfig  =  { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/FFmpeg/fat-x264/lib"' }

end