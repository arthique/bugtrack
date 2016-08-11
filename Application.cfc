<cfcomponent displayname="Application" output="false" hint="Handle the application.">

    <!--- Set up the application. --->
    <cfset this.name = "Bugtrack" />
    <cfset this.applicationTimeout = CreateTimeSpan( 0, 24, 0, 0 ) />
    <cfset this.sessionManagement = true />
    <cfset this.sessionTimeout = CreateTimeSpan( 0, 24, 0, 0 ) />
    <cfset this.setClientCookies = true />
    <cfset this.loginStorage = "session" />
    <cfset this.scriptProtect = true />
     
    <!--- Initialize session and application variables --->
    <cffunction name="onSessionStart" access="public" returntype="void" output="false" hint="I initialize the session.">
        <cfset session.authorized = "false" />
        <cfset session.user_id = "" />
        <cfset session.user_name = "" />
        <cfset session.dateInitialized = now() />
    </cffunction>

</cfcomponent>