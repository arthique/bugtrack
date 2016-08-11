<!DOCTYPE html>
<html lang="en">
<head>
	<title><cfoutput encodefor="html">#GetApplicationMetaData().name#</cfoutput></title>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
	<link rel="stylesheet" href="libs/css/style.css" />	
	<script type="text/javascript" src="libs/js/modernizr-2.8.3.min.js"></script>
	<script type="text/javascript" src="libs/js/l10n.js"></script>
	<script>
	   	WebFontConfig = {
	    	custom: {
		    	families: ['Roboto:regular,bold,bolditalic,light,lightitalic'],
		    	urls: ['libs/css/fonts.css']
			}
	    };
		(function(d) {
		  var wf = d.createElement('script'), s = d.scripts[0];
		  wf.src = 'libs/js/webfont.js';
		  s.parentNode.insertBefore(wf, s);
		})(document);
	</script>
	<link rel="prefetch" type="application/l10n" href="locales.ini" />
</head>
<body>
    <div class="row page">
        <div class="panel panel-left">
            <header class="wrapper header">
                <h1 class="header__title">Bugtrack</h1>
            </header>
            <div class="col">                
                <div class="container login">
                    <div class="container__caption" data-l10n-id="authentification">Authentification</div>
                    <cfinclude template="loginform.cfm" /> 
                </div>
                <cfinclude template="tasks.cfm" />
                <div class="container meta">
                   <div class="container__caption" data-l10n-id="managment">Managment</div>
                   <div class="container__content">
                        <cfinclude template="metausers.cfm" />
                        <div class="meta__language">
                            <div class="language__caption" data-l10n-id="managment-users-language">Language selection</div>
                            <select class="language__select" id="lang">
                              <option class="select__option" value="en" selected data-l10n-id="managment-users-language-en">English</option>
                              <option class="select__option" value="ru" data-l10n-id="managment-users-language-ru">Russian</option>
                            </select>                        
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="panel panel-right">
            <main class="content" id="content">

            </main>
            
        </div>
    </div>
	<footer class="footer">
	    
	</footer>
	<script src="libs/js/common.js"></script>
	<script src="libs/js/app.js"></script>   
</body>
</html>