<cfif session.authorized && session.user_id NEQ "" >
    <cfoutput>
    <a class="login__username" href="##/users/profile">#session.user_id#</a>
    <a class="login__logout" href="auth.cfc?method=logout" data-l10n-id="managment-users-logout">Log out</a>
    </cfoutput>
<cfelse>
    <cfoutput>
       <div class="container__content" id="login"></div>
<!---
        <form class="login__form" id="loginForm" action="./auth.cfc?method=login" method="Post">
            <div class="col">
                <label class="login__label" for="userLogin" data-l10n-id="managment-users-name">Username</label>
                <div class="login__field"><input class="login__input" type="text" name="userLogin" maxlength="20"></div>           
            </div>
            <div class="col">
                <label class="login__label" for="userPassword" data-l10n-id="managment-users-password">Password</label>
                <div class="login__field"><input class="login__input" type="password" name="userPassword" maxlength="50"></div>
            </div>
            <div class="col">
                <button class="button login__submit" type="submit" data-l10n-id="managment-users-login">Log in</button>
            </div>
        </form>
--->
    </cfoutput>
</cfif>