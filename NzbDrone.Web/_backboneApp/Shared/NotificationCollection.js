﻿define(['app', 'Shared/NotificationModel'], function () {

    var collection = Backbone.Collection.extend({

        model: NzbDrone.Shared.NotificationModel,
        
        initialize: function () {

          /*  var model = new NzbDrone.Shared.NotificationModel();
            model.set('title','test notification');
            model.set('message','test message');
            model.set('level', 'error');
            this.push(model);
          */

            var self = this;

            window.onerror = function (msg, url, line) {

                try {
                    var model = new NzbDrone.Shared.NotificationModel();

                    var a = document.createElement('a');
                    a.href = url;

                    model.set('title', a.pathname.split('/').pop() + ' : ' + line);
                    model.set('message', msg);
                    model.set('level', 'error');
                    self.push(model);
                } catch (error) {

                    console.log("An error occurred while reporting error. " + error);
                    console.log(msg);
                    alert('Couldn\'t report JS error.  ' + msg);
                }

                return false; //don't suppress default alerts and logs.
            };

            $(document).ajaxError(function (event, xmlHttpRequest, ajaxOptions) {

                //don't report 200 error codes
                if (xmlHttpRequest.status >= 200 && xmlHttpRequest.status <= 300) {
                    return undefined;
                }

                //doesn't report aborted requests
                if (xmlHttpRequest.statusText === 'abort') {
                    return undefined;
                }

                var model = new NzbDrone.Shared.NotificationModel();
                model.set('title', ajaxOptions.type + " " + ajaxOptions.url + " : " + xmlHttpRequest.statusText);
                model.set('message', xmlHttpRequest.responseText);
                model.set('level', 'error');
                self.push(model);

                return false;
            });
        }
    });

    return new collection();
});


