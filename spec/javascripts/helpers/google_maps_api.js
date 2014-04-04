var addScript = function(url) {
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.setAttribute('type', 'text/javascript');
    script.setAttribute('src', url);
    head.appendChild(script);
};

var sources = [
    '//maps.google.com/maps/api/js?v=3.13&sensor=false&libraries=geometry',
    'http://maps.gstatic.com/cat_js/intl/en_us/mapfiles/api-3/14/16/%7Bmain,geometry%7D.js',
    '/assets/google_maps.js?body=1',
    'http://maps.gstatic.com/cat_js/intl/en_us/mapfiles/api-3/14/16/%7Bcommon,map,util,marker%7D.js',
    'http://maps.gstatic.com/cat_js/intl/en_us/mapfiles/api-3/14/16/%7Binfowindow%7D.js',
    'http://maps.gstatic.com/cat_js/intl/en_us/mapfiles/api-3/14/16/%7Bonion%7D.js',
    'http://maps.gstatic.com/cat_js/intl/en_us/mapfiles/api-3/14/16/%7Bcontrols,stats%7D.js'
]

sources.forEach(function(source) {
    addScript(source)
});