for id in {1..10330}; do
  mkdir -p data/$id
  wget -nv -nc http://www.loc.gov/jukebox/recordings/detail/id/$id/ -O data/$id/$id.html
  grep "<code>" data/$id/$id.html | sed -e 's/^\s*<code>//;s/<\/code>\s*$//' > data/$id/stream.json &
  grep 'rel="\(image_src\|alternate\)"' data/$id/$id.html | sed -e 's/.*href="\([^"]*\)".*/\1/' | sort -u | xargs -r -n 1 -P 10 wget -nv -nd -P data/$id/
  rtmpdump -r "rtmp://stream.media.loc.gov/vod/" --playpath "mp3:jukebox/$id_128" -o "data/$id/128.flv"
  rtmpdump -r "rtmp://stream.media.loc.gov/vod/" --playpath "mp3:jukebox/$id_320" -o "data/$id/320.flv"
  if [ -f STOP ]; then
    echo 'Stopping cleanly.'
    exit 0
  fi
done
