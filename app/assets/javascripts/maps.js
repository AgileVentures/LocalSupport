// https://github.com/topojson/topojson Version 3.0.2. Copyright 2017 Mike Bostock.
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
function InfoBox(t) {
  t = t || {}, google.maps.OverlayView.apply(this, arguments), this.content_ = t.content || "", this.disableAutoPan_ = t.disableAutoPan || !1, this.maxWidth_ = t.maxWidth || 0, this.pixelOffset_ = t.pixelOffset || new google.maps.Size(0, 0), this.position_ = t.position || new google.maps.LatLng(0, 0), this.zIndex_ = t.zIndex || null, this.boxClass_ = t.boxClass || "infoBox", this.boxStyle_ = t.boxStyle || {}, this.closeBoxMargin_ = t.closeBoxMargin || "2px", this.closeBoxURL_ = t.closeBoxURL || "http://www.google.com/intl/en_us/mapfiles/close.gif", "" === t.closeBoxURL && (this.closeBoxURL_ = ""), this.infoBoxClearance_ = t.infoBoxClearance || new google.maps.Size(1, 1), "undefined" == typeof t.visible && ("undefined" == typeof t.isHidden ? t.visible = !0 : t.visible = !t.isHidden), this.isHidden_ = !t.visible, this.alignBottom_ = t.alignBottom || !1, this.pane_ = t.pane || "floatPane", this.enableEventPropagation_ = t.enableEventPropagation || !1, this.div_ = null, this.closeListener_ = null, this.moveListener_ = null, this.contextListener_ = null, this.eventListeners_ = null, this.fixedWidthSet_ = null
}

