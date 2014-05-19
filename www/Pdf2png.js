var exec = require('cordova/exec');

/* constructor */
function Pdf2png() {}

Pdf2png.prototype.dummy = function() {
        exec(
            function(reply){ alert('ok: '+reply);      },
            function(err){ alert('Error: '+err); }
        , "Pdf2png", "echoTest", ['dummy']);
}

Pdf2png.prototype.echoTest = function(str, callback) {
        exec(
            function(reply){ callback('ok: '+reply);      },
            function(err){ callback('Error: '+err); }
        , "Pdf2png", "echoTest", [str]);
};

Pdf2png.prototype.backgroundTest = function(str, callback) {
        exec(
            function(reply){ callback('ok: '+reply);      },
            function(err){ callback('Error: '+err); }
        , "Pdf2png", "backgroundJobTest", [str]);
};

var pdf2png = new Pdf2png();
module.exports = pdf2png;
