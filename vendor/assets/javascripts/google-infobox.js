/**
 * @name InfoBox
 * @version 1.1.13 [March 19, 2014]
 * @author Gary Little (inspired by proof-of-concept code from Pamela Fox of Google)
 * @copyright Copyright 2010 Gary Little [gary at luxcentral.com]
 * @fileoverview InfoBox extends the Google Maps JavaScript API V3 <tt>OverlayView</tt> class.
 *  <p>
 *  An InfoBox behaves like a <tt>google.maps.InfoWindow</tt>, but it supports several
 *  additional properties for advanced styling. An InfoBox can also be used as a map label.
 *  <p>
 *  An InfoBox also fires the same events as a <tt>google.maps.InfoWindow</tt>.
 */

/*!
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*jslint browser:true */
/*global google */

/**
 * @name InfoBoxOptions
 * @class This class represents the optional parameter passed to the {@link InfoBox} constructor.
 * @property {string|Node} content The content of the InfoBox (plain text or an HTML DOM node).
 * @property {boolean} [disableAutoPan=false] Disable auto-pan on <tt>open</tt>.
 * @property {number} maxWidth The maximum width (in pixels) of the InfoBox. Set to 0 if no maximum.
 * @property {Size} pixelOffset The offset (in pixels) from the top left corner of the InfoBox
 *  (or the bottom left corner if the <code>alignBottom</code> property is <code>true</code>)
 *  to the map pixel corresponding to <tt>position</tt>.
 * @property {LatLng} position The geographic location at which to display the InfoBox.
 * @property {number} zIndex The CSS z-index style value for the InfoBox.
 *  Note: This value overrides a zIndex setting specified in the <tt>boxStyle</tt> property.
 * @property {string} [boxClass="infoBox"] The name of the CSS class defining the styles for the InfoBox container.
 * @property {Object} [boxStyle] An object literal whose properties define specific CSS
 *  style values to be applied to the InfoBox. Style values defined here override those that may
 *  be defined in the <code>boxClass</code> style sheet. If this property is changed after the
 *  InfoBox has been created, all previously set styles (except those defined in the style sheet)
 *  are removed from the InfoBox before the new style values are applied.
 * @property {string} closeBoxMargin The CSS margin style value for the close box.
 *  The default is "2px" (a 2-pixel margin on all sides).
 * @property {string} closeBoxURL The URL of the image representing the close box.
 *  Note: The default is the URL for Google's standard close box.
 *  Set this property to "" if no close box is required.
 * @property {Size} infoBoxClearance Minimum offset (in pixels) from the InfoBox to the
 *  map edge after an auto-pan.
 * @property {boolean} [isHidden=false] Hide the InfoBox on <tt>open</tt>.
 *  [Deprecated in favor of the <tt>visible</tt> property.]
 * @property {boolean} [visible=true] Show the InfoBox on <tt>open</tt>.
 * @property {boolean} alignBottom Align the bottom left corner of the InfoBox to the <code>position</code>
 *  location (default is <tt>false</tt> which means that the top left corner of the InfoBox is aligned).
 * @property {string} pane The pane where the InfoBox is to appear (default is "floatPane").
 *  Set the pane to "mapPane" if the InfoBox is being used as a map label.
 *  Valid pane names are the property names for the <tt>google.maps.MapPanes</tt> object.
 * @property {boolean} enableEventPropagation Propagate mousedown, mousemove, mouseover, mouseout,
 *  mouseup, click, dblclick, touchstart, touchend, touchmove, and contextmenu events in the InfoBox
 *  (default is <tt>false</tt> to mimic the behavior of a <tt>google.maps.InfoWindow</tt>). Set
 *  this property to <tt>true</tt> if the InfoBox is being used as a map label.
 */

/**
 * Creates an InfoBox with the options specified in {@link InfoBoxOptions}.
 *  Call <tt>InfoBox.open</tt> to add the box to the map.
 * @constructor
 * @param {InfoBoxOptions} [opt_opts]
 */