function CustomMarker(t, e, n) {
  this.latlng = t, this.args = n, this.setMap(e)
}! function(t, e) {
  "object" == typeof exports && "undefined" != typeof module ? e(exports) : "function" == typeof define && define.amd ? define(["exports"], e) : e(t.topojson = t.topojson || {})
}(this, function(t) {
  "use strict";

  function e(t, e) {
      var o = e.id,
          i = e.bbox,
          r = null == e.properties ? {} : e.properties,
          s = n(t, e);
      return null == o && null == i ? {
          type: "Feature",
          properties: r,
          geometry: s
      } : null == i ? {
          type: "Feature",
          id: o,
          properties: r,
          geometry: s
      } : {
          type: "Feature",
          id: o,
          bbox: i,
          properties: r,
          geometry: s
      }
  }

  function n(t, e) {
      function n(t, e) {
          e.length && e.pop();
          for (var n = c[t < 0 ? ~t : t], o = 0, i = n.length; o < i; ++o) e.push(l(n[o], o));
          t < 0 && k(e, i)
      }

      function o(t) {
          return l(t)
      }

      function i(t) {
          for (var e = [], o = 0, i = t.length; o < i; ++o) n(t[o], e);
          return e.length < 2 && e.push(e[0]), e
      }

      function r(t) {
          for (var e = i(t); e.length < 4;) e.push(e[0]);
          return e
      }

      function s(t) {
          return t.map(r)
      }

      function a(t) {
          var e, n = t.type;
          switch (n) {
              case "GeometryCollection":
                  return {
                      type: n,
                      geometries: t.geometries.map(a)
                  };
              case "Point":
                  e = o(t.coordinates);
                  break;
              case "MultiPoint":
                  e = t.coordinates.map(o);
                  break;
              case "LineString":
                  e = i(t.arcs);
                  break;
              case "MultiLineString":
                  e = t.arcs.map(i);
                  break;
              case "Polygon":
                  e = s(t.arcs);
                  break;
              case "MultiPolygon":
                  e = t.arcs.map(s);
                  break;
              default:
                  return null
          }
          return {
              type: n,
              coordinates: e
          }
      }
      var l = C(t.transform),
          c = t.arcs;
      return a(e)
  }

  function o(t, e, n) {
      var o, r, s;
      if (arguments.length > 1) o = i(t, e, n);
      else
          for (r = 0, o = new Array(s = t.arcs.length); r < s; ++r) o[r] = r;
      return {
          type: "MultiLineString",
          arcs: A(t, o)
      }
  }

  function i(t, e, n) {
      function o(t) {
          var e = t < 0 ? ~t : t;
          (u[e] || (u[e] = [])).push({
              i: t,
              g: l
          })
      }

      function i(t) {
          t.forEach(o)
      }

      function r(t) {
          t.forEach(i)
      }

      function s(t) {
          t.forEach(r)
      }

      function a(t) {
          switch (l = t, t.type) {
              case "GeometryCollection":
                  t.geometries.forEach(a);
                  break;
              case "LineString":
                  i(t.arcs);
                  break;
              case "MultiLineString":
              case "Polygon":
                  r(t.arcs);
                  break;
              case "MultiPolygon":
                  s(t.arcs)
          }
      }
      var l, c = [],
          u = [];
      return a(e), u.forEach(null == n ? function(t) {
          c.push(t[0].i)
      } : function(t) {
          n(t[0].g, t[t.length - 1].g) && c.push(t[0].i)
      }), c
  }

  function r(t) {
      for (var e, n = -1, o = t.length, i = t[o - 1], r = 0; ++n < o;) e = i, i = t[n], r += e[0] * i[1] - e[1] * i[0];
      return Math.abs(r)
  }

  function s(t, e) {
      function o(t) {
          switch (t.type) {
              case "GeometryCollection":
                  t.geometries.forEach(o);
                  break;
              case "Polygon":
                  i(t.arcs);
                  break;
              case "MultiPolygon":
                  t.arcs.forEach(i)
          }
      }

      function i(t) {
          t.forEach(function(e) {
              e.forEach(function(e) {
                  (a[e = e < 0 ? ~e : e] || (a[e] = [])).push(t)
              })
          }), l.push(t)
      }

      function s(e) {
          return r(n(t, {
              type: "Polygon",
              arcs: [e]
          }).coordinates[0])
      }
      var a = {},
          l = [],
          c = [];
      return e.forEach(o), l.forEach(function(t) {
          if (!t._) {
              var e = [],
                  n = [t];
              for (t._ = 1, c.push(e); t = n.pop();) e.push(t), t.forEach(function(t) {
                  t.forEach(function(t) {
                      a[t < 0 ? ~t : t].forEach(function(t) {
                          t._ || (t._ = 1, n.push(t))
                      })
                  })
              })
          }
      }), l.forEach(function(t) {
          delete t._
      }), {
          type: "MultiPolygon",
          arcs: c.map(function(e) {
              var n, o = [];
              if (e.forEach(function(t) {
                      t.forEach(function(t) {
                          t.forEach(function(t) {
                              a[t < 0 ? ~t : t].length < 2 && o.push(t)
                          })
                      })
                  }), (n = (o = A(t, o)).length) > 1)
                  for (var i, r, l = 1, c = s(o[0]); l < n; ++l)(i = s(o[l])) > c && (r = o[0], o[0] = o[l], o[l] = r, c = i);
              return o
          })
      }
  }

  function a(t, e, n, o) {
      l(t, e, n), l(t, e, e + o), l(t, e + o, n)
  }

  function l(t, e, n) {
      for (var o, i = e + (n-- - e >> 1); e < i; ++e, --n) o = t[e], t[e] = t[n], t[n] = o
  }

  function c(t) {
      return null == t ? {
          type: null
      } : ("FeatureCollection" === t.type ? u : "Feature" === t.type ? f : h)(t)
  }

  function u(t) {
      var e = {
          type: "GeometryCollection",
          geometries: t.features.map(f)
      };
      return null != t.bbox && (e.bbox = t.bbox), e
  }

  function f(t) {
      var e, n = h(t.geometry);
      for (e in null != t.id && (n.id = t.id), null != t.bbox && (n.bbox = t.bbox), t.properties) {
          n.properties = t.properties;
          break
      }
      return n
  }

  function h(t) {
      if (null == t) return {
          type: null
      };
      var e = "GeometryCollection" === t.type ? {
          type: "GeometryCollection",
          geometries: t.geometries.map(h)
      } : "Point" === t.type || "MultiPoint" === t.type ? {
          type: t.type,
          coordinates: t.coordinates
      } : {
          type: t.type,
          arcs: t.coordinates
      };
      return null != t.bbox && (e.bbox = t.bbox), e
  }

  function p(t) {
      var e, n = t[0],
          o = t[1];
      return o < n && (e = n, n = o, o = e), n + 31 * o
  }

  function d(t, e) {
      var n, o = t[0],
          i = t[1],
          r = e[0],
          s = e[1];
      return i < o && (n = o, o = i, i = n), s < r && (n = r, r = s, s = n), o === r && i === s
  }

  function g() {
      return !0
  }

  function v(t) {
      return t
  }

  function y(t) {
      return null != t.type
  }

  function m(t) {
      var e = t[0],
          n = t[1],
          o = t[2];
      return Math.abs((e[0] - o[0]) * (n[1] - e[1]) - (e[0] - n[0]) * (o[1] - e[1])) / 2
  }

  function _(t) {
      for (var e, n = -1, o = t.length, i = t[o - 1], r = 0; ++n < o;) e = i, i = t[n], r += e[0] * i[1] - e[1] * i[0];
      return Math.abs(r) / 2
  }

  function x(t, e) {
      return t[1][2] - e[1][2]
  }

  function b(t) {
      return [t[0], t[1], 0]
  }

  function M(t, e) {
      if (n = t.length) {
          if ((e = +e) <= 0 || n < 2) return t[0];
          if (e >= 1) return t[n - 1];
          var n, o = (n - 1) * e,
              i = Math.floor(o),
              r = t[i];
          return r + (t[i + 1] - r) * (o - i)
      }
  }

  function B(t, e) {
      return e - t
  }

  function L(t, e) {
      for (var n, o, i = 0, r = t.length, s = 0, a = t[e ? i++ : r - 1], l = a[0] * ht, c = a[1] * ht / 2 + ft, u = gt(c), f = vt(c); i < r; ++i) {
          n = l, l = (a = t[i])[0] * ht, c = a[1] * ht / 2 + ft, o = u, u = gt(c);
          var h = l - n,
              p = h >= 0 ? 1 : -1,
              d = p * h,
              g = f * (f = vt(c)),
              v = o * u + g * gt(d),
              y = g * p * vt(d);
          s += dt(y, v)
      }
      return s
  }

  function I(t, e) {
      var n = L(t, !0);
      return e && (n *= -1), 2 * (n < 0 ? ut + n : n)
  }

  function w(t) {
      return 2 * pt(L(t, !1))
  }
  var P = function(t) {
          return t
      },
      C = function(t) {
          if (null == t) return P;
          var e, n, o = t.scale[0],
              i = t.scale[1],
              r = t.translate[0],
              s = t.translate[1];
          return function(t, a) {
              a || (e = n = 0);
              var l = 2,
                  c = t.length,
                  u = new Array(c);
              for (u[0] = (e += t[0]) * o + r, u[1] = (n += t[1]) * i + s; l < c;) u[l] = t[l], ++l;
              return u
          }
      },
      E = function(t) {
          function e(t) {
              (t = i(t))[0] < r && (r = t[0]), t[0] > a && (a = t[0]), t[1] < s && (s = t[1]), t[1] > l && (l = t[1])
          }

          function n(t) {
              switch (t.type) {
                  case "GeometryCollection":
                      t.geometries.forEach(n);
                      break;
                  case "Point":
                      e(t.coordinates);
                      break;
                  case "MultiPoint":
                      t.coordinates.forEach(e)
              }
          }
          var o, i = C(t.transform),
              r = Infinity,
              s = r,
              a = -r,
              l = -r;
          for (o in t.arcs.forEach(function(t) {
                  for (var e, n = -1, o = t.length; ++n < o;)(e = i(t[n], n))[0] < r && (r = e[0]), e[0] > a && (a = e[0]), e[1] < s && (s = e[1]), e[1] > l && (l = e[1])
              }), t.objects) n(t.objects[o]);
          return [r, s, a, l]
      },
      k = function(t, e) {
          for (var n, o = t.length, i = o - e; i < --o;) n = t[i], t[i++] = t[o], t[o] = n
      },
      S = function(t, n) {
          return "GeometryCollection" === n.type ? {
              type: "FeatureCollection",
              features: n.geometries.map(function(n) {
                  return e(t, n)
              })
          } : e(t, n)
      },
      A = function(t, e) {
          function n(e) {
              var n, o = t.arcs[e < 0 ? ~e : e],
                  i = o[0];
              return t.transform ? (n = [0, 0], o.forEach(function(t) {
                  n[0] += t[0], n[1] += t[1]
              })) : n = o[o.length - 1], e < 0 ? [n, i] : [i, n]
          }

          function o(t, e) {
              for (var n in t) {
                  var o = t[n];
                  delete e[o.start], delete o.start, delete o.end, o.forEach(function(t) {
                      i[t < 0 ? ~t : t] = 1
                  }), a.push(o)
              }
          }
          var i = {},
              r = {},
              s = {},
              a = [],
              l = -1;
          return e.forEach(function(n, o) {
              var i, r = t.arcs[n < 0 ? ~n : n];
              r.length < 3 && !r[1][0] && !r[1][1] && (i = e[++l], e[l] = n, e[o] = i)
          }), e.forEach(function(t) {
              var e, o, i = n(t),
                  a = i[0],
                  l = i[1];
              if (e = s[a])
                  if (delete s[e.end], e.push(t), e.end = l, o = r[l]) {
                      delete r[o.start];
                      var c = o === e ? e : e.concat(o);
                      r[c.start = e.start] = s[c.end = o.end] = c
                  } else r[e.start] = s[e.end] = e;
              else if (e = r[l])
                  if (delete r[e.start], e.unshift(t), e.start = a, o = s[a]) {
                      delete s[o.end];
                      var u = o === e ? e : o.concat(e);
                      r[u.start = o.start] = s[u.end = e.end] = u
                  } else r[e.start] = s[e.end] = e;
              else r[(e = [t]).start = a] = s[e.end = l] = e
          }), o(s, r), o(r, s), e.forEach(function(t) {
              i[t < 0 ? ~t : t] || a.push([t])
          }), a
      },
      O = function(t) {
          return n(t, o.apply(this, arguments))
      },
      W = function(t) {
          return n(t, s.apply(this, arguments))
      },
      j = function(t, e) {
          for (var n = 0, o = t.length; n < o;) {
              var i = n + o >>> 1;
              t[i] < e ? n = i + 1 : o = i
          }
          return n
      },
      H = function(t) {
          function e(t, e) {
              t.forEach(function(t) {
                  t < 0 && (t = ~t);
                  var n = i[t];
                  n ? n.push(e) : i[t] = [e]
              })
          }

          function n(t, n) {
              t.forEach(function(t) {
                  e(t, n)
              })
          }

          function o(t, e) {
              "GeometryCollection" === t.type ? t.geometries.forEach(function(t) {
                  o(t, e)
              }) : t.type in s && s[t.type](t.arcs, e)
          }
          var i = {},
              r = t.map(function() {
                  return []
              }),
              s = {
                  LineString: e,
                  MultiLineString: n,
                  Polygon: n,
                  MultiPolygon: function(t, e) {
                      t.forEach(function(t) {
                          n(t, e)
                      })
                  }
              };
          for (var a in t.forEach(o), i)
              for (var l = i[a], c = l.length, u = 0; u < c; ++u)
                  for (var f = u + 1; f < c; ++f) {
                      var h, p = l[u],
                          d = l[f];
                      (h = r[p])[a = j(h, d)] !== d && h.splice(a, 0, d), (h = r[d])[a = j(h, p)] !== p && h.splice(a, 0, p)
                  }
          return r
      },
      T = function(t) {
          if (null == t) return P;
          var e, n, o = t.scale[0],
              i = t.scale[1],
              r = t.translate[0],
              s = t.translate[1];
          return function(t, a) {
              a || (e = n = 0);
              var l = 2,
                  c = t.length,
                  u = new Array(c),
                  f = Math.round((t[0] - r) / o),
                  h = Math.round((t[1] - s) / i);
              for (u[0] = f - e, e = f, u[1] = h - n, n = h; l < c;) u[l] = t[l], ++l;
              return u
          }
      },
      G = function(t, e) {
          function n(t) {
              return h(t)
          }

          function o(t) {
              var e;
              switch (t.type) {
                  case "GeometryCollection":
                      e = {
                          type: "GeometryCollection",
                          geometries: t.geometries.map(o)
                      };
                      break;
                  case "Point":
                      e = {
                          type: "Point",
                          coordinates: n(t.coordinates)
                      };
                      break;
                  case "MultiPoint":
                      e = {
                          type: "MultiPoint",
                          coordinates: t.coordinates.map(n)
                      };
                      break;
                  default:
                      return t
              }
              return null != t.id && (e.id = t.id), null != t.bbox && (e.bbox = t.bbox), null != t.properties && (e.properties = t.properties), e
          }

          function i(t) {
              var e, n = 0,
                  o = 1,
                  i = t.length,
                  r = new Array(i);
              for (r[0] = h(t[0], 0); ++n < i;)((e = h(t[n], n))[0] || e[1]) && (r[o++] = e);
              return 1 === o && (r[o++] = [0, 0]), r.length = o, r
          }
          if (t.transform) throw new Error("already quantized");
          if (e && e.scale) u = t.bbox;
          else {
              if (!((r = Math.floor(e)) >= 2)) throw new Error("n must be \u22652");
              var r, s = (u = t.bbox || E(t))[0],
                  a = u[1],
                  l = u[2],
                  c = u[3];
              e = {
                  scale: [l - s ? (l - s) / (r - 1) : 1, c - a ? (c - a) / (r - 1) : 1],
                  translate: [s, a]
              }
          }
          var u, f, h = T(e),
              p = t.objects,
              d = {};
          for (f in p) d[f] = o(p[f]);
          return {
              type: "Topology",
              bbox: u,
              transform: e,
              objects: d,
              arcs: t.arcs.map(i)
          }
      },
      z = function(t) {
          function e(t) {
              null != t && c.hasOwnProperty(t.type) && c[t.type](t)
          }

          function n(t) {
              var e = t[0],
                  n = t[1];
              e < r && (r = e), e > a && (a = e), n < s && (s = n), n > l && (l = n)
          }

          function o(t) {
              t.forEach(n)
          }

          function i(t) {
              t.forEach(o)
          }
          var r = Infinity,
              s = Infinity,
              a = -Infinity,
              l = -Infinity,
              c = {
                  GeometryCollection: function(t) {
                      t.geometries.forEach(e)
                  },
                  Point: function(t) {
                      n(t.coordinates)
                  },
                  MultiPoint: function(t) {
                      t.coordinates.forEach(n)
                  },
                  LineString: function(t) {
                      o(t.arcs)
                  },
                  MultiLineString: function(t) {
                      t.arcs.forEach(o)
                  },
                  Polygon: function(t) {
                      t.arcs.forEach(o)
                  },
                  MultiPolygon: function(t) {
                      t.arcs.forEach(i)
                  }
              };
          for (var u in t) e(t[u]);
          return a >= r && l >= s ? [r, s, a, l] : undefined
      },
      F = function(t, e, n, o, i) {
          function r(o) {
              for (var r = e(o) & c, s = l[r], a = 0; s != i;) {
                  if (n(s, o)) return !0;
                  if (++a >= t) throw new Error("full hashset");
                  s = l[r = r + 1 & c]
              }
              return l[r] = o, !0
          }

          function s(o) {
              for (var r = e(o) & c, s = l[r], a = 0; s != i;) {
                  if (n(s, o)) return !0;
                  if (++a >= t) break;
                  s = l[r = r + 1 & c]
              }
              return !1
          }

          function a() {
              for (var t = [], e = 0, n = l.length; e < n; ++e) {
                  var o = l[e];
                  o != i && t.push(o)
              }
              return t
          }
          3 === arguments.length && (o = Array, i = null);
          for (var l = new o(t = 1 << Math.max(4, Math.ceil(Math.log(t) / Math.LN2))), c = t - 1, u = 0; u < t; ++u) l[u] = i;
          return {
              add: r,
              has: s,
              values: a
          }
      },
      $ = function(t, e, n, o, i, r) {
          function s(o, r) {
              for (var s = e(o) & h, a = u[s], l = 0; a != i;) {
                  if (n(a, o)) return f[s] = r;
                  if (++l >= t) throw new Error("full hashmap");
                  a = u[s = s + 1 & h]
              }
              return u[s] = o, f[s] = r, r
          }

          function a(o, r) {
              for (var s = e(o) & h, a = u[s], l = 0; a != i;) {
                  if (n(a, o)) return f[s];
                  if (++l >= t) throw new Error("full hashmap");
                  a = u[s = s + 1 & h]
              }
              return u[s] = o, f[s] = r, r
          }

          function l(o, r) {
              for (var s = e(o) & h, a = u[s], l = 0; a != i;) {
                  if (n(a, o)) return f[s];
                  if (++l >= t) break;
                  a = u[s = s + 1 & h]
              }
              return r
          }

          function c() {
              for (var t = [], e = 0, n = u.length; e < n; ++e) {
                  var o = u[e];
                  o != i && t.push(o)
              }
              return t
          }
          3 === arguments.length && (o = r = Array, i = null);
          for (var u = new o(t = 1 << Math.max(4, Math.ceil(Math.log(t) / Math.LN2))), f = new r(t), h = t - 1, p = 0; p < t; ++p) u[p] = i;
          return {
              set: s,
              maybeSet: a,
              get: l,
              keys: c
          }
      },
      D = function(t, e) {
          return t[0] === e[0] && t[1] === e[1]
      },
      R = new ArrayBuffer(16),
      V = new Uint32Array(R),
      U = function() {
          var t = V[0] ^ V[1];
          return 2147483647 & (t = t << 5 ^ t >> 7 ^ V[2] ^ V[3])
      },
      N = function(t) {
          function e(t, e, n, o) {
              if (p[n] !== t) {
                  p[n] = t;
                  var i = d[n];
                  if (i >= 0) {
                      var r = g[n];
                      i === e && r === o || i === o && r === e || (++y, v[n] = 1)
                  } else d[n] = e, g[n] = o
              }
          }

          function n() {
              for (var t = $(1.4 * c.length, o, i, Int32Array, -1, Int32Array), e = new Int32Array(c.length), n = 0, r = c.length; n < r; ++n) e[n] = t.maybeSet(n, n);
              return e
          }

          function o(t) {
              return U(c[t])
          }

          function i(t, e) {
              return D(c[t], c[e])
          }
          var r, s, a, l, c = t.coordinates,
              u = t.lines,
              f = t.rings,
              h = n(),
              p = new Int32Array(c.length),
              d = new Int32Array(c.length),
              g = new Int32Array(c.length),
              v = new Int8Array(c.length),
              y = 0;
          for (r = 0, s = c.length; r < s; ++r) p[r] = d[r] = g[r] = -1;
          for (r = 0, s = u.length; r < s; ++r) {
              var m = u[r],
                  _ = m[0],
                  x = m[1];
              for (a = h[_], l = h[++_], ++y, v[a] = 1; ++_ <= x;) e(r, a, a = l, l = h[_]);
              ++y, v[l] = 1
          }
          for (r = 0, s = c.length; r < s; ++r) p[r] = -1;
          for (r = 0, s = f.length; r < s; ++r) {
              var b = f[r],
                  M = b[0] + 1,
                  B = b[1];
              for (e(r, h[B - 1], a = h[M - 1], l = h[M]); ++M <= B;) e(r, a, a = l, l = h[M])
          }
          p = d = g = null;
          var L, I = F(1.4 * y, U, D);
          for (r = 0, s = c.length; r < s; ++r) v[L = h[r]] && I.add(c[L]);
          return I
      },
      J = function(t) {
          var e, n, o, i = N(t),
              r = t.coordinates,
              s = t.lines,
              l = t.rings;
          for (n = 0, o = s.length; n < o; ++n)
              for (var c = s[n], u = c[0], f = c[1]; ++u < f;) i.has(r[u]) && (e = {
                  0: u,
                  1: c[1]
              }, c[1] = u, c = c.next = e);
          for (n = 0, o = l.length; n < o; ++n)
              for (var h = l[n], p = h[0], d = p, g = h[1], v = i.has(r[p]); ++d < g;) i.has(r[d]) && (v ? (e = {
                  0: d,
                  1: h[1]
              }, h[1] = d, h = h.next = e) : (a(r, p, g, g - d), r[g] = r[p], v = !0, d = p));
          return t
      },
      Z = function(t) {
          function e(t) {
              var e, n, r, s, a, l, c, u;
              if (r = v.get(e = h[t[0]]))
                  for (c = 0, u = r.length; c < u; ++c)
                      if (o(s = r[c], t)) return t[0] = s[0], void(t[1] = s[1]);
              if (a = v.get(n = h[t[1]]))
                  for (c = 0, u = a.length; c < u; ++c)
                      if (i(l = a[c], t)) return t[1] = l[0], void(t[0] = l[1]);
              r ? r.push(t) : v.set(e, [t]), a ? a.push(t) : v.set(n, [t]), y.push(t)
          }

          function n(t) {
              var e, n, o, i, l;
              if (n = v.get(e = h[t[0]]))
                  for (i = 0, l = n.length; i < l; ++i) {
                      if (r(o = n[i], t)) return t[0] = o[0], void(t[1] = o[1]);
                      if (s(o, t)) return t[0] = o[1], void(t[1] = o[0])
                  }
              if (n = v.get(e = h[t[0] + a(t)]))
                  for (i = 0, l = n.length; i < l; ++i) {
                      if (r(o = n[i], t)) return t[0] = o[0], void(t[1] = o[1]);
                      if (s(o, t)) return t[0] = o[1], void(t[1] = o[0])
                  }
              n ? n.push(t) : v.set(e, [t]), y.push(t)
          }

          function o(t, e) {
              var n = t[0],
                  o = e[0],
                  i = t[1];
              if (n - i != o - e[1]) return !1;
              for (; n <= i; ++n, ++o)
                  if (!D(h[n], h[o])) return !1;
              return !0
          }

          function i(t, e) {
              var n = t[0],
                  o = e[0],
                  i = t[1],
                  r = e[1];
              if (n - i != o - r) return !1;
              for (; n <= i; ++n, --r)
                  if (!D(h[n], h[r])) return !1;
              return !0
          }

          function r(t, e) {
              var n = t[0],
                  o = e[0],
                  i = t[1] - n;
              if (i !== e[1] - o) return !1;
              for (var r = a(t), s = a(e), l = 0; l < i; ++l)
                  if (!D(h[n + (l + r) % i], h[o + (l + s) % i])) return !1;
              return !0
          }

          function s(t, e) {
              var n = t[0],
                  o = e[0],
                  i = t[1],
                  r = e[1],
                  s = i - n;
              if (s !== r - o) return !1;
              for (var l = a(t), c = s - a(e), u = 0; u < s; ++u)
                  if (!D(h[n + (u + l) % s], h[r - (u + c) % s])) return !1;
              return !0
          }

          function a(t) {
              for (var e = t[0], n = t[1], o = e, i = o, r = h[o]; ++o < n;) {
                  var s = h[o];
                  (s[0] < r[0] || s[0] === r[0] && s[1] < r[1]) && (i = o, r = s)
              }
              return i - e
          }
          var l, c, u, f, h = t.coordinates,
              p = t.lines,
              d = t.rings,
              g = p.length + d.length;
          for (delete t.lines, delete t.rings, u = 0, f = p.length; u < f; ++u)
              for (l = p[u]; l = l.next;) ++g;
          for (u = 0, f = d.length; u < f; ++u)
              for (c = d[u]; c = c.next;) ++g;
          var v = $(2 * g * 1.4, U, D),
              y = t.arcs = [];
          for (u = 0, f = p.length; u < f; ++u) {
              l = p[u];
              do {
                  e(l)
              } while (l = l.next)
          }
          for (u = 0, f = d.length; u < f; ++u)
              if ((c = d[u]).next) {
                  do {
                      e(c)
                  } while (c = c.next)
              } else n(c);
          return t
      },
      q = function(t) {
          for (var e = -1, n = t.length; ++e < n;) {
              for (var o, i, r = t[e], s = 0, a = 1, l = r.length, c = r[0], u = c[0], f = c[1]; ++s < l;) o = (c = r[s])[0], i = c[1], o === u && i === f || (r[a++] = [o - u, i - f], u = o, f = i);
              1 === a && (r[a++] = [0, 0]), r.length = a
          }
          return t
      },
      Q = function(t) {
          function e(t) {
              t && c.hasOwnProperty(t.type) && c[t.type](t)
          }

          function n(t) {
              for (var e = 0, n = t.length; e < n; ++e) l[++r] = t[e];
              var o = {
                  0: r - n + 1,
                  1: r
              };
              return s.push(o), o
          }

          function o(t) {
              for (var e = 0, n = t.length; e < n; ++e) l[++r] = t[e];
              var o = {
                  0: r - n + 1,
                  1: r
              };
              return a.push(o), o
          }

          function i(t) {
              return t.map(o)
          }
          var r = -1,
              s = [],
              a = [],
              l = [],
              c = {
                  GeometryCollection: function(t) {
                      t.geometries.forEach(e)
                  },
                  LineString: function(t) {
                      t.arcs = n(t.arcs)
                  },
                  MultiLineString: function(t) {
                      t.arcs = t.arcs.map(n)
                  },
                  Polygon: function(t) {
                      t.arcs = t.arcs.map(o)
                  },
                  MultiPolygon: function(t) {
                      t.arcs = t.arcs.map(i)
                  }
              };
          for (var u in t) e(t[u]);
          return {
              type: "Topology",
              coordinates: l,
              lines: s,
              rings: a,
              objects: t
          }
      },
      X = function(t) {
          var e, n = {};
          for (e in t) n[e] = c(t[e]);
          return n
      },
      K = function(t, e, n) {
          function o(t) {
              return [Math.round((t[0] - c) * p), Math.round((t[1] - u) * d)]
          }

          function i(t, e) {
              for (var n, o, i, r, s, a = -1, l = 0, f = t.length, h = new Array(f); ++a < f;) n = t[a], r = Math.round((n[0] - c) * p), s = Math.round((n[1] - u) * d), r === o && s === i || (h[l++] = [o = r, i = s]);
              for (h.length = l; l < e;) l = h.push([h[0][0], h[0][1]]);
              return h
          }

          function r(t) {
              return i(t, 2)
          }

          function s(t) {
              return i(t, 4)
          }

          function a(t) {
              return t.map(s)
          }

          function l(t) {
              null != t && g.hasOwnProperty(t.type) && g[t.type](t)
          }
          var c = e[0],
              u = e[1],
              f = e[2],
              h = e[3],
              p = f - c ? (n - 1) / (f - c) : 1,
              d = h - u ? (n - 1) / (h - u) : 1,
              g = {
                  GeometryCollection: function(t) {
                      t.geometries.forEach(l)
                  },
                  Point: function(t) {
                      t.coordinates = o(t.coordinates)
                  },
                  MultiPoint: function(t) {
                      t.coordinates = t.coordinates.map(o)
                  },
                  LineString: function(t) {
                      t.arcs = r(t.arcs)
                  },
                  MultiLineString: function(t) {
                      t.arcs = t.arcs.map(r)
                  },
                  Polygon: function(t) {
                      t.arcs = a(t.arcs)
                  },
                  MultiPolygon: function(t) {
                      t.arcs = t.arcs.map(a)
                  }
              };
          for (var v in t) l(t[v]);
          return {
              scale: [1 / p, 1 / d],
              translate: [c, u]
          }
      },
      Y = function(t, e) {
          function n(t) {
              t && u.hasOwnProperty(t.type) && u[t.type](t)
          }

          function o(t) {
              var e = [];
              do {
                  var n = c.get(t);
                  e.push(t[0] < t[1] ? n : ~n)
              } while (t = t.next);
              return e
          }

          function i(t) {
              return t.map(o)
          }
          var r = z(t = X(t)),
              s = e > 0 && r && K(t, r, e),
              a = Z(J(Q(t))),
              l = a.coordinates,
              c = $(1.4 * a.arcs.length, p, d);
          t = a.objects, a.bbox = r, a.arcs = a.arcs.map(function(t, e) {
              return c.set(t, e), l.slice(t[0], t[1] + 1)
          }), delete a.coordinates, l = null;
          var u = {
              GeometryCollection: function(t) {
                  t.geometries.forEach(n)
              },
              LineString: function(t) {
                  t.arcs = o(t.arcs)
              },
              MultiLineString: function(t) {
                  t.arcs = t.arcs.map(o)
              },
              Polygon: function(t) {
                  t.arcs = t.arcs.map(o)
              },
              MultiPolygon: function(t) {
                  t.arcs = t.arcs.map(i)
              }
          };
          for (var f in t) n(t[f]);
          return s && (a.transform = s, a.arcs = q(a.arcs)), a
      },
      tt = function(t) {
          function e(t) {
              switch (t.type) {
                  case "GeometryCollection":
                      t.geometries.forEach(e);
                      break;
                  case "LineString":
                      o(t.arcs);
                      break;
                  case "MultiLineString":
                  case "Polygon":
                      t.arcs.forEach(o);
                      break;
                  case "MultiPolygon":
                      t.arcs.forEach(i)
              }
          }

          function n(t) {
              t < 0 && (t = ~t), v[t] || (v[t] = 1, ++y)
          }

          function o(t) {
              t.forEach(n)
          }

          function i(t) {
              t.forEach(o)
          }

          function r(t) {
              var e;
              switch (t.type) {
                  case "GeometryCollection":
                      e = {
                          type: "GeometryCollection",
                          geometries: t.geometries.map(r)
                      };
                      break;
                  case "LineString":
                      e = {
                          type: "LineString",
                          arcs: a(t.arcs)
                      };
                      break;
                  case "MultiLineString":
                      e = {
                          type: "MultiLineString",
                          arcs: t.arcs.map(a)
                      };
                      break;
                  case "Polygon":
                      e = {
                          type: "Polygon",
                          arcs: t.arcs.map(a)
                      };
                      break;
                  case "MultiPolygon":
                      e = {
                          type: "MultiPolygon",
                          arcs: t.arcs.map(l)
                      };
                      break;
                  default:
                      return t
              }
              return null != t.id && (e.id = t.id), null != t.bbox && (e.bbox = t.bbox), null != t.properties && (e.properties = t.properties), e
          }

          function s(t) {
              return t < 0 ? ~v[~t] : v[t]
          }

          function a(t) {
              return t.map(s)
          }

          function l(t) {
              return t.map(a)
          }
          var c, u, f = t.objects,
              h = {},
              p = t.arcs,
              d = p.length,
              g = -1,
              v = new Array(d),
              y = 0,
              m = -1;
          for (u in f) e(f[u]);
          for (c = new Array(y); ++g < d;) v[g] && (v[g] = ++m, c[m] = p[g]);
          for (u in f) h[u] = r(f[u]);
          return {
              type: "Topology",
              bbox: t.bbox,
              transform: t.transform,
              objects: h,
              arcs: c
          }
      },
      et = function(t, e) {
          function n(t) {
              var e, i;
              switch (t.type) {
                  case "Polygon":
                      e = (i = o(t.arcs)) ? {
                          type: "Polygon",
                          arcs: i
                      } : {
                          type: null
                      };
                      break;
                  case "MultiPolygon":
                      e = (i = t.arcs.map(o).filter(v)).length ? {
                          type: "MultiPolygon",
                          arcs: i
                      } : {
                          type: null
                      };
                      break;
                  case "GeometryCollection":
                      e = (i = t.geometries.map(n).filter(y)).length ? {
                          type: "GeometryCollection",
                          geometries: i
                      } : {
                          type: null
                      };
                      break;
                  default:
                      return t
              }
              return null != t.id && (e.id = t.id), null != t.bbox && (e.bbox = t.bbox), null != t.properties && (e.properties = t.properties), e
          }

          function o(t) {
              return t.length && i(t[0]) ? [t[0]].concat(t.slice(1).filter(r)) : null
          }

          function i(t) {
              return e(t, !1)
          }

          function r(t) {
              return e(t, !0)
          }
          var s, a = t.objects,
              l = {};
          for (s in null == e && (e = g), a) l[s] = n(a[s]);
          return tt({
              type: "Topology",
              bbox: t.bbox,
              transform: t.transform,
              objects: l,
              arcs: t.arcs
          })
      },
      nt = function(t) {
          function e(t) {
              switch (t.type) {
                  case "GeometryCollection":
                      t.geometries.forEach(e);
                      break;
                  case "Polygon":
                      n(t.arcs);
                      break;
                  case "MultiPolygon":
                      t.arcs.forEach(n)
              }
          }

          function n(t) {
              for (var e = 0, n = t.length; e < n; ++e, ++r)
                  for (var o = t[e], s = 0, a = o.length; s < a; ++s) {
                      var l = o[s];
                      l < 0 && (l = ~l);
                      var c = i[l];
                      null == c ? i[l] = r : c !== r && (i[l] = -1)
                  }
          }
          var o, i = new Array(t.arcs.length),
              r = 0;
          for (o in t.objects) e(t.objects[o]);
          return function(t) {
              for (var e, n = 0, o = t.length; n < o; ++n)
                  if (-1 === i[(e = t[n]) < 0 ? ~e : e]) return !0;
              return !1
          }
      },
      ot = function(t, e, n) {
          return e = null == e ? Number.MIN_VALUE : +e, null == n && (n = _),
              function(o, i) {
                  return n(S(t, {
                      type: "Polygon",
                      arcs: [o]
                  }).geometry.coordinates[0], i) >= e
              }
      },
      it = function(t, e, n) {
          var o = nt(t),
              i = ot(t, e, n);
          return function(t, e) {
              return o(t, e) || i(t, e)
          }
      },
      rt = function() {
          function t(t, e) {
              for (; e > 0;) {
                  var n = (e + 1 >> 1) - 1,
                      i = o[n];
                  if (x(t, i) >= 0) break;
                  o[i._ = e] = i, o[t._ = e = n] = t
              }
          }

          function e(t, e) {
              for (;;) {
                  var n = e + 1 << 1,
                      r = n - 1,
                      s = e,
                      a = o[s];
                  if (r < i && x(o[r], a) < 0 && (a = o[s = r]), n < i && x(o[n], a) < 0 && (a = o[s = n]), s === e) break;
                  o[a._ = e] = a, o[t._ = e = s] = t
              }
          }
          var n = {},
              o = [],
              i = 0;
          return n.push = function(e) {
              return t(o[e._ = i] = e, i++), i
          }, n.pop = function() {
              if (!(i <= 0)) {
                  var t, n = o[0];
                  return --i > 0 && (t = o[i], e(o[t._ = 0] = t, 0)), n
              }
          }, n.remove = function(n) {
              var r, s = n._;
              if (o[s] === n) return s !== --i && (x(r = o[i], n) < 0 ? t : e)(o[r._ = s] = r, s), s
          }, n
      },
      st = function(t, e) {
          function n(t) {
              i.remove(t), t[1][2] = e(t), i.push(t)
          }
          var o = t.transform ? C(t.transform) : b,
              i = rt();
          null == e && (e = m);
          var r = t.arcs.map(function(t) {
              var r, s, a, l = [],
                  c = 0;
              for (s = 1, a = (t = t.map(o)).length - 1; s < a; ++s)(r = [t[s - 1], t[s], t[s + 1]])[1][2] = e(r), l.push(r), i.push(r);
              for (t[0][2] = t[a][2] = Infinity, s = 0, a = l.length; s < a; ++s)(r = l[s]).previous = l[s - 1], r.next = l[s + 1];
              for (; r = i.pop();) {
                  var u = r.previous,
                      f = r.next;
                  r[1][2] < c ? r[1][2] = c : c = r[1][2], u && (u.next = f, u[2] = r[2], n(u)), f && (f.previous = u, f[0] = r[0], n(f))
              }
              return t
          });
          return {
              type: "Topology",
              bbox: t.bbox,
              objects: t.objects,
              arcs: r
          }
      },
      at = function(t, e) {
          var n = [];
          return t.arcs.forEach(function(t) {
              t.forEach(function(t) {
                  isFinite(t[2]) && n.push(t[2])
              })
          }), n.length && M(n.sort(B), e)
      },
      lt = function(t, e) {
          e = null == e ? Number.MIN_VALUE : +e;
          var n = t.arcs.map(function(t) {
              for (var n, o = -1, i = 0, r = t.length, s = new Array(r); ++o < r;)(n = t[o])[2] >= e && (s[i++] = [n[0], n[1]]);
              return s.length = i, s
          });
          return {
              type: "Topology",
              transform: t.transform,
              bbox: t.bbox,
              objects: t.objects,
              arcs: n
          }
      },
      ct = Math.PI,
      ut = 2 * ct,
      ft = ct / 4,
      ht = ct / 180,
      pt = Math.abs,
      dt = Math.atan2,
      gt = Math.cos,
      vt = Math.sin;
  t.bbox = E, t.feature = S, t.mesh = O, t.meshArcs = o, t.merge = W, t.mergeArcs = s, t.neighbors = H, t.quantize = G, t.transform = C, t.untransform = T, t.topology = Y, t.filter = et, t.filterAttached = nt, t.filterAttachedWeight = it, t.filterWeight = ot, t.planarRingArea = _, t.planarTriangleArea = m, t.presimplify = st, t.quantile = at, t.simplify = lt, t.sphericalRingArea = I, t.sphericalTriangleArea = w, Object.defineProperty(t, "__esModule", {
      value: !0
  })
}), InfoBox.prototype = new google.maps.OverlayView, InfoBox.prototype.createInfoBoxDiv_ = function() {
  var t, e, n, o = this,
      i = function(t) {
          t.cancelBubble = !0, t.stopPropagation && t.stopPropagation()
      },
      r = function(t) {
          t.returnValue = !1, t.preventDefault && t.preventDefault(), o.enableEventPropagation_ || i(t)
      };
  if (!this.div_) {
      if (this.div_ = document.createElement("div"), this.setBoxStyle_(), "undefined" == typeof this.content_.nodeType ? this.div_.innerHTML = this.getCloseBoxImg_() + this.content_ : (this.div_.innerHTML = this.getCloseBoxImg_(), this.div_.appendChild(this.content_)), this.getPanes()[this.pane_].appendChild(this.div_), this.addClickHandler_(), this.div_.style.width ? this.fixedWidthSet_ = !0 : 0 !== this.maxWidth_ && this.div_.offsetWidth > this.maxWidth_ ? (this.div_.style.width = this.maxWidth_, this.div_.style.overflow = "auto", this.fixedWidthSet_ = !0) : (n = this.getBoxWidths_(), this.div_.style.width = this.div_.offsetWidth - n.left - n.right + "px", this.fixedWidthSet_ = !1), this.panBox_(this.disableAutoPan_), !this.enableEventPropagation_) {
          for (this.eventListeners_ = [], e = ["mousedown", "mouseover", "mouseout", "mouseup", "click", "dblclick", "touchstart", "touchend", "touchmove"], t = 0; t < e.length; t++) this.eventListeners_.push(google.maps.event.addDomListener(this.div_, e[t], i));
          this.eventListeners_.push(google.maps.event.addDomListener(this.div_, "mouseover", function() {
              this.style.cursor = "default"
          }))
      }
      this.contextListener_ = google.maps.event.addDomListener(this.div_, "contextmenu", r), google.maps.event.trigger(this, "domready")
  }
}, InfoBox.prototype.getCloseBoxImg_ = function() {
  var t = "";
  return "" !== this.closeBoxURL_ && (t = "<img", t += " src='" + this.closeBoxURL_ + "'", t += " align=right", t += " style='", t += " position: relative;", t += " cursor: pointer;", t += " margin: " + this.closeBoxMargin_ + ";", t += "'>"), t
}, InfoBox.prototype.addClickHandler_ = function() {
  var t;
  "" !== this.closeBoxURL_ ? (t = this.div_.firstChild, this.closeListener_ = google.maps.event.addDomListener(t, "click", this.getCloseClickHandler_())) : this.closeListener_ = null
}, InfoBox.prototype.getCloseClickHandler_ = function() {
  var t = this;
  return function(e) {
      e.cancelBubble = !0, e.stopPropagation && e.stopPropagation(), google.maps.event.trigger(t, "closeclick"), t.close()
  }
}, InfoBox.prototype.panBox_ = function(t) {
  var e, n = 0,
      o = 0;
  if (!t && (e = this.getMap()) instanceof google.maps.Map) {
      e.getBounds().contains(this.position_) || e.setCenter(this.position_), e.getBounds();
      var i = e.getDiv(),
          r = i.offsetWidth,
          s = i.offsetHeight,
          a = this.pixelOffset_.width,
          l = this.pixelOffset_.height,
          c = this.div_.offsetWidth,
          u = this.div_.offsetHeight,
          f = this.infoBoxClearance_.width,
          h = this.infoBoxClearance_.height,
          p = this.getProjection().fromLatLngToContainerPixel(this.position_);
      if (p.x < -a + f ? n = p.x + a - f : p.x + c + a + f > r && (n = p.x + c + a + f - r), this.alignBottom_ ? p.y < -l + h + u ? o = p.y + l - h - u : p.y + l + h > s && (o = p.y + l + h - s) : p.y < -l + h ? o = p.y + l - h : p.y + u + l + h > s && (o = p.y + u + l + h - s), 0 !== n || 0 !== o) {
          e.getCenter();
          e.panBy(n, o)
      }
  }
}, InfoBox.prototype.setBoxStyle_ = function() {
  var t, e;
  if (this.div_) {
      for (t in this.div_.className = this.boxClass_, this.div_.style.cssText = "", e = this.boxStyle_) e.hasOwnProperty(t) && (this.div_.style[t] = e[t]);
      this.div_.style.WebkitTransform = "translateZ(0)", "undefined" != typeof this.div_.style.opacity && "" !== this.div_.style.opacity && (this.div_.style.MsFilter = '"progid:DXImageTransform.Microsoft.Alpha(Opacity=' + 100 * this.div_.style.opacity + ')"', this.div_.style.filter = "alpha(opacity=" + 100 * this.div_.style.opacity + ")"), this.div_.style.position = "absolute", this.div_.style.visibility = "hidden", null !== this.zIndex_ && (this.div_.style.zIndex = this.zIndex_)
  }
}, InfoBox.prototype.getBoxWidths_ = function() {
  var t, e = {
          top: 0,
          bottom: 0,
          left: 0,
          right: 0
      },
      n = this.div_;
  return document.defaultView && document.defaultView.getComputedStyle ? (t = n.ownerDocument.defaultView.getComputedStyle(n, "")) && (e.top = parseInt(t.borderTopWidth, 10) || 0, e.bottom = parseInt(t.borderBottomWidth, 10) || 0, e.left = parseInt(t.borderLeftWidth, 10) || 0, e.right = parseInt(t.borderRightWidth, 10) || 0) : document.documentElement.currentStyle && n.currentStyle && (e.top = parseInt(n.currentStyle.borderTopWidth, 10) || 0, e.bottom = parseInt(n.currentStyle.borderBottomWidth, 10) || 0, e.left = parseInt(n.currentStyle.borderLeftWidth, 10) || 0, e.right = parseInt(n.currentStyle.borderRightWidth, 10) || 0), e
}, InfoBox.prototype.onRemove = function() {
  this.div_ && (this.div_.parentNode.removeChild(this.div_), this.div_ = null)
}, InfoBox.prototype.draw = function() {
  this.createInfoBoxDiv_();
  var t = this.getProjection().fromLatLngToDivPixel(this.position_);
  this.div_.style.left = t.x + this.pixelOffset_.width + "px", this.alignBottom_ ? this.div_.style.bottom = -(t.y + this.pixelOffset_.height) + "px" : this.div_.style.top = t.y + this.pixelOffset_.height + "px", this.isHidden_ ? this.div_.style.visibility = "hidden" : this.div_.style.visibility = "visible"
}, InfoBox.prototype.setOptions = function(t) {
  "undefined" != typeof t.boxClass && (this.boxClass_ = t.boxClass, this.setBoxStyle_()), "undefined" != typeof t.boxStyle && (this.boxStyle_ = t.boxStyle, this.setBoxStyle_()), "undefined" != typeof t.content && this.setContent(t.content), "undefined" != typeof t.disableAutoPan && (this.disableAutoPan_ = t.disableAutoPan), "undefined" != typeof t.maxWidth && (this.maxWidth_ = t.maxWidth), "undefined" != typeof t.pixelOffset && (this.pixelOffset_ = t.pixelOffset), "undefined" != typeof t.alignBottom && (this.alignBottom_ = t.alignBottom), "undefined" != typeof t.position && this.setPosition(t.position), "undefined" != typeof t.zIndex && this.setZIndex(t.zIndex), "undefined" != typeof t.closeBoxMargin && (this.closeBoxMargin_ = t.closeBoxMargin), "undefined" != typeof t.closeBoxURL && (this.closeBoxURL_ = t.closeBoxURL), "undefined" != typeof t.infoBoxClearance && (this.infoBoxClearance_ = t.infoBoxClearance), "undefined" != typeof t.isHidden && (this.isHidden_ = t.isHidden), "undefined" != typeof t.visible && (this.isHidden_ = !t.visible), "undefined" != typeof t.enableEventPropagation && (this.enableEventPropagation_ = t.enableEventPropagation), this.div_ && this.draw()
}, InfoBox.prototype.setContent = function(t) {
  this.content_ = t, this.div_ && (this.closeListener_ && (google.maps.event.removeListener(this.closeListener_), this.closeListener_ = null), this.fixedWidthSet_ || (this.div_.style.width = ""), "undefined" == typeof t.nodeType ? this.div_.innerHTML = this.getCloseBoxImg_() + t : (this.div_.innerHTML = this.getCloseBoxImg_(), this.div_.appendChild(t)), this.fixedWidthSet_ || (this.div_.style.width = this.div_.offsetWidth + "px", "undefined" == typeof t.nodeType ? this.div_.innerHTML = this.getCloseBoxImg_() + t : (this.div_.innerHTML = this.getCloseBoxImg_(), this.div_.appendChild(t))), this.addClickHandler_()), google.maps.event.trigger(this, "content_changed")
}, InfoBox.prototype.setPosition = function(t) {
  this.position_ = t, this.div_ && this.draw(), google.maps.event.trigger(this, "position_changed")
}, InfoBox.prototype.setZIndex = function(t) {
  this.zIndex_ = t, this.div_ && (this.div_.style.zIndex = t), google.maps.event.trigger(this, "zindex_changed")
}, InfoBox.prototype.setVisible = function(t) {
  this.isHidden_ = !t, this.div_ && (this.div_.style.visibility = this.isHidden_ ? "hidden" : "visible")
}, InfoBox.prototype.getContent = function() {
  return this.content_
}, InfoBox.prototype.getPosition = function() {
  return this.position_
}, InfoBox.prototype.getZIndex = function() {
  return this.zIndex_
}, InfoBox.prototype.getVisible = function() {
  return void 0 !== this.getMap() && null !== this.getMap() && !this.isHidden_
}, InfoBox.prototype.show = function() {
  this.isHidden_ = !1, this.div_ && (this.div_.style.visibility = "visible")
}, InfoBox.prototype.hide = function() {
  this.isHidden_ = !0, this.div_ && (this.div_.style.visibility = "hidden")
}, InfoBox.prototype.open = function(t, e) {
  var n = this;
  e && (this.position_ = e.getPosition(), this.moveListener_ = google.maps.event.addListener(e, "position_changed", function() {
      n.setPosition(this.getPosition())
  })), this.setMap(t), this.div_ && this.panBox_()
}, InfoBox.prototype.close = function() {
  var t;
  if (this.closeListener_ && (google.maps.event.removeListener(this.closeListener_), this.closeListener_ = null), this.eventListeners_) {
      for (t = 0; t < this.eventListeners_.length; t++) google.maps.event.removeListener(this.eventListeners_[t]);
      this.eventListeners_ = null
  }
  this.moveListener_ && (google.maps.event.removeListener(this.moveListener_), this.moveListener_ = null), this.contextListener_ && (google.maps.event.removeListener(this.contextListener_), this.contextListener_ = null), this.setMap(null)
};
var map, IconContainerSettings = {
  height: 22,
  width: 22
};
CustomMarker.prototype = new google.maps.OverlayView, CustomMarker.prototype.draw = function() {
  var t = this,
      e = this.div;
  e || ((e = this.div = document.createElement("div")).className = "custom-marker", e.style.position = "absolute", e.style.cursor = "pointer", e.innerHTML = t.args.content, google.maps.event.addDomListener(e, "click", function() {
      google.maps.event.trigger(t, "click")
  }), this.getPanes().overlayImage.appendChild(e));
  var n = this.getProjection().fromLatLngToDivPixel(this.latlng);
  n && (e.style.left = n.x - IconContainerSettings.width / 2 + "px", e.style.top = n.y - IconContainerSettings.height + "px")
}, CustomMarker.prototype.remove = function() {
  this.div && (this.div.parentNode.removeChild(this.div), this.div = null)
}, CustomMarker.prototype.getPosition = function() {
  return this.latlng
};
var openedInfoBox = null,
  markers = [],
  Settings = {
      id: "map-canvas",
      zoom: 12
  },
  OrganisationMap = {
      initMap: function() {
          Settings.lat = parseFloat($("#marker_data").data().latitude || "51.5978"), Settings.lng = parseFloat($("#marker_data").data().longitude || "-0.3370"), map = new google.maps.Map(document.getElementById(Settings.id), {
              center: {
                  lat: Settings.lat,
                  lng: Settings.lng
              },
              zoom: Settings.zoom
          }), jQuery.getJSON("/assets/topo_E09000020.json", function(t) {
              geoJsonObject = topojson.feature(t, t.objects.E09000020), map.data.addGeoJson(geoJsonObject)
          });
          var t, e = $("#marker_data").data().markers,
              n = new InfoBox,
              o = {
                  pixelOffset: new google.maps.Size(-140, 10)
              },
              i = document.createElement("div");
          i.setAttribute("class", "arrow_box"), o.content = i, e.forEach(function(e) {
              var r = new google.maps.LatLng(e.lat, e.lng);
              t = new CustomMarker(r, map, {
                  content: e.custom_marker
              }), google.maps.event.addListener(t, "click", function() {
                  openedInfoBox = n, n.setOptions(o), i.innerHTML = e.infowindow, $(n.content_).find(".close").click(function() {
                      n.close(), openedInfoBox = null
                  }), n.open(map, this), map.panTo(n.getPosition())
              }), markers.push(t)
          })
      },
      centerMap: function(t) {
          map.setCenter({
              lat: t.lat,
              lng: t.lng
          })
      },
      closeInfoBox: function() {
          null !== openedInfoBox && openedInfoBox.close()
      },
      getVolOpCoordinates: function(t) {
          return {
              lat: parseFloat($(t).attr("data-lat")),
              lng: parseFloat($(t).attr("data-lng"))
          }
      },
      openInfoBox: function(t) {
          $.each(markers, function(e, n) {
              n.latlng.lat().toFixed(6) === t.lat.toFixed(6) && n.latlng.lng().toFixed(6) === t.lng.toFixed(6) && google.maps.event.trigger(n, "click")
          })
      },
      updateInfoBox: function(t) {
          if ("" !== $(t).attr("data-lat") && "" !== $(t).attr("data-lng")) {
              var e = this.getVolOpCoordinates(t);
              this.centerMap(e), this.openInfoBox(e)
          }
      },
      init: function() {
          $("#content").height() - 14 >= 400 && $("#map-canvas").height($("#content").height() - 14),
              $(".center-map-on-op").mouseenter(function() {
                  OrganisationMap.updateInfoBox(this)
              }).mouseleave(function() {
                  OrganisationMap.closeInfoBox()
              })
      }
  };
google.maps.event.addDomListener(window, "load", OrganisationMap.initMap);
var debouceOpenInfoBox = _.debounce(function(t) {
  "" !== $(t).attr("data-lat") && "" !== $(t).attr("data-lng") && (centerMap(getVolOpCoordinates(t)), openInfoBox(getVolOpCoordinates(t)))
}, 300);
$(document).ready(function() {
  OrganisationMap.init()
});