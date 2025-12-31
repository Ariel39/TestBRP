<?php

$id = $_GET[ 'id' ];

?>

<html>
<head>
<title>Livewallpaper</title>
</head>
<body style="margin:0;">
<video loop autoplay muted width="100%" height="100%"><source src='http://cdn.rlib.io/wp/l/<?php echo $id;?>.webm' type='video/webm'></video>
</body>
</html>