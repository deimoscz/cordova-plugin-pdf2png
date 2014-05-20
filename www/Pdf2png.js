cordova.define("cz.doublev.cordova.core.pdf2png.Pdf2png", function(require, exports, module) { var exec = require('cordova/exec');

/* constructor */
function Pdf2png() {}

Pdf2png.prototype.dummy = function() {
        exec(
            function(reply){ alert('ok: '+reply);      },
            function(err){ alert('Error: '+err); }
        , "Pdf2png", "echoTest", ['dummy']);
}

Pdf2png.prototype.echoTest = function(obj) {
        exec(
            function(reply){ obj.success('ok: '+reply);      },
            function(err){ obj.fail('Error: '+err); }
        , "Pdf2png", "echoTest", [obj.pdf,obj.page,obj.width,obj.height]);
};

Pdf2png.prototype.backgroundTest = function(str, callback) {
        exec(
            function(reply){ callback('ok: '+reply);      },
            function(err){ callback('Error: '+err); }
        , "Pdf2png", "backgroundJobTest", [str]);
};

Pdf2png.prototype.getPage = function(obj){
        exec(
            function(reply){ obj.success(reply); },
            function(err){ obj.fail('Error: '+err); }
        , "Pdf2png", "getPage", [obj.pdf,obj.page,obj.width,obj.height,obj.autoRelease]);
};

Pdf2png.prototype.getPageInForeground = function(obj){
        exec(
            function(reply){ callback(reply); },
            function(err){ callback('Error: '+err); }
        , "Pdf2png", "getPageInForeground", [obj.pdf,obj.page,obj.width,obj.height,obj.autoRelease]);
};

Pdf2png.prototype.closePDF = function(success,fail){
        exec(
            function(reply){ success(reply); },
            function(err){ fail('Error: '+err); }
        , "Pdf2png", "closePDF", []);
};


var pdf2png = new Pdf2png();
module.exports = pdf2png;

});
