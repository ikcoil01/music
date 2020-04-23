param ($paramgenre)
$subscription=$null
$youtubeVideoLinkPrefixUrl='https://www.youtube.com/watch?v='
$youtubeVideoEmbedPrefixUrl='https://www.youtube.com/embed/'
$youtubeGenre=@{
    #values is channel id
  "EDM" = "xxxx","xxx","xxx";
  "Rap" = "xx-xxx","xxx","xxx","xxx";
}
$redirectPrefix='<!DOCTYPE html>
<html>
   <head>
      <title>HTML Meta Tag</title>
      <meta http-equiv = "refresh" content = "2; url = '

$redirectPost='" />
</head>
<body>
   <p>Loading</p>
</body>
</html>'

$preHref='<a href="'
$closeHref='" target="_blank">'
$postHref='</a>'
$urlPostUrlAutoPlay='?autoplay=1'
"<h1>Music Generator</h1>" > $psscriptroot\index.html
foreach($genre in $youtubeGenre.Keys){
    if($paramgenre.length -eq 0){

    }elseif($genre -ne $paramgenre){
        continue
    }
    "<h1>$genre</h1>" >> $psscriptroot\index.html
    foreach($subscription in $youtubeGenre."$genre"){
        
        $firstVideo=$false
        $subscriptionList=Invoke-RestMethod "https://www.youtube.com/feeds/videos.xml?channel_id=$subscription"
        $artistList=$subscriptionList.author.name | Get-Unique
        "<h1>$artistList</h1>" >> $psscriptroot\index.html
        $count=0
        foreach($video in $subscriptionList){
            $quePath="$psscriptroot\videoque\$count.html"
            $videoID=$video.videoId
            $videoTitle=$video.title
            $videoAuthor=$video.author.name
            $videoPublisheDate=$video.published
            Write-host "$youtubeVideoLinkPrefixUrl$videoID"
            "<h5>$preHref$youtubeVideoLinkPrefixUrl$videoID$urlPostUrlAutoPlay$closeHref$videoTitle$postHref</h5>" >> $psscriptroot\index.html
            "$redirectPrefix$youtubeVideoLinkPrefixUrl$videoID$urlPostUrlAutoPlay$redirectPost" > $quePath
            "<h1>$videoTitle</h1>" >> $quePath
            "<h1>$videoAuthor</h1>" >> $quePath
            "<h1>$videoPublisheDate</h1>" >> $quePath
            $count=$count+1
        }
        
    }
}