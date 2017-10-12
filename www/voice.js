var exec = require('cordova/exec');
module.exports = {
    startVoice: function (success, error) {
        exec(success, error, "Voice", "startVoice", []);
    }
};