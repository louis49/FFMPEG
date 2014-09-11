Pod::Spec.new do |s|
s.name         = "FFmpeg"
s.version      = "2.3.3"
s.summary      = "FFmpeg static libraries compiled for iOS"

s.platform     = :ios

s.source   = { :git => 'https://github.com/louis49/FFMPEG.git', :tag => '2.3.3' }
s.default_subspec = 'x264'





s.prepare_command = <<-CMD
export PATH=/opt/local/bin:/usr/bin:/bin:/opt/local/bin:/usr/local/bin
cd "$PODS_ROOT"
echo "$PODS_ROOT"
rm -rf "fat-x264"
rm -rf "fat-ffmpeg"
./build-x264.sh
./build-ffmpeg.sh
rm -rf "x264"
rm -rf "scratch-x264"
rm -rf "thin-x264"
rm -rf "ffmpeg-2.3.3"
rm -rf "scratch"
rm -rf "thin"
CMD





s.subspec 'x264' do |s|
    s.source_files = 'fat-x264/include/*.h'
    s.preserve_paths = 'fat-x264/lib/libx264.a'
    s.vendored_libraries = 'fat-x264/lib/libx264.a'
end

s.subspec 'ffmpeg' do |s|
s.source_files = 'fat-ffmpeg/include/**/*.h'
s.preserve_paths = 'fat-ffmpeg/lib/*.a'
s.vendored_libraries = 'fat-ffmpeg/lib/*.a'
end

end