function InfoBox(opt_opts) {

    opt_opts = opt_opts || {};
<<<<<<< HEAD

    google.maps.OverlayView.apply(this, arguments);

=======
  
    google.maps.OverlayView.apply(this, arguments);
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    // Standard options (in common with google.maps.InfoWindow):
    //
    this.content_ = opt_opts.content || "";
    this.disableAutoPan_ = opt_opts.disableAutoPan || false;
    this.maxWidth_ = opt_opts.maxWidth || 0;
    this.pixelOffset_ = opt_opts.pixelOffset || new google.maps.Size(0, 0);
    this.position_ = opt_opts.position || new google.maps.LatLng(0, 0);
    this.zIndex_ = opt_opts.zIndex || null;
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    // Additional options (unique to InfoBox):
    //
    this.boxClass_ = opt_opts.boxClass || "infoBox";
    this.boxStyle_ = opt_opts.boxStyle || {};
    this.closeBoxMargin_ = opt_opts.closeBoxMargin || "2px";
    this.closeBoxURL_ = opt_opts.closeBoxURL || "http://www.google.com/intl/en_us/mapfiles/close.gif";
    if (opt_opts.closeBoxURL === "") {
      this.closeBoxURL_ = "";
    }
    this.infoBoxClearance_ = opt_opts.infoBoxClearance || new google.maps.Size(1, 1);
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    if (typeof opt_opts.visible === "undefined") {
      if (typeof opt_opts.isHidden === "undefined") {
        opt_opts.visible = true;
      } else {
        opt_opts.visible = !opt_opts.isHidden;
      }
    }
    this.isHidden_ = !opt_opts.visible;
<<<<<<< HEAD

    this.alignBottom_ = opt_opts.alignBottom || false;
    this.pane_ = opt_opts.pane || "floatPane";
    this.enableEventPropagation_ = opt_opts.enableEventPropagation || false;

=======
  
    this.alignBottom_ = opt_opts.alignBottom || false;
    this.pane_ = opt_opts.pane || "floatPane";
    this.enableEventPropagation_ = opt_opts.enableEventPropagation || false;
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    this.div_ = null;
    this.closeListener_ = null;
    this.moveListener_ = null;
    this.contextListener_ = null;
    this.eventListeners_ = null;
    this.fixedWidthSet_ = null;
  }
<<<<<<< HEAD

  /* InfoBox extends OverlayView in the Google Maps API v3.
   */
  InfoBox.prototype = new google.maps.OverlayView();

