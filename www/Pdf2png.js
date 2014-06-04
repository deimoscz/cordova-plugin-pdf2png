exec = require('cordova/exec');

function Pdf2png() {}


Pdf2png.prototype.getPage = function(obj){
        var cD=new Date();    
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
