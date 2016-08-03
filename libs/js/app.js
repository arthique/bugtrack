var app = (function () {
    "use strict";
    var api = {
        views: {},
        models: {},
        collections: {},
        content: null,
        router: null,
        issues: null,
        init: function () {
            this.content = $("#content");
            this.issues = new api.collections.issues();
            //ViewsFactory.menu();
            return this;
        },
        changeContent: function(el) {
            this.content.empty().append(el);
            return this;
        },
        title: function(str) {
            $("h1").text(str);
            return this;
        }
    };
    var ViewsFactory = {
        menu: function() {
            if(!this.menuView) {
                this.menuView = new api.views.menu({ 
                    el: $("#menu")
                });
            }
            return this.menuView;
        },
        list: function(archive) {
            var view = ViewsFactory.list();
            api.title(archive ? "Archive:" : "Your ToDos:").changeContent(view.$el);
            view.setMode(archive ? "archive" : null).render();
        },
        archive: function() {
            this.list(true);
        },
        form: function() {
            if(!this.formView) {
                this.formView = new api.views.form({
                    model: api.models.issue
                }).on("saved", function() {
                    api.router.navigate("", {trigger: true});
                });
            }
            return this.formView;
        }
    };
    var Router = Backbone.Router.extend({
        routes: {
            "archive": "archive",
            "new": "newToDo",
            "edit/:index": "editToDo",
            "delete/:index": "delteToDo",
            "": "list"
        },
        list: function(archive) {
            var view = ViewsFactory.list();
            api.title(archive ? "Archive:" : "Your ToDos:").changeContent(view.$el);
            view.setMode(archive ? "archive" : null).render();
        },
        archive: function() {
            this.list(true);
        },
        newToDo: function() {
            var view = ViewsFactory.form();
            api.title("Create new ToDo:").changeContent(view.$el);
            view.render();
        },
        editToDo: function(index) {
            var view = ViewsFactory.form();
            api.title("Edit:").changeContent(view.$el);
            view.render(index);
        },
        delteToDo: function(index) {
            api.issues.remove(api.issues.at(parseInt(index)));
            api.router.navigate("", {trigger: true});
        }
    });
    api.router = new Router();
 
    return api;
 
})();

(function (){
//    app.views.menu = Backbone.View.extend({
//        template: _.template($("#tpl-menu").html()),
//        initialize: function() {
//            this.render();
//        },
//        render: function(){
//            this.$el.html(this.template({}));
//        }
//    });
})(app);

(function (){
    app.views.list = Backbone.View.extend({
        mode: null,
        events: {
            'click a[data-up]': 'priorityUp',
            'click a[data-down]': 'priorityDown',
            'click a[data-archive]': 'archive',
            'click input[data-status]': 'changeStatus'
        },
        initialize: function() {
            var handler = _.bind(this.render, this);
            this.model.bind('change', handler);
            this.model.bind('add', handler);
            this.model.bind('remove', handler);
        },
        render: function() {
            var html = '<ul class="list">', 
                self = this;
            this.model.each(function(issue, index) {
                if(self.mode === "archive" ? issue.get("archived") === true : issue.get("archived") === false) {
                    var template = _.template($("#tpl-list-item").html());
                    html += template({ 
                        title: issue.get("title"),
                        index: index,
                        archiveLink: self.mode === "archive" ? "unarchive" : "archive",
                        done: issue.get("done") ? "yes" : "no",
                        doneChecked: issue.get("done")  ? 'checked=="checked"' : ""
                    });
                }
            });
            html += '</ul>';
            this.$el.html(html);
            this.delegateEvents();
            return this;
        },
        priorityUp: function(e) {
            var index = parseInt(e.target.parentNode.parentNode.getAttribute("data-index"));
            this.model.up(index);
        },
        priorityDown: function(e) {
            var index = parseInt(e.target.parentNode.parentNode.getAttribute("data-index"));
            this.model.down(index);
        },
        archive: function(e) {
            var index = parseInt(e.target.parentNode.parentNode.getAttribute("data-index"));
            this.model.archive(this.mode !== "archive", index); 
        },
        changeStatus: function(e) {
            var index = parseInt(e.target.parentNode.parentNode.getAttribute("data-index"));
            this.model.changeStatus(e.target.checked, index);       
        },
        setMode: function(mode) {
            this.mode = mode;
            return this;
        }
    });
})(app);

(function (){
    app.models.issue = Backbone.Model.extend({
        defaults: {
            title: "Issue",
            archived: false,
            done: false
        }
    });
})(app);

(function (){
    app.collections.issues = Backbone.Collection.extend({
        initialize: function(){
            this.add({ title: "Learn JavaScript basics" });
            this.add({ title: "Go to backbonejs.org" });
            this.add({ title: "Develop a Backbone application" });
        },
        model: app.models.issue,
        up: function(index) {
            if(index > 0) {
                var tmp = this.models[index-1];
                this.models[index-1] = this.models[index];
                this.models[index] = tmp;
                this.trigger("change");
            }
        },
        down: function(index) {
            if(index < this.models.length-1) {
                var tmp = this.models[index+1];
                this.models[index+1] = this.models[index];
                this.models[index] = tmp;
                this.trigger("change");
            }
        },
        archive: function(archived, index) {
            this.models[index].set("archived", archived);
        },
        changeStatus: function(done, index) {
            this.models[index].set("done", done);
        }
    });    
})(app);

(function (){
    app.views.form = Backbone.View.extend({
        index: false,
        events: {
            'click button': 'save'
        },
        initialize: function() {
            this.render();
        },
        render: function(index) {
            var template, html = $("#tpl-form").html();
            if(typeof index == 'undefined') {
                this.index = false;
                template = _.template(html, { title: ""});
            } else {
                this.index = parseInt(index);
                this.todoForEditing = this.model.at(this.index);
                template = _.template($("#tpl-form").html(), {
                    title: this.todoForEditing.get("title")
                });
            }
            this.$el.html(template);
            this.$el.find("textarea").focus();
            this.delegateEvents();
            return this;
        },
        save: function(e) {
            e.preventDefault();
            var title = this.$el.find("textarea").val();
            if(title === "") {
                window.alert("Empty textarea!"); return;
            }
            if(this.index !== false) {
                this.todoForEditing.set("title", title);
            } else {
                this.model.add({ title: title });
            }   
            this.trigger("saved");      
        }
    });
})(app);





window.onload = function() {
    app.init();
    document.webL10n.ready(onLocalized);
    function onLocalized() {
      var l10n = document.webL10n,
          textProp = document.body.textContent ? 'textContent' : 'innerText',
          ui = {
            lang: document.getElementById('lang')
          };
      ui.lang.value = (l10n.getLanguage().length > 2) ? l10n.getLanguage().substr(0,2) : l10n.getLanguage(); // not working with IE<9
      ui.lang.onchange = function() {
        l10n.setLanguage(this.value);
          
      };
    }
};

