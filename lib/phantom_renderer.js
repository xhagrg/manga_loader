var page = require('webpage').create(),
    url = "http://localhost:3100";

url = phantom.args[0];

page.open(url, function(status) {
  if (status !== "success") {
    console.log("Unable to access network");
  }
  else {
    // Execute some DOM inspection within the page context
    list = page.evaluate(function() {
      return document;
    });

    console.log(list.all[0].outerHTML);
  }

  phantom.exit();
});

page.onError = function(msg, trace) {
  console.log(msg);
  trace.forEach(function(item) {
    console.log('  ', item.file, ':', item.line);
  });
}