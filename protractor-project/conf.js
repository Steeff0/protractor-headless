
exports.config = {
    framework: 'jasmine',
    specs: ['specs/*.specs.js'],
    multiCapabilities: [{
        browserName: 'chrome'
    }],
    onPrepare: function(){
        const SpecReporter = require('jasmine-spec-reporter').SpecReporter;
        jasmine.getEnv().addReporter(new SpecReporter({
            spec: {
                displayStacktrace: true
            }
        }));
        //configure junit xml report
        var jasmineReporters = require('jasmine-reporters');
        jasmine.getEnv().addReporter(new jasmineReporters.JUnitXmlReporter({
            consolidateAll: true,
            filePrefix: 'guitest-xmloutput',
            savePath: './'
        }));
    }
}
