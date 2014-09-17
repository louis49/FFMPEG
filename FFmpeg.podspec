Pod::Spec.new do |s|
s.name         = "FFmpeg"
s.version      = "2.3.3"
s.summary      = "FFmpeg static libraries compiled for iOS"

s.platform     = :ios

s.source   = { :git => 'https://github.com/louis49/FFMPEG.git'}
s.default_subspec = 'ffmpeg'
s.libraries = 'iconv', 'bz2', 'z'

s.prepare_command = <<-CMD
cd "$PODS_ROOT"
./build-x264.sh
./build-ffmpeg.sh
mv fat/include/libavutil/time.h fat/include/libavutil/avutil_time.h

for f in $(find . -name *.h);do
echo $f
sed -i '' 's/<time.h>/<avutil_time.h>/g' $f
done

CMD


s.subspec 'ffmpeg' do |s|
    s.source_files = 'fat/include/**/*.h', 'fat/include/*.h'
    s.preserve_paths = 'fat/lib/*.a'
    s.vendored_libraries = 'fat/lib/*.a'
    s.frameworks = 'AVFoundation'
    s.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/FFmpeg/fat/include", "LIBRARY_SEARCH_PATHS" => "${PODS_ROOT}/FFmpeg/fat/lib" }
end

end