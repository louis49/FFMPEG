Pod::Spec.new do |s|
s.name         = "FFmpeg"
s.version      = "2.3.3"
s.summary      = "FFmpeg static libraries compiled for iOS"
s.requires_arc = false

s.platform     = :ios

s.default_subspec = 'FFMPEG'

s.prepare_command = <<-CMD

export PATH=/opt/local/bin:/usr/bin:/bin:/opt/local/bin:/usr/local/bin
cd "$PODS_ROOT"

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

s.subspec 'FFMPEG' do |ss|
    ss.source_files = 'fat-ffmpeg/include/*.h'
    ss.preserve_paths = 'fat-ffmpeg/lib/*.a'
    ss.library = 'ffmpeg'
    ss.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/FFMPEG/fat-ffmpeg"' }
end

s.subspec 'x264' do |ss|
    ss.source_files = 'fat-x264/include/*.h'
    ss.preserve_paths = 'fat-x264/lib/*.a'
    ss.library = 'x264'
    ss.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/x264/fat-x264"' }
end


end