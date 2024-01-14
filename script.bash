cat << HEREDOC > process.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title></title>
  <link rel="stylesheet" href="https://unpkg.com/mvp.css"> 
  <style>
.container {
  width: 760px;
  margin: 0 auto;
  padding: 5px;
}

body {
  background: #F6F6EF;
}
  </style>
</head>
<body>
  <div class="container">
    $(pandoc process-final.txt -f gfm -t html)
  </div>
</body>
</html>
HEREDOC
