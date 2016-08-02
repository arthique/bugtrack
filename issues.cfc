<cfcomponent displayname="Bugtrack" hint="Webservice fot Bugtrack app">
   
    <cffunction name="getIssues" access="remote" returnformat="JSON" output="false">
        <cfargument name="issueid" type="any" required="false">
        <cfset returnArray = ArrayNew(1)>
        <cfquery name="qIssues" datasource="bugtrack">
            SELECT * 
            FROM bugtrack.bt_issues 
            <cfif IsDefined("argument.issueid") and isNumeric(argument.issueid)>
                WHERE issue_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#argument.issueid#">
            </cfif>
            ORDER BY issue_create_date
        </cfquery>
        
        <cfloop query="qIssues">
            <cfset issueStructure = StructNew()>
            <cfset issueStructure["id"] = issue_id >
            <cfset issueStructure["title"] = issue_title >
            <cfset issueStructure["status"] = issue_status >
            <cfset issueStructure["priority"] = issue_priority >
            <cfset issueStructure["state"] = issue_state >
            <cfset issueStructure["creator"] = issue_creator >
            <cfset issueStructure["executor"] = issue_executor >
            <cfset issueStructure["date"] = issue_create_date >
            
            <cfset ArrayAppend(returnArray, issueStructure)>
        </cfloop>
        
        <cfreturn SerializeJSON(returnArray)>
    </cffunction>
    
    <cffunction name="newIssue" access="remote" returntype="void" output="false">
        <cfargument name="jsStructure" required="true" type="string">
        <cfset var cfStructure = DeserializeJSON(argument.jsStructure)>
        <cfquery name="qNewUssue" datasource="bugtrack">
            INSERT INTO
                bugtrack.bt_issues (
                    issue_create_date,
                    issue_title,
                    issue_description,
                    issue_creator,
                    issue_executor,
                    issue_status,
                    issue_priority,
                    issue_state
                ) values (
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#cfStructure.date#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="100" value="#cfStructure.title#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="1000" value="#cfStructure.description#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.creator#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.executor#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.status#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.priority#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.state#">
                )
        </cfquery>
    </cffunction>
    <cffunction name="editIssue" access="remote"  returntype="void" output="false">
        <cfargument name="issueid" type="numeric" required="true">
        <cfargument name="jsStructure" required="true" type="string">
        <cfset var cfStructure = DeserializeJSON(argument.jsStructure)>
        <cfquery name="qEditIssue" datasource="bugtrack">
            UPDATE bugtrack.bt_issues
            SET 
                issue_create_date = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#cfStructure.date#">,
                issue_title = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="100" value="#cfStructure.title#">,
                issue_description = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="1000" value="#cfStructure.description#">,
                issue_creator = <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.creator#">,
                issue_executor = <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.executor#">,
                issue_status = <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.status#">,
                issue_priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.priority#">,
                issue_state = <cfqueryparam cfsqltype="cf_sql_integer" value="#cfStructure.state#">
            WHERE issue_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.issueid#">
        </cfquery>
    </cffunction>
    
    <cffunction name="removeIssue" access="remote" returntype="void" output="false">
        <cfargument name="issueid" type="numeric" required="true">
        <cfquery name="qIssues" datasource="bugtrack">
            DELETE FROM bt_issues
            WHERE issue_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.issueid#">
        </cfquery>
    </cffunction>
</cfcomponent>