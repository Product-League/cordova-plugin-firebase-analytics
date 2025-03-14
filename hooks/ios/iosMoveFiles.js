"use strict";

var path = require("path");

let xml2js = require('xml2js');
const fs = require('fs');

var constants = {
  googleServices: "google-services"
};

module.exports = function(context) {

  function getAppIdentifier(configPath) {
    const parseString = xml2js.parseString;
    const config_xml = fs.readFileSync(configPath).toString();
    let appId;

    parseString(config_xml, (err, config) => {
        if (err) return console.error(err);

        console.log("App identifier: " + config['widget']['$'].id);
        appId = config['widget']['$'].id;
    })
    return appId;
}

  fs.copyFileSync(context.opts.projectRoot + '/platforms/ios/www/' + getAppIdentifier(path.join(context.opts.projectRoot,'config.xml')) + '.firebase' + '/GoogleService-Info.plist' , path.join(context.opts.plugin.dir, 'GoogleService-Info.plist'));
  console.log("Source path: " + context.opts.projectRoot + '/platforms/ios/www/' + getAppIdentifier(path.join(context.opts.projectRoot,'config.xml')) + '.firebase' + '/GoogleService-Info.plist', "Dest path:" + path.join(context.opts.plugin.dir, 'GoogleService-Info.plist'))
}