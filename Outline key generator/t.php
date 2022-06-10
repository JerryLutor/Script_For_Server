<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Outline key generator</title>
<script src="gen.js"></script>
<script src="qrcode.min.js"></script>
</head>
<body>
<style>
.centered {
    position: fixed; /* or absolute */
    top: 50%;
    left: 50%;
    width: 200px;
    height:100px;
    margin: -50px 0 0 -100px;
    background: #f0f0f0;
}
</style>
<?php
	$select = $_GET['select'];
	$secret = $_GET['secret'];
	$ip = $_GET['ip'];
	$port = $_GET['port'];
?>

<form align="center" action="<?=$_SERVER['PHP_SELF']?>"> <br/>
<select name="select">
  <option value="aes-256-cfb">aes-256-cfb</option>
  <option value="chacha20-ietf-poly1305" selected>chacha20-ietf-poly1305</option>
</select>
<br/>
Password: <input type="text" name="secret" minlength="8" align="center"> <br/>
IP: <input type="text" name="ip" pattern="^((\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.){3}(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$" align="center"> <br/>
Port: <input type="text" name="port" minlength="4" maxlength="5"  align="center" value="8080"> <br/>
<input type="submit" align="center" value="OK">
 </form> 


<script>
var select = '<?php echo $select; ?>';
var secret = '<?php echo $secret; ?>';
var ip = '<?php echo $ip; ?>';
var port = '<?php echo $port; ?>';

var str = generateAccesskey(select, secret, ip, port);
document.write ("<h1>");
document.write ('<a style="color:#FF0000;">Outline key: </a>', str);
document.write ("</h1>");
document.write ("<div class='centered' id='qrcode'></div>");
new QRCode(document.getElementById("qrcode"), str);
</script>

</body>

</html>
