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
            this.todos = new api.collections.issues();
            ViewsFactory.menu();
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
            api
            .title(archive ? "Archive:" : "Your ToDos:")
            .changeContent(view.$el);
            view.setMode(archive ? "archive" : null).render();
        },
        archive: function() {
            this.list(true);
        },
        form: function() {
            if(!this.formView) {
                this.formView = new api.views.form({
                    model: api.todos
                }).on("saved", function() {
                    api.router.navigate("", {trigger: true});
                })
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
            api
            .title(archive ? "Archive:" : "Your ToDos:")
            .changeContent(view.$el);
            view.setMode(archive ? "archive" : null).render();
        },
        archive: function() {
            this.list(true);
        },
        newToDo: function() {},
        editToDo: function(index) {},
        delteToDo: function(index) {}
    });
    api.router = new Router();
 
    return api;
 
})();

(function (){
    app.views.menu = Backbone.View.extend({
        template: _.template($("#tpl-menu").html()),
        initialize: function() {
            this.render();
        },
        render: function(){
            this.$el.html(this.template({}));
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





window.onload = function() {
    app.init();
}

