// Utility function to build custom html markers
//
function CustomMarker(latlng, map, args) {
  this.latlng = latlng;	
  this.args = args;	
  this.setMap(map);	
}

// Setting used for setting the custom marker position
// the setting is based on css class: 'custom-marker'
var IconContainerSettings = {
  height: 22,
  width: 22
};

CustomMarker.prototype = new google.maps.OverlayView();

CustomMarker.prototype.draw = function() {

  var self = this;

  var div = this.div;

  if (!div) {

    div = this.div = document.createElement('div');

    div.className = 'custom-marker';

    div.style.position = 'absolute';
    div.style.cursor = 'pointer';
    div.innerHTML = self.args.content;


    google.maps.event.addDomListener(div, "click", function(event) {			
      google.maps.event.trigger(self, "click");
    });

    var panes = this.getPanes();
    panes.overlayImage.appendChild(div);
  }

  var point = this.getProjection().fromLatLngToDivPixel(this.latlng);

  // By default the the top left corner of custom marker is used to set marker position
  // To add a new icons use css to center the icon at bottom of 'custom-marker' css class
  // check the explancation from: http://humaan.com/custom-html-markers-google-maps/
  if (point) {
    div.style.left = (point.x - (IconContainerSettings.width / 2)) + 'px';
    div.style.top = (point.y - IconContainerSettings.height) + 'px';
  }
};

CustomMarker.prototype.remove = function() {
  if (this.div) {
    this.div.parentNode.removeChild(this.div);
    this.div = null;
  }	
};

CustomMarker.prototype.getPosition = function() {
  return this.latlng;	
};
