Pod::Spec.new do |s|
s.name         = "FFmpeg"
s.version      = "2.3.3"
s.summary      = "FFmpeg static libraries compiled for iOS"

s.platform     = :ios

s.source   = { :git => 'https://github.com/louis49/FFMPEG.git'}
s.default_subspec = 'ffmpeg'

s.prepare_command = <<-CMD
export PATH=/opt/local/bin:/usr/bin:/bin:/opt/local/bin:/usr/local/bin
cd "$PODS_ROOT"
echo "$PODS_ROOT"

rm -rf "fat-ffmpeg"


./build-x264.sh

rm -rf "x264"
rm -rf "scratch-x264"
rm -rf "thin-x264"

./build-ffmpeg.sh

rm -rf "ffmpeg-2.3.3"
rm -rf "scratch"
rm -rf "thin"
CMD


s.subspec 'ffmpeg' do |s|
    s.source_files = 'fat/include/**/*.h', 'fat/include/*.h'
    s.preserve_paths = 'fat/lib/*.a'
    s.vendored_libraries = 'fat/lib/*.a'
end


end