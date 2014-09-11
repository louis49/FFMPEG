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

./build-ffmpeg.sh armv7s

rm -rf "ffmpeg-2.3.3"
rm -rf "scratch"
rm -rf "thin"
CMD


s.subspec 'ffmpeg' do |s|
    s.source_files = 'fat-ffmpeg/include/**/*.h'
    s.preserve_paths = 'fat-ffmpeg/lib/*.a'
    s.vendored_libraries = 'fat-ffmpeg/lib/*.a'
end

end