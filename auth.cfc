<cfcomponent displayname="auth">
   <cffunction name="login" access="remote" returnformat="JSON" output="false"> 
    <cfargument name="userLogin" required="true"/> 
    <cfargument name="userPassword" required="true"/> 
        <cfset total = {} />
        <cfset total['status'] = "error" />
        <cfquery name="qVerifyUser" dataSource="bugtrack">
            SELECT user_id, user_login, user_password, user_firstname, user_lastname
            FROM bugtrack.bt_users 
            WHERE 
                user_login = '#userLogin#' 
                AND user_password = '#userPassword#' 
        </cfquery>
        <cfif qVerifyUser.RecordCount>
            <cfset session.authorized = "true" />
            <cfset session.user_id = qVerifyUser.user_id />
            <cfset total['status'] = "success" />
            <cfset total['user'] = {} />
            <cfset total.user['name'] = qVerifyUser.user_id />
            <cfset total.user['fullname'] = "#qVerifyUser.user_firstname# #qVerifyUser.user_lastname#" />
        <cfelse>
            
            <cfset total['message'] = "Login or password incorrect!" />
            <cfset total['messageLocaleId'] = "login-password-incorrect" />
        </cfif>
        <cfreturn SerializeJSON(total)>
    </cffunction>
    <cffunction name="logout" access="remote" returntype="void" output="false">
        <cfset StructClear(Session)>
        <cfset session.authorized = "false" />
        <cfset session.user_id = "" />
    </cffunction> 
</cfcomponent>