=======
  
  /* InfoBox extends OverlayView in the Google Maps API v3.
   */
  InfoBox.prototype = new google.maps.OverlayView();
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Creates the DIV representing the InfoBox.
   * @private
   */
  InfoBox.prototype.createInfoBoxDiv_ = function () {
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    var i;
    var events;
    var bw;
    var me = this;
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    // This handler prevents an event in the InfoBox from being passed on to the map.
    //
    var cancelHandler = function (e) {
      e.cancelBubble = true;
      if (e.stopPropagation) {
        e.stopPropagation();
      }
    };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    // This handler ignores the current event in the InfoBox and conditionally prevents
    // the event from being passed on to the map. It is used for the contextmenu event.
    //
    var ignoreHandler = function (e) {
<<<<<<< HEAD

      e.returnValue = false;

      if (e.preventDefault) {

        e.preventDefault();
      }

      if (!me.enableEventPropagation_) {

        cancelHandler(e);
      }
    };

    if (!this.div_) {

      this.div_ = document.createElement("div");

      this.setBoxStyle_();

=======
  
      e.returnValue = false;
  
      if (e.preventDefault) {
  
        e.preventDefault();
      }
  
      if (!me.enableEventPropagation_) {
  
        cancelHandler(e);
      }
    };
  
    if (!this.div_) {
  
      this.div_ = document.createElement("div");
  
      this.setBoxStyle_();
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      if (typeof this.content_.nodeType === "undefined") {
        this.div_.innerHTML = this.getCloseBoxImg_() + this.content_;
      } else {
        this.div_.innerHTML = this.getCloseBoxImg_();
        this.div_.appendChild(this.content_);
      }
<<<<<<< HEAD

      // Add the InfoBox DIV to the DOM
      this.getPanes()[this.pane_].appendChild(this.div_);

      this.addClickHandler_();

      if (this.div_.style.width) {

        this.fixedWidthSet_ = true;

      } else {

        if (this.maxWidth_ !== 0 && this.div_.offsetWidth > this.maxWidth_) {

          this.div_.style.width = this.maxWidth_;
          this.div_.style.overflow = "auto";
          this.fixedWidthSet_ = true;

        } else { // The following code is needed to overcome problems with MSIE

          bw = this.getBoxWidths_();

=======
  
      // Add the InfoBox DIV to the DOM
      this.getPanes()[this.pane_].appendChild(this.div_);
  
      this.addClickHandler_();
  
      if (this.div_.style.width) {
  
        this.fixedWidthSet_ = true;
  
      } else {
  
        if (this.maxWidth_ !== 0 && this.div_.offsetWidth > this.maxWidth_) {
  
          this.div_.style.width = this.maxWidth_;
          this.div_.style.overflow = "auto";
          this.fixedWidthSet_ = true;
  
        } else { // The following code is needed to overcome problems with MSIE
  
          bw = this.getBoxWidths_();
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
          this.div_.style.width = (this.div_.offsetWidth - bw.left - bw.right) + "px";
          this.fixedWidthSet_ = false;
        }
      }
<<<<<<< HEAD

      this.panBox_(this.disableAutoPan_);

      if (!this.enableEventPropagation_) {

        this.eventListeners_ = [];

=======
  
      this.panBox_(this.disableAutoPan_);
  
      if (!this.enableEventPropagation_) {
  
        this.eventListeners_ = [];
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        // Cancel event propagation.
        //
        // Note: mousemove not included (to resolve Issue 152)
        events = ["mousedown", "mouseover", "mouseout", "mouseup",
        "click", "dblclick", "touchstart", "touchend", "touchmove"];
<<<<<<< HEAD

        for (i = 0; i < events.length; i++) {

          this.eventListeners_.push(google.maps.event.addDomListener(this.div_, events[i], cancelHandler));
        }

=======
  
        for (i = 0; i < events.length; i++) {
  
          this.eventListeners_.push(google.maps.event.addDomListener(this.div_, events[i], cancelHandler));
        }
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        // Workaround for Google bug that causes the cursor to change to a pointer
        // when the mouse moves over a marker underneath InfoBox.
        this.eventListeners_.push(google.maps.event.addDomListener(this.div_, "mouseover", function (e) {
          this.style.cursor = "default";
        }));
      }
<<<<<<< HEAD

      this.contextListener_ = google.maps.event.addDomListener(this.div_, "contextmenu", ignoreHandler);

=======
  
      this.contextListener_ = google.maps.event.addDomListener(this.div_, "contextmenu", ignoreHandler);
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      /**
       * This event is fired when the DIV containing the InfoBox's content is attached to the DOM.
       * @name InfoBox#domready
       * @event
       */
      google.maps.event.trigger(this, "domready");
    }
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Returns the HTML <IMG> tag for the close box.
   * @private
   */
  InfoBox.prototype.getCloseBoxImg_ = function () {
<<<<<<< HEAD

    var img = "";

    if (this.closeBoxURL_ !== "") {

=======
  
    var img = "";
  
    if (this.closeBoxURL_ !== "") {
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      img  = "<img";
      img += " src='" + this.closeBoxURL_ + "'";
      img += " align=right"; // Do this because Opera chokes on style='float: right;'
      img += " style='";
      img += " position: relative;"; // Required by MSIE
      img += " cursor: pointer;";
      img += " margin: " + this.closeBoxMargin_ + ";";
      img += "'>";
    }
<<<<<<< HEAD

    return img;
  };

=======
  
    return img;
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Adds the click handler to the InfoBox close box.
   * @private
   */
  InfoBox.prototype.addClickHandler_ = function () {
<<<<<<< HEAD

    var closeBox;

    if (this.closeBoxURL_ !== "") {

      closeBox = this.div_.firstChild;
      this.closeListener_ = google.maps.event.addDomListener(closeBox, "click", this.getCloseClickHandler_());

    } else {

      this.closeListener_ = null;
    }
  };

=======
  
    var closeBox;
  
    if (this.closeBoxURL_ !== "") {
  
      closeBox = this.div_.firstChild;
      this.closeListener_ = google.maps.event.addDomListener(closeBox, "click", this.getCloseClickHandler_());
  
    } else {
  
      this.closeListener_ = null;
    }
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Returns the function to call when the user clicks the close box of an InfoBox.
   * @private
   */
  InfoBox.prototype.getCloseClickHandler_ = function () {
<<<<<<< HEAD

    var me = this;

    return function (e) {

      // 1.0.3 fix: Always prevent propagation of a close box click to the map:
      e.cancelBubble = true;

      if (e.stopPropagation) {

        e.stopPropagation();
      }

=======
  
    var me = this;
  
    return function (e) {
  
      // 1.0.3 fix: Always prevent propagation of a close box click to the map:
      e.cancelBubble = true;
  
      if (e.stopPropagation) {
  
        e.stopPropagation();
      }
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      /**
       * This event is fired when the InfoBox's close box is clicked.
       * @name InfoBox#closeclick
       * @event
       */
      google.maps.event.trigger(me, "closeclick");
<<<<<<< HEAD

      me.close();
    };
  };

=======
  
      me.close();
    };
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Pans the map so that the InfoBox appears entirely within the map's visible area.
   * @private
   */
  InfoBox.prototype.panBox_ = function (disablePan) {
<<<<<<< HEAD

    var map;
    var bounds;
    var xOffset = 0, yOffset = 0;

    if (!disablePan) {

      map = this.getMap();

      if (map instanceof google.maps.Map) { // Only pan if attached to map, not panorama

=======
  
    var map;
    var bounds;
    var xOffset = 0, yOffset = 0;
  
    if (!disablePan) {
  
      map = this.getMap();
  
      if (map instanceof google.maps.Map) { // Only pan if attached to map, not panorama
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        if (!map.getBounds().contains(this.position_)) {
        // Marker not in visible area of map, so set center
        // of map to the marker position first.
          map.setCenter(this.position_);
        }
<<<<<<< HEAD

        bounds = map.getBounds();

=======
  
        bounds = map.getBounds();
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        var mapDiv = map.getDiv();
        var mapWidth = mapDiv.offsetWidth;
        var mapHeight = mapDiv.offsetHeight;
        var iwOffsetX = this.pixelOffset_.width;
        var iwOffsetY = this.pixelOffset_.height;
        var iwWidth = this.div_.offsetWidth;
        var iwHeight = this.div_.offsetHeight;
        var padX = this.infoBoxClearance_.width;
        var padY = this.infoBoxClearance_.height;
        var pixPosition = this.getProjection().fromLatLngToContainerPixel(this.position_);
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        if (pixPosition.x < (-iwOffsetX + padX)) {
          xOffset = pixPosition.x + iwOffsetX - padX;
        } else if ((pixPosition.x + iwWidth + iwOffsetX + padX) > mapWidth) {
          xOffset = pixPosition.x + iwWidth + iwOffsetX + padX - mapWidth;
        }
        if (this.alignBottom_) {
          if (pixPosition.y < (-iwOffsetY + padY + iwHeight)) {
            yOffset = pixPosition.y + iwOffsetY - padY - iwHeight;
          } else if ((pixPosition.y + iwOffsetY + padY) > mapHeight) {
            yOffset = pixPosition.y + iwOffsetY + padY - mapHeight;
          }
        } else {
          if (pixPosition.y < (-iwOffsetY + padY)) {
            yOffset = pixPosition.y + iwOffsetY - padY;
          } else if ((pixPosition.y + iwHeight + iwOffsetY + padY) > mapHeight) {
            yOffset = pixPosition.y + iwHeight + iwOffsetY + padY - mapHeight;
          }
        }
<<<<<<< HEAD

        if (!(xOffset === 0 && yOffset === 0)) {

=======
  
        if (!(xOffset === 0 && yOffset === 0)) {
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
          // Move the map to the shifted center.
          //
          var c = map.getCenter();
          map.panBy(xOffset, yOffset);
        }
      }
    }
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Sets the style of the InfoBox by setting the style sheet and applying
   * other specific styles requested.
   * @private
   */
  InfoBox.prototype.setBoxStyle_ = function () {
<<<<<<< HEAD

    var i, boxStyle;

    if (this.div_) {

      // Apply style values from the style sheet defined in the boxClass parameter:
      this.div_.className = this.boxClass_;

      // Clear existing inline style values:
      this.div_.style.cssText = "";

      // Apply style values defined in the boxStyle parameter:
      boxStyle = this.boxStyle_;
      for (i in boxStyle) {

        if (boxStyle.hasOwnProperty(i)) {

          this.div_.style[i] = boxStyle[i];
        }
      }

      // Fix for iOS disappearing InfoBox problem.
      // See http://stackoverflow.com/questions/9229535/google-maps-markers-disappear-at-certain-zoom-level-only-on-iphone-ipad
      this.div_.style.WebkitTransform = "translateZ(0)";

=======
  
    var i, boxStyle;
  
    if (this.div_) {
  
      // Apply style values from the style sheet defined in the boxClass parameter:
      this.div_.className = this.boxClass_;
  
      // Clear existing inline style values:
      this.div_.style.cssText = "";
  
      // Apply style values defined in the boxStyle parameter:
      boxStyle = this.boxStyle_;
      for (i in boxStyle) {
  
        if (boxStyle.hasOwnProperty(i)) {
  
          this.div_.style[i] = boxStyle[i];
        }
      }
  
      // Fix for iOS disappearing InfoBox problem.
      // See http://stackoverflow.com/questions/9229535/google-maps-markers-disappear-at-certain-zoom-level-only-on-iphone-ipad
      this.div_.style.WebkitTransform = "translateZ(0)";
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      // Fix up opacity style for benefit of MSIE:
      //
      if (typeof this.div_.style.opacity !== "undefined" && this.div_.style.opacity !== "") {
        // See http://www.quirksmode.org/css/opacity.html
        this.div_.style.MsFilter = "\"progid:DXImageTransform.Microsoft.Alpha(Opacity=" + (this.div_.style.opacity * 100) + ")\"";
        this.div_.style.filter = "alpha(opacity=" + (this.div_.style.opacity * 100) + ")";
      }
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      // Apply required styles:
      //
      this.div_.style.position = "absolute";
      this.div_.style.visibility = 'hidden';
      if (this.zIndex_ !== null) {
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        this.div_.style.zIndex = this.zIndex_;
      }
    }
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Get the widths of the borders of the InfoBox.
   * @private
   * @return {Object} widths object (top, bottom left, right)
   */
  InfoBox.prototype.getBoxWidths_ = function () {
<<<<<<< HEAD

    var computedStyle;
    var bw = {top: 0, bottom: 0, left: 0, right: 0};
    var box = this.div_;

    if (document.defaultView && document.defaultView.getComputedStyle) {

      computedStyle = box.ownerDocument.defaultView.getComputedStyle(box, "");

      if (computedStyle) {

=======
  
    var computedStyle;
    var bw = {top: 0, bottom: 0, left: 0, right: 0};
    var box = this.div_;
  
    if (document.defaultView && document.defaultView.getComputedStyle) {
  
      computedStyle = box.ownerDocument.defaultView.getComputedStyle(box, "");
  
      if (computedStyle) {
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        // The computed styles are always in pixel units (good!)
        bw.top = parseInt(computedStyle.borderTopWidth, 10) || 0;
        bw.bottom = parseInt(computedStyle.borderBottomWidth, 10) || 0;
        bw.left = parseInt(computedStyle.borderLeftWidth, 10) || 0;
        bw.right = parseInt(computedStyle.borderRightWidth, 10) || 0;
      }
<<<<<<< HEAD

    } else if (document.documentElement.currentStyle) { // MSIE

      if (box.currentStyle) {

=======
  
    } else if (document.documentElement.currentStyle) { // MSIE
  
      if (box.currentStyle) {
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        // The current styles may not be in pixel units, but assume they are (bad!)
        bw.top = parseInt(box.currentStyle.borderTopWidth, 10) || 0;
        bw.bottom = parseInt(box.currentStyle.borderBottomWidth, 10) || 0;
        bw.left = parseInt(box.currentStyle.borderLeftWidth, 10) || 0;
        bw.right = parseInt(box.currentStyle.borderRightWidth, 10) || 0;
      }
    }
<<<<<<< HEAD

    return bw;
  };

=======
  
    return bw;
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Invoked when <tt>close</tt> is called. Do not call it directly.
   */
  InfoBox.prototype.onRemove = function () {
<<<<<<< HEAD

    if (this.div_) {

=======
  
    if (this.div_) {
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      this.div_.parentNode.removeChild(this.div_);
      this.div_ = null;
    }
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Draws the InfoBox based on the current map projection and zoom level.
   */
  InfoBox.prototype.draw = function () {
<<<<<<< HEAD

    this.createInfoBoxDiv_();

    var pixPosition = this.getProjection().fromLatLngToDivPixel(this.position_);

    this.div_.style.left = (pixPosition.x + this.pixelOffset_.width) + "px";

=======
  
    this.createInfoBoxDiv_();
  
    var pixPosition = this.getProjection().fromLatLngToDivPixel(this.position_);
  
    this.div_.style.left = (pixPosition.x + this.pixelOffset_.width) + "px";
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    if (this.alignBottom_) {
      this.div_.style.bottom = -(pixPosition.y + this.pixelOffset_.height) + "px";
    } else {
      this.div_.style.top = (pixPosition.y + this.pixelOffset_.height) + "px";
    }
<<<<<<< HEAD

    if (this.isHidden_) {

      this.div_.style.visibility = "hidden";

    } else {

      this.div_.style.visibility = "visible";
    }
  };

=======
  
    if (this.isHidden_) {
  
      this.div_.style.visibility = "hidden";
  
    } else {
  
      this.div_.style.visibility = "visible";
    }
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Sets the options for the InfoBox. Note that changes to the <tt>maxWidth</tt>,
   *  <tt>closeBoxMargin</tt>, <tt>closeBoxURL</tt>, and <tt>enableEventPropagation</tt>
   *  properties have no affect until the current InfoBox is <tt>close</tt>d and a new one
   *  is <tt>open</tt>ed.
   * @param {InfoBoxOptions} opt_opts
   */
  InfoBox.prototype.setOptions = function (opt_opts) {
    if (typeof opt_opts.boxClass !== "undefined") { // Must be first
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      this.boxClass_ = opt_opts.boxClass;
      this.setBoxStyle_();
    }
    if (typeof opt_opts.boxStyle !== "undefined") { // Must be second
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      this.boxStyle_ = opt_opts.boxStyle;
      this.setBoxStyle_();
    }
    if (typeof opt_opts.content !== "undefined") {
<<<<<<< HEAD

      this.setContent(opt_opts.content);
    }
    if (typeof opt_opts.disableAutoPan !== "undefined") {

      this.disableAutoPan_ = opt_opts.disableAutoPan;
    }
    if (typeof opt_opts.maxWidth !== "undefined") {

      this.maxWidth_ = opt_opts.maxWidth;
    }
    if (typeof opt_opts.pixelOffset !== "undefined") {

      this.pixelOffset_ = opt_opts.pixelOffset;
    }
    if (typeof opt_opts.alignBottom !== "undefined") {

      this.alignBottom_ = opt_opts.alignBottom;
    }
    if (typeof opt_opts.position !== "undefined") {

      this.setPosition(opt_opts.position);
    }
    if (typeof opt_opts.zIndex !== "undefined") {

      this.setZIndex(opt_opts.zIndex);
    }
    if (typeof opt_opts.closeBoxMargin !== "undefined") {

      this.closeBoxMargin_ = opt_opts.closeBoxMargin;
    }
    if (typeof opt_opts.closeBoxURL !== "undefined") {

      this.closeBoxURL_ = opt_opts.closeBoxURL;
    }
    if (typeof opt_opts.infoBoxClearance !== "undefined") {

      this.infoBoxClearance_ = opt_opts.infoBoxClearance;
    }
    if (typeof opt_opts.isHidden !== "undefined") {

      this.isHidden_ = opt_opts.isHidden;
    }
    if (typeof opt_opts.visible !== "undefined") {

      this.isHidden_ = !opt_opts.visible;
    }
    if (typeof opt_opts.enableEventPropagation !== "undefined") {

      this.enableEventPropagation_ = opt_opts.enableEventPropagation;
    }

    if (this.div_) {

      this.draw();
    }
  };

=======
  
      this.setContent(opt_opts.content);
    }
    if (typeof opt_opts.disableAutoPan !== "undefined") {
  
      this.disableAutoPan_ = opt_opts.disableAutoPan;
    }
    if (typeof opt_opts.maxWidth !== "undefined") {
  
      this.maxWidth_ = opt_opts.maxWidth;
    }
    if (typeof opt_opts.pixelOffset !== "undefined") {
  
      this.pixelOffset_ = opt_opts.pixelOffset;
    }
    if (typeof opt_opts.alignBottom !== "undefined") {
  
      this.alignBottom_ = opt_opts.alignBottom;
    }
    if (typeof opt_opts.position !== "undefined") {
  
      this.setPosition(opt_opts.position);
    }
    if (typeof opt_opts.zIndex !== "undefined") {
  
      this.setZIndex(opt_opts.zIndex);
    }
    if (typeof opt_opts.closeBoxMargin !== "undefined") {
  
      this.closeBoxMargin_ = opt_opts.closeBoxMargin;
    }
    if (typeof opt_opts.closeBoxURL !== "undefined") {
  
      this.closeBoxURL_ = opt_opts.closeBoxURL;
    }
    if (typeof opt_opts.infoBoxClearance !== "undefined") {
  
      this.infoBoxClearance_ = opt_opts.infoBoxClearance;
    }
    if (typeof opt_opts.isHidden !== "undefined") {
  
      this.isHidden_ = opt_opts.isHidden;
    }
    if (typeof opt_opts.visible !== "undefined") {
  
      this.isHidden_ = !opt_opts.visible;
    }
    if (typeof opt_opts.enableEventPropagation !== "undefined") {
  
      this.enableEventPropagation_ = opt_opts.enableEventPropagation;
    }
  
    if (this.div_) {
  
      this.draw();
    }
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Sets the content of the InfoBox.
   *  The content can be plain text or an HTML DOM node.
   * @param {string|Node} content
   */
  InfoBox.prototype.setContent = function (content) {
    this.content_ = content;
<<<<<<< HEAD

    if (this.div_) {

      if (this.closeListener_) {

        google.maps.event.removeListener(this.closeListener_);
        this.closeListener_ = null;
      }

      // Odd code required to make things work with MSIE.
      //
      if (!this.fixedWidthSet_) {

        this.div_.style.width = "";
      }

=======
  
    if (this.div_) {
  
      if (this.closeListener_) {
  
        google.maps.event.removeListener(this.closeListener_);
        this.closeListener_ = null;
      }
  
      // Odd code required to make things work with MSIE.
      //
      if (!this.fixedWidthSet_) {
  
        this.div_.style.width = "";
      }
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      if (typeof content.nodeType === "undefined") {
        this.div_.innerHTML = this.getCloseBoxImg_() + content;
      } else {
        this.div_.innerHTML = this.getCloseBoxImg_();
        this.div_.appendChild(content);
      }
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      // Perverse code required to make things work with MSIE.
      // (Ensures the close box does, in fact, float to the right.)
      //
      if (!this.fixedWidthSet_) {
        this.div_.style.width = this.div_.offsetWidth + "px";
        if (typeof content.nodeType === "undefined") {
          this.div_.innerHTML = this.getCloseBoxImg_() + content;
        } else {
          this.div_.innerHTML = this.getCloseBoxImg_();
          this.div_.appendChild(content);
        }
      }
<<<<<<< HEAD

      this.addClickHandler_();
    }

=======
  
      this.addClickHandler_();
    }
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    /**
     * This event is fired when the content of the InfoBox changes.
     * @name InfoBox#content_changed
     * @event
     */
    google.maps.event.trigger(this, "content_changed");
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Sets the geographic location of the InfoBox.
   * @param {LatLng} latlng
   */
  InfoBox.prototype.setPosition = function (latlng) {
<<<<<<< HEAD

    this.position_ = latlng;

    if (this.div_) {

      this.draw();
    }

=======
  
    this.position_ = latlng;
  
    if (this.div_) {
  
      this.draw();
    }
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    /**
     * This event is fired when the position of the InfoBox changes.
     * @name InfoBox#position_changed
     * @event
     */
    google.maps.event.trigger(this, "position_changed");
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Sets the zIndex style for the InfoBox.
   * @param {number} index
   */
  InfoBox.prototype.setZIndex = function (index) {
<<<<<<< HEAD

    this.zIndex_ = index;

    if (this.div_) {

      this.div_.style.zIndex = index;
    }

=======
  
    this.zIndex_ = index;
  
    if (this.div_) {
  
      this.div_.style.zIndex = index;
    }
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    /**
     * This event is fired when the zIndex of the InfoBox changes.
     * @name InfoBox#zindex_changed
     * @event
     */
    google.maps.event.trigger(this, "zindex_changed");
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Sets the visibility of the InfoBox.
   * @param {boolean} isVisible
   */
  InfoBox.prototype.setVisible = function (isVisible) {
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    this.isHidden_ = !isVisible;
    if (this.div_) {
      this.div_.style.visibility = (this.isHidden_ ? "hidden" : "visible");
    }
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Returns the content of the InfoBox.
   * @returns {string}
   */
  InfoBox.prototype.getContent = function () {
<<<<<<< HEAD

    return this.content_;
  };

=======
  
    return this.content_;
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Returns the geographic location of the InfoBox.
   * @returns {LatLng}
   */
  InfoBox.prototype.getPosition = function () {
<<<<<<< HEAD

    return this.position_;
  };

=======
  
    return this.position_;
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Returns the zIndex for the InfoBox.
   * @returns {number}
   */
  InfoBox.prototype.getZIndex = function () {
<<<<<<< HEAD

    return this.zIndex_;
  };

=======
  
    return this.zIndex_;
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Returns a flag indicating whether the InfoBox is visible.
   * @returns {boolean}
   */
  InfoBox.prototype.getVisible = function () {
<<<<<<< HEAD

    var isVisible;

=======
  
    var isVisible;
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    if ((typeof this.getMap() === "undefined") || (this.getMap() === null)) {
      isVisible = false;
    } else {
      isVisible = !this.isHidden_;
    }
    return isVisible;
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Shows the InfoBox. [Deprecated; use <tt>setVisible</tt> instead.]
   */
  InfoBox.prototype.show = function () {
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    this.isHidden_ = false;
    if (this.div_) {
      this.div_.style.visibility = "visible";
    }
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Hides the InfoBox. [Deprecated; use <tt>setVisible</tt> instead.]
   */
  InfoBox.prototype.hide = function () {
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
    this.isHidden_ = true;
    if (this.div_) {
      this.div_.style.visibility = "hidden";
    }
  };
<<<<<<< HEAD

=======
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Adds the InfoBox to the specified map or Street View panorama. If <tt>anchor</tt>
   *  (usually a <tt>google.maps.Marker</tt>) is specified, the position
   *  of the InfoBox is set to the position of the <tt>anchor</tt>. If the
   *  anchor is dragged to a new location, the InfoBox moves as well.
   * @param {Map|StreetViewPanorama} map
   * @param {MVCObject} [anchor]
   */
  InfoBox.prototype.open = function (map, anchor) {
<<<<<<< HEAD

    var me = this;

    if (anchor) {

=======
  
    var me = this;
  
    if (anchor) {
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
      this.position_ = anchor.getPosition();
      this.moveListener_ = google.maps.event.addListener(anchor, "position_changed", function () {
        me.setPosition(this.getPosition());
      });
    }
<<<<<<< HEAD

    this.setMap(map);

    if (this.div_) {

      this.panBox_();
    }
  };

=======
  
    this.setMap(map);
  
    if (this.div_) {
  
      this.panBox_();
    }
  };
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
  /**
   * Removes the InfoBox from the map.
   */
  InfoBox.prototype.close = function () {
<<<<<<< HEAD

    var i;

    if (this.closeListener_) {

      google.maps.event.removeListener(this.closeListener_);
      this.closeListener_ = null;
    }

    if (this.eventListeners_) {

      for (i = 0; i < this.eventListeners_.length; i++) {

=======
  
    var i;
  
    if (this.closeListener_) {
  
      google.maps.event.removeListener(this.closeListener_);
      this.closeListener_ = null;
    }
  
    if (this.eventListeners_) {
  
      for (i = 0; i < this.eventListeners_.length; i++) {
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
        google.maps.event.removeListener(this.eventListeners_[i]);
      }
      this.eventListeners_ = null;
    }
<<<<<<< HEAD

    if (this.moveListener_) {

      google.maps.event.removeListener(this.moveListener_);
      this.moveListener_ = null;
    }

    if (this.contextListener_) {

      google.maps.event.removeListener(this.contextListener_);
      this.contextListener_ = null;
    }

    this.setMap(null);
  };
=======
  
    if (this.moveListener_) {
  
      google.maps.event.removeListener(this.moveListener_);
      this.moveListener_ = null;
    }
  
    if (this.contextListener_) {
  
      google.maps.event.removeListener(this.contextListener_);
      this.contextListener_ = null;
    }
  
    this.setMap(null);
  };
  
  
>>>>>>> 5301bbdde1c7a611cf1bc85af563f2f2ca890cd6
