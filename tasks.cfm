<cfif session.authorized>
    <div class="container tasks" id="tasks">
        <div class="container__caption" data-l10n-id="tasks">Tasks</div>
        <div class="container__content">                       
            <a href="##/tasks/all" data-l10n-id="tasks-list">Task list</a>
            <a href="##/tasks/new" data-l10n-id="tasks-new">Create task</a>
        </div>
    </div>
</cfif>