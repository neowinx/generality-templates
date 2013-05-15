<#import "*/gen-options.ftl" as opt>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>${opt.applicationTitle}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="language" content="en" />
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	
	<script src="js/swfobject.js" type="text/javascript"></script>
	<script type="text/javascript">
		var flashvars = {
		};
		var params = {
			menu: "false",
			scale: "noScale",
			allowFullscreen: "true",
			allowScriptAccess: "always",
			bgcolor: "#FFFFFF"
		};
		var attributes = {
			id:"FlexCrud"
		};
		swfobject.embedSWF("AmfPHPFlexCrud.swf", "altContent", "100%", "100%", "10.0.0", "expressInstall.swf", flashvars, params, attributes);
	</script>
	<style type="text/css">
		html, body { height:100%; overflow:hidden; }
		body { margin:0; }
	</style>
</head>
<body>
	<div id="altContent">
		<h1>${opt.applicationTitle}</h1>
		<p>You need FlashPlayer 10.0.0 or later to see this site. Use the download link below to install the appropriate version and try again.</p>
		<p><a href="http://www.adobe.com/go/getflashplayer"><img 
			src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" 
			alt="Get Adobe Flash player" /></a></p>
	</div>
</body>
</html>