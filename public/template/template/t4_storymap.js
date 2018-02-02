/* global d3 */
/*eslint no-console: "error"*/
/*********************************************************************************************
                                       prepare
**********************************************************************************************/
  // polyfill
  if (!String.prototype.trim) {
    String.prototype.trim = function () {
      return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');
    };
  }

  var isMobile = function() { return /iPad|iPod|iPhone|Android/.test(navigator.userAgent) || document.location.hash == "#ipad"; }
  var isPhone = function() { return isMobile() && window.innerWidth < 768; }, w, h, scrollHeight;
  function w() {
    return window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
  }
  function h() {
    return window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight
  }

  // if device is portable we are adding ios class to html tag
  // so new classes with .ios .someclass path are used instead of basic ones
  if (isMobile()) { document.documentElement.className = document.documentElement.className + " ios mob";}

  // array of functions added throught page which should be called at the end of page parsing with "await"
  // function which is called at the bottom of the page
  (function() {
    var defers = [];
    defer = function(f) { defers.push(f); };
    await = function() { defers.forEach(function(f,s) { f();}); };
  })();

/*********************************************************************************************
                                       navigation
**********************************************************************************************/
  defer(function() {

    var track = {
        road_map: [0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3], // 0 none of the road; 1,2 road id; if 3 then both
        point_map: [0,1,2,3,4,5,6,1,2,3,4,5,6,7,8,9],
        titles: [],
        current_point: -1,
        points_length: 15,
        animating: false,
        queue: null,
        points: [{
          coordinates: [],
          coordinates_orig: [0, 278.062, 27.139, 272.889, 118.464, 75.662, 30.85, 12.638, 123.419, 13.499],
          // count: 0
        },
        {
          coordinates: [],
          coordinates_orig: [0, 260.572, 43.825, 8.486, 12.793, 9.277, 302.293, 176.969, 124.644, 15.189],
          // count: 0
        }],
        paths: [{
            index: 0,
            offset: 0,
            length: 0,
            orig_length: 952.617
          },
          {
            index: 0,
            offset: 0,
            length: 0,
            orig_length: 954.04
          }
        ],
        svg_overlay: undefined,
        el: {
          svg: undefined,
          roads: [],
          article: undefined
        },
        init: function (callback) {
          var t = this,
            obj = d3.select("#track")
            obj_overlay = d3.select("#track_overlay"),
            cnt = 0;

          function callback_onload() {
            t.el.svg = obj.node().contentDocument;
            t.svg_overlay = d3.select(obj_overlay.node().contentDocument.documentElement);

            t.el.roads = [
              t.el.svg.getElementsByClassName("road-1")[0],
              t.el.svg.getElementsByClassName("road-2")[0]
            ]

            t.el.article = document.getElementsByClassName("article")[0];

            t.el.roads.forEach(function(road, road_i) {
              var path = t.paths[road_i],
                ln = road.getTotalLength()

              t.paths[road_i].length =  ln

              d3.select(road).style({ "stroke-dasharray": ln + "px", "stroke-dashoffset": ln + "px" });

              if(ln !== path.orig_length) {
                var rt = ln/path.orig_length
                t.points[road_i].coordinates_orig.forEach(function(d, i){ t.points[road_i].coordinates.push(d * rt); });
              }
              // t.points[road_i].count = t.points[road_i].coordinates.length - 1;
              // t.points_length += t.points[road_i].count
            })

            // console.log(t)
            t.labels();
            t.bind();
            callback();
          }
          obj_overlay.on("load", function(){ if(++cnt === 2) { callback_onload(); } }, false);
          obj_overlay.property("data", path.template + "assets/map_overlay.svg");
          obj.on("load", function (){ if(++cnt === 2) { callback_onload(); } }, false);
          obj.property("data", path.template + "assets/map.svg");

          return this;
        },
        next: function () { var t = this; t.go_to(t.current_point+1); },
        prev: function () { var t = this; t.go_to(t.current_point-1); },
        go_to: function (index) {
          var t = this,
            tmps = [0.1,0.1],
            i,
            direction = -1
          // console.log("go_to from", t.current_point, ", to ", index);

          if(!isNumeric(index) || typeof index === undefined) { index = t.current_point + 1; }
          // console.log("go_to", index);

          if(index < 0) { index = 0; }
          else if(index > t.points_length) { index = t.points_length; }
          // console.log("go_to", index, t.point.count);

          if(t.current_point !== index) {
            // console.log(t.animating)
            if(t.animating) {
              t.queue = index
              // console.log('queue updated', t.queue)
            } else {
              if(index > t.current_point) { // moving forward
                direction = 1
                for(i = t.current_point+1; i <= index; ++i) {
                  map_index = t.road_map[i]
                  // console.log('map_index', map_index)
                  if(map_index === 1 || map_index === 3) {
                    // console.log('1,3', t.points[0].coordinates[t.point_map[index]], t.point_map[index])
                    tmps[0] += t.points[0].coordinates[t.point_map[i]]
                  }
                  if(map_index === 2 || map_index === 3) {
                    // console.log('2,3')
                    tmps[1] += t.points[1].coordinates[t.point_map[i]]
                  }
                }
              }
              else {
                direction = 0
                for(i = t.current_point; i > index; --i) {
                  map_index = t.road_map[i]
                  // console.log('map_index', map_index)
                  if(map_index === 1 || map_index === 3) {
                    // console.log('inside', t.points[0].coordinates, t.point_map[index])
                    tmps[0] += t.points[0].coordinates[t.point_map[i]]
                  }
                  if(map_index === 2 || map_index === 3) {
                    tmps[1] += t.points[1].coordinates[t.point_map[i]]
                  }
                }
                tmps[0]*=-1
                tmps[1]*=-1
              }
              // console.log(tmps)
               // console.log(t.path.offset, tmp, t.path.length);
              t.paths[0].offset += tmps[0];
              t.paths[1].offset += tmps[1];

              // console.log('next animation')
              t.current_point = index;
              t.animate([t.paths[0].offset, t.paths[1].offset], direction, tmps);
            }
            // console.log('current point', index)
          }

        },

        animate: function (to, direction, currentOffset) {
          var t = this,
            svg = d3.select(t.el.svg)
          t.animating = true

          // console.log(to,direction, currentOffset)
          var transEnd = function() {
            // console.log('animation end')
            if(t.current_point !== t.points_length) {
              svg.select("g[data-point='" + (t.current_point) + "']")
                .classed("active", true);
            }
            t.animating = false
            if(t.queue !== null) {
              var tmp = t.queue
              t.queue = null
              t.go_to(tmp)
            }
          }

          svg.selectAll("g[data-point]").classed("active", false);

          var roadSwitcherFlag
          if(direction === 1) {
            roadSwitcherFlag = currentOffset[1] === 0
          } else {
              roadSwitcherFlag = currentOffset[0] !== 0
          }

          var roadSwitcher = roadSwitcherFlag ? [true, false] : [false, true]
          // console.log( roadSwitcher)
          t.el.roads.forEach(function(rd, rd_i) {
            // console.log(t.current_point > 12 ? 0 : (direction === rd_i ? 1000 : 0))
            var road = d3.select(rd)
            road.style({ "transition": "none", "-webkit-transition" : "none"});

            road.on(transitionEnd, roadSwitcher[rd_i] ? transEnd : null)
            // console.log('transitionEnd', transitionEnd, roadSwitcher[rd_i])
            setTimeout(function () {
              // console.log('key point',t.paths[rd_i].length, to[rd_i])
              road.style("stroke-dashoffset", t.paths[rd_i].length - to[rd_i] + "px");
              road.style({ "transition": "stroke-dashoffset 2s ease-in-out", "-webkit-transition" : "stroke-dashoffset 2s ease-in-out"});
              // console.log('inside animation stroke', rd_i)
            }, t.current_point > 12 ? 0 : (direction === rd_i ? 1000 : 0));
          })
        },
        bind: function () {
          var t = this,
            svg = d3.select(t.el.svg)


          svg.selectAll("g[data-point]")
            .datum(function () { return +d3.select(this).attr("data-point"); })
            .on("click", clicked);
          t.svg_overlay.selectAll("g[data-point]")
            .datum(function () { return +d3.select(this).attr("data-point"); })
            .on("click", clicked);

          d3.selectAll(".sidebar-content .tabs .tab").on("click", function() {
            var t = d3.select(this), p = d3.select(this.parentNode), sidebar = d3.select(this.parentNode.parentNode),
              index = Array.prototype.indexOf.call(this.parentNode.children, this);
            sidebar.selectAll(".tabs-content .tab-content").classed("active", false).filter(function(d,i) { return i === index; }).classed("active", true);
            p.selectAll(".tab").classed("active", false);
            t.classed("active", true)

          });
          d3.selectAll(".sidebar-content .tabs-content .tab-content.map-points li a").datum(function() { return this.dataset.id; })
            .on("click", function(d,i) { sidebar_toggle(); clicked.call(this,d,i); });
        },
        labels: function () {

          var t = this,
            svg = d3.select(t.el.svg),
            ul = d3.select(".sidebar .map-points ul"),
            lis = "",
            tmp

          d3.selectAll(".stories .section .navigation-label").each(function(d,i) {
            tmp = this.textContent.trim();
            t.titles.push(tmp);
            lis +="<li><a href='#' data-id='" + (i + 1) + "'>" + tmp + "</a></li>";
          });
          ul.html(lis);
          svg.selectAll("g[data-point] text").text(function(d, i) { return t.titles[i]; }).call(wrap, 2);

          t.svg_overlay.selectAll("g[data-point]")
            .attr("data-title", function(d, i) { return t.titles[i]; })
            .on('mouseover', function() {
              var point = d3.select(this),
                title = point.attr("data-title"),
                pointContainer = d3.select(this.parentNode)

              if(title) {
                var
                  bbox = this.getBBox(),
                  g = pointContainer.append("g").classed("tip", true),
                  rect = g.append("rect"),
                  text = g.append("text").text(title).call(wrap, 2)



                setTimeout(function() {
                  var
                    textBBox = text.node().getBBox(),
                    space = 5,
                    padding = [8,10,4,10]

                  text.attr({ "x": bbox.x + bbox.width/2 - textBBox.width / 2, "y": bbox.y - (space + padding[2] + textBBox.height) + 12  });
                  text.selectAll("tspan").attr({"x": bbox.x + bbox.width/2 - textBBox.width / 2 });
                  rect.attr({"x": bbox.x + bbox.width / 2 - textBBox.width / 2 - padding[3], "y": bbox.y - (space + padding[2] + textBBox.height +  padding[0]), "width": textBBox.width + padding[1] + padding[3], "height": textBBox.height + padding[0] + padding[2], "rx": "3", "ry": "3" });
                }, 100)


              }
            })
            .on('mouseout', function() {
              d3.select(this.parentNode).select(".tip").remove();
            });
        }
      },
      // anchor = d3.selectAll(".navigation-section").on("click", clicked),
      marker = d3.selectAll(".navigation-marker"),
      markerOffsets,
      markerOffsetsBack = [],
      sidebar = d3.select(".sidebar"),
      redraw_sidebar = false;

    function isNumeric(val) { return Number(parseFloat(val))==val; }



    // helpers
    function whichTransitionEvent(){
      var t,
        el = document.createElement("fakeelement"),
        transitions = {
          "transition"      : "transitionend",
          "OTransition"     : "oTransitionEnd",
          "MozTransition"   : "transitionend",
          "WebkitTransition": "webkitTransitionEnd"
        }

      for (t in transitions){
        if (el.style[t] !== undefined){
          return transitions[t];
        }
      }
    }
    var transitionEnd = whichTransitionEvent();

    function wrap(text, width) {
      text.each(function() {
        // if(d3.select(this).attr("data-multiline")) {
          var text = d3.select(this),
              words = text.text().split(/\s+/),
              word,
              line = [],
              lineNumber = 1,
              lineHeight = 15, // ems
              y = text.attr("y");
            if(words.length <= 3) {
              text.text(words.join(" "));
            }
            else {
              words = words.reverse();
              var tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", 0 + "px");
              while (word = words.pop()) {
                line.push(word);
                tspan.text(line.join(" "));
                if (line.length-1 == width) { //tspan.node().getComputedTextLength() > width
                  line.pop();
                  tspan.text(line.join(" "));
                  line = [word];
                  tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", lineHeight + "px").text(word);
                }
              }
            }

        // }
      });
    }
    // var tip = d3.select("#tip");
    // function show_tooltip(d,i) {
    //   // tip.classed("visible", true);
    //   // tip.style({ top: d3.event.y + "px", left: d3.event.clientX + "px" });
    //    // console.log(this,d,i,d3.event);
    // }
    // function hide_tooltip(d,i) {
    //   // tip.classed("visible", false);
    //   //  console.log(this,d,i,d3.event);
    // }
    var skip = false, scrollDir = 1, scrollYPrev = 0;
    function scrolled() {
      // console.log('scrolled')
      scrollDir = scrollY > scrollYPrev ? 1 : 0;
      if(!skip) {
        var j = Math.max(0, Math.min(markerOffsets.length - 1, d3.bisectLeft( scrollDir ? markerOffsets : markerOffsetsBack , scrollY) - (scrollY === (document.documentElement.scrollHeight || document.body.scrollHeight) - h ? 0 : 1)));
        // console.log(j)
        track.go_to(j);
        d3.selectAll(".map-points a").classed("active", false).filter(function(d,i){ return i === j; }).classed("active", true);
      } else {
        // console.log('scrolled skiped')
      }
      // anchor.classed("navigation-section--active", function(d, i) { return i === j; });
      scrollYPrev = scrollY;
    }


    function resized() {
      var scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight;
      var ar = [],
        beforeOffset = document.getElementsByClassName('subarticle')[0].offsetTop - h()
      markerOffsets = marker.datum(function(d, i) {
        ar.push(this.offsetTop + beforeOffset - 40)
        return this.offsetTop + beforeOffset + 60
         }).data()
      markerOffsets.unshift(0)
      markerOffsetsBack = ar
      markerOffsetsBack.unshift(0)
      scrolled();
      if(redraw_sidebar) {
        d3.select(".sidebar .tabs-content").style("height", function() { return window.innerHeight - this.offsetTop - 50 + "px"; });
      }
    }
    function clicked(d, i) {
      var ind = isNumeric(d) ? d : i;
      var pr = d3.select('.navigation-marker[data-id="' + ind + '"]').node().parentNode.getBoundingClientRect()

      d3.event.preventDefault();
      var offset = d3.interpolateNumber(scrollY, pr.top + scrollY)//d3.select('.navigation-marker[data-id="' + ind + '"]').node().parentNode.getBoundingClientRect().top);
      skip = true;
      navStealthOn = true
      d3.transition().duration(750).tween("scroll", function() {
        return function(t) { scrollTo(0, offset(t)); };
      }).each("end", function() { skip = false;
        navStealthOn = false
        track.go_to(ind);
        d3.selectAll(".map-points a").classed("active", false).filter(function(d,i){ return i === ind; }).classed("active", true);
      /*scrolled();*/ }); //if (!--n) callback.apply(this, arguments);
    }

    function sidebar_toggle() {
      redraw_sidebar = !sidebar.classed("active");
      sidebar.classed("active", redraw_sidebar);
      sidebar.select(".tabs-content").style("height", function() { return window.innerHeight - this.offsetTop - 50 + "px"; });
    }

    track.init(function() {
      d3.select(window)
          .on("resize.navigation", resized)
          .on("load.navigation", resized)
          .on("scroll.navigation", scrolled);

      resized();
    });

    d3.select(".sidebar-toggle").on("click", sidebar_toggle);
  });


/*********************************************************************************************
                                       mobile
**********************************************************************************************/
  if (isMobile())
  {
    mobileReorient();
    defer(function() {
      /* Only do if we're on iPad, iPhone or Android -- TG */
      if (!isMobile()) return false;

      var ipath = path.fullscreen.other.image;
      var spath = path.slideshow.other.image;
      var vpath = path.fullscreen.desktop.video;
      var ppath = path.fullscreen.desktop.poster;

      if (isPhone()) {
        ipath = ipath.replace("mobile_1024", "mobile_640");
        spath  = spath.replace("mobile_1024", "mobile_640");
      }

      d3.select(window)
        .on("resize", mobileReorient)
        .on("scroll", function() {
            d3.select(".navigation") // !!
              .classed("navigation-solid", window.scrollY > 350)
        });

      d3.select(".video-sequence:first-of-type").classed("ios-loaded", true);

      setTimeout(function() {

        var video = d3.selectAll(".section.video-sequence .video")
          .datum(function() { return { video: this.getAttribute("data-video"), image: this.getAttribute("data-image") }; });

        var video_tags = video.select(".video-container").filter(function(d) { return d.video; });
        video_tags.selectAll(".temporary").remove();
        var video_tag = video_tags
          .insert("video", ":first-child")
          .attr("preload", "none")
          .attr("poster", function(d) { return  ppath + d.video + ".jpg"; })
          .property("loop", false)
          .property("controls", true)
          .text("Your browser does not support this video.");

        video_tag.append("source")
          .attr("src", function(d) { return vpath + d.video + ".mp4"; })
          .attr("type", "video/mp4");


        var video_tag = video.select(".video-container").filter(function(d) { return d.image; })
          .select(".re-aspect")
          .attr("src", function(d) { return  ipath + d.image; });



        d3.selectAll(".slideshow").each(function() {
          var container =  d3.select(this).select(".container");
          var captions = container.select('.captions');

          captions.selectAll(".caption").each(function(){
            var t = this;
            if(d3.select(t).text().trim() == "")
            {
              d3.select(t).classed('empty',true);
            }
            captions.insert("div", function() { return t; }).classed("image",true).append("img").attr("src",function(d) { return spath + t.getAttribute("data-image"); });
          });
          container.insert(function(){ return container.select('.description').remove()[0][0]; },".captions");
        });
      }, 200);
    });
    function mobileReorient() {
      var height = window.innerHeight - 40;
      if (height > (720*.59) && window.innerWidth < 768) height = (720*.59);

      var firstVideo = document.querySelector(".video-sequence");
      if(firstVideo !== null && firstVideo.length)
      {
        firstVideo.querySelector(".video:first-of-type .video-container")[0].style.height = height + "px";
        firstVideo.querySelector(".video:first-of-type .video-headline")[0].style.height = height + "px";
      }
      d3.selectAll(".fit").style("height", innerHeight+ "px")
    }
  }
/*********************************************************************************************
                                       desktop
**********************************************************************************************/

/* this scripts included when device is not mobile */
    defer(function() {

    /* Just skip if we're on iPad, iPhone or Android -- TG */
    if (isMobile()) return false;

      var vpath = path.fullscreen.desktop.video;
      var ppath = path.fullscreen.desktop.poster;
      var apath = path.fullscreen.desktop.audio;

    var mute = false,
        muteVolume = "volume",
        fixRatio = innerWidth/innerHeight, //16 / 9,
        fixHeight = innerWidth / fixRatio,
        fixTop = Math.round((innerHeight - fixHeight) / 2),
        fadeTop = Math.max(200, fixTop),
        fadeBottom = Math.min(innerHeight - 200, fixTop + fixHeight)
        // fade = d3.interpolateRgb("#000", "#fff");

   // var headline = d3.select(".navigation-headline");
    // var scrollprompt = d3.select('.scroll-prompt');
    var sequence = d3.selectAll(".video-sequence")
        .datum(function() {
          return {
            first: !this.previousElementSibling,
            audio: this.getAttribute("data-audio"),
            length: this.querySelectorAll(".video").length
          };
        })
        .call(d3.behavior.watch()
          .on("scroll", sequencescrolled)
          .on("statechange", sequencestatechanged));

    sequence.filter(function(d) { return d.audio; }).append("audio")
        .attr("src", function(d) { return apath + d.audio + ".mp3"; })
        .property("loop", true);


    // Add for content to have audio track
    // var section_content = d3.selectAll(".column")
    //     .datum(function() {
    //       return {
    //         audio: this.getAttribute("data-audio")
    //       };
    //     }).call(d3.behavior.watch()
    //       .on("scroll", sequencescrolled)
    //       .on("statechange", sequencestatechanged));


    var section_content = d3.selectAll(".section:not(.video-sequence)[data-audio]")
        .datum(function() {
          return {
            audio: this.getAttribute("data-audio")
          };
        }).call(d3.behavior.watch()
          .on("scroll", sequencescrolled)
          .on("statechange", sequencestatechanged));

    section_content.filter(function(d) { return d.audio; }).append("audio")
        .attr("src", function(d) { return apath + d.audio + ".mp3"; })
        .property("loop", true);
    // content audio end



    var section = d3.selectAll(".video")
        .datum(function() {
          var previous = this.previousElementSibling,
              next = this.nextElementSibling;
          return {
            video: this.getAttribute("data-video"),
            animation: this.hasAttribute("data-animation"),
            loop: this.hasAttribute("data-videoloop"),
            first: !previous || !d3.select(previous).classed("video"),
            last: !next || !d3.select(next).classed("video")
          };
        });

    var sectionFixed = sequence.selectAll(".video")
        .each(function(d) { d.sequence = this.parentNode.__data__; })
        .call(d3.behavior.watch()
          .on("scroll", fixscrolled)
          .on("statechange", fixstatechanged));

    var container = section.select(".video-container");

    var videos = container.filter(function(d) { return d.video; });
      videos.selectAll(".temporary").remove();

    var video = videos.insert("video", ":first-child")
        .attr("preload", "none")
        .attr("poster", function(d) { return  ppath + d.video + ".jpg"; })
        .property("loop", function(d) { return !d.animation; })
        .property("loop", function(d) { return d.loop; })
        .text("Your browser does not support this video.");

    video.append("source")
        .attr("src", function(d) { return vpath + d.video + ".mp4"; })
        .attr("type", "video/mp4");

    if (!supportsViewportUnits()) sectionFixed.append("div")
        .style("height", fixHeight + "px");

    var containerFixed = sectionFixed.select(".video-container")
        .style("z-index", function(d) { return d.first || d.last ? 1 : 2; })
        .style("position", function(d) { return d.first || d.last ? "absolute" : "fixed"; })
        .style("top", function(d,i) { return d.first || d.last ? null : fixTop + "px"; })
        .style("display", function(d) { return d.first || d.last ? null : "none"; });

    containerFixed.select(function(d, i) { return d.sequence.length > 1 ? this : null; }).append("div")
        .attr("class", "video-sequence-indicator")
        .style("margin-top", function(d) { return -d.sequence.length * 1.4 / 2 + "em"; })
        .text(function(d, i) { return d3.range(d.sequence.length).map(function(j) { return i === j ? "●" : "○"; }).join("\n"); });

    var muteButton = d3.select(".navigation-volume").on("click", muted);

    d3.select(window)
        .on("load.video", loaded)
        .on("resize.video", resized);

    d3.select("video").attr("preload", "auto");

    resized();

    function loaded() {
      video.attr("preload", function(d) { return d.first ? "auto" : "none"; });
    }

    function muted() {
      mute = !mute;
      muteVolume = mute ? "_volume" : "volume";
      muteButton.classed("navigation-volume--muted", mute);
      d3.event.preventDefault();
      d3.selectAll("audio,video").interrupt().property("volume", mute
          ? function() { this._volume = this.volume; return 0; }
          : function() { return this._volume; });
    }

    function resized() {
      fixRatio = innerWidth/innerHeight;
      fixHeight = innerWidth / fixRatio;
      fixTop = Math.round((innerHeight - fixHeight) / 2);
      fadeTop = Math.max(200, fixTop);
      fadeBottom = Math.min(innerHeight - 200, fixTop + fixHeight);
      d3.select(".video-sequence:first-child").style("margin-top", fixTop + "px");
       //containerFixed.style("height", fixHeight + "px")


      containerFixed
        .filter(function(d) { //fixHeight
          var rect = this.parentNode.getBoundingClientRect();
          return d.first ? rect.top < fixTop
              : d.last ? rect.bottom >= fixTop + fixHeight
              : true;
        }).style("top","0px");

       var tmp = d3.selectAll(".stories .video-sequence .video")
        .style("height", innerHeight+ "px")
        d3.selectAll(".fit").style("height", innerHeight+ "px")

        tmp.selectAll('.video-container')
          .style("height", innerHeight+ "px")

      // sectionFixed
      //   .style("height", innerHeight+ "px")

      var imgWidth = d3.select(".stories").node().clientWidth - (innerWidth > 1200 ? 55 : 0);
      d3.selectAll(".stories .video-sequence .video img").each(function(){
        d3.select(this).style("width", imgWidth + "px");
        d3.select(this.parentNode).style("width", imgWidth + "px");
      });

      // append height for infographic if height class present
      // if this is a popup interactive, reduce the height more so iframe window is contained within screen
      d3.selectAll(".infographic iframe.height").attr("height", innerHeight);
      d3.selectAll(".infographic .interactive-iframe-popup iframe.height").attr("height", innerHeight-80);



      // fixHeight = innerWidth / fixRatio;
      //  fixTop = Math.round((innerHeight - fixHeight) / 2);
      //  fadeTop = Math.max(200, fixTop);
      //  fadeBottom = Math.min(innerHeight - 200, fixTop + fixHeight);

      //  d3.selectAll(".stories .video-sequence .video img").each(function(){
      //    d3.select(this).style("width", imgWidth + "px");
      //    d3.select(this.parentNode).style("width", imgWidth + "px");
      //  });

    }

    function fixscrolled(d) {
      if (d.first || d.last) {
        //!(d.first && d.last) && () for bug when media section has only one media
        var fixed = !(d.first && d.last) && ((d.first && d3.event.rect.top < 0)
            || (d.last && d3.event.rect.bottom >= 0 + fixHeight));
        d3.select(this.querySelector(".video-container"))
            .style("z-index", fixed ? 2 : 1)
            .style("top", fixed ? fixTop +"px" : null)
            .style("position", fixed ? "fixed" : "absolute");

      }

      var section = d3.select(this),
          container = section.select(".video-container"),
          videoNode = this.querySelector(".video-container video"),
          volume = 1;

      var opacityTop = d3.event.rect.top - fixHeight / 4,
          opacity = opacityTop > fixTop + fixHeight * 4 / 5 ? 0 // previous video fully opaque
            : !d.last && opacityTop < fixTop - fixHeight ? 0 // next video fully covers this video
            : opacityTop < fixTop ? 1 // this video is fully opaque, but may be covered by next video
            : Math.max(0, Math.min(1, 1 - (opacityTop - fixTop) / (fixHeight / 5))); // this video is partially opaque

      if (d.first) {
        // if (videoNode) {
        //   volume = d3.event.rect.top < fixTop + fadeTop ? Math.max(0, Math.min(1, 1 - (d3.event.rect.top - fixTop) / fadeTop)) : 0;
        //   var play = d3.event.rect.top <= fixTop + fadeTop;
        //   if (videoNode.paused) {
        //     if (play && (!d.animation || (videoNode.currentTime < videoNode.duration && volume > .8))) {
        //       videoNode.play();
        //     }
        //   } else if (!play) {
        //     videoNode.pause();
        //   }
        // }
        // container.style("opacity", opacityTop >= fixTop - fixHeight ? 1 : 0);
      } else {
        // console.log(opacity)
        container.style("opacity", opacity);
        if (videoNode) {
          if (videoNode.paused) {
            if (opacity) {
             if (!d.animation || (videoNode.currentTime < videoNode.duration && opacity > .8)) {
                videoNode.play();
              }
            } else if (videoNode.currentTime) {
              videoNode.currentTime = 0;
            }
          } else if (!opacity) {
            videoNode.pause();
            if (videoNode.currentTime) videoNode.currentTime = 0;
          }
        }
      }

      if (d.last) {
        if (videoNode) {
          volume = d3.event.rect.bottom < fadeBottom ? Math.max(0, Math.min(1, 1 - (fadeBottom - d3.event.rect.bottom) / fadeTop)) : 1;
          var play = d3.event.rect.bottom >= fadeBottom - fadeTop;
          if (videoNode.paused) {
            if (play && (!d.animation || (videoNode.currentTime < videoNode.duration && volume > .8))) {
              videoNode.play();
            }
          } else if (!play) {
            videoNode.pause();
          }
        }
      }

      section.select(".video-caption").style("opacity", opacityTop > fixTop ? (d.first ? 1 : Math.max(0, 1 - (opacityTop - fixTop) / (fixHeight / 5))) // fade in from bottom
          : opacityTop > fixTop - fixHeight * 4 / 5 ? 1 // this video is fully opaque and not covered
          : d.last ? 1 : Math.max(0, (opacityTop - fixTop + fixHeight * 4 / 5) / (fixHeight / 5) + 1)); // fade out to top

      if (videoNode) {
        videoNode[muteVolume] = volume = volume !== 1 ? volume // special-case volume for first and last fade
            : opacityTop < fixTop - fixHeight ? 0 // video is fully covered by next video
            : opacityTop < fixTop - fixHeight / 2 ? Math.max(0, Math.min(1, (opacityTop - fixTop + fixHeight) / (fixHeight / 2)))
            : opacity;
        // if (d.first && d.sequence.first) scrollprompt.style("opacity",  volume == 1 ? 1 : (volume-0.7) > 0 ? (volume-0.7) : 0 );
        //if (d.first && d.sequence.first) headline.style("opacity", 1 - volume);
      }
    }

    function fixstatechanged(d) {
      d3.select(this.querySelector(".video-container"))
          .style("display", d3.event.state ? null : "none")
        .select("video")
          .each(function() {
            if (!d3.event.state) {
              if (!this.paused) this.pause();
              if (this.currentTime) this.currentTime = 0;
            }
          });
          // if (d.first && d.sequence.first && !d3.event.state) scrollprompt.style("opacity", 1);
      //if (d.first && d.sequence.first && !d3.event.state) headline.style("opacity", null);
    }

    function sequencescrolled() {
      var opacity = Math.max(0, Math.min(1, d3.event.rect.bottom < fadeBottom ? (fadeBottom - d3.event.rect.bottom) / fadeTop
          : d3.event.rect.top < fixTop + fadeTop ? (d3.event.rect.top - fixTop) / fadeTop
          : 1));

      // bug for column background change deny #if(){ data }
      // if(!d3.select(this).classed("column"))
      // {
      //   d3.select("body").style("background", fade(opacity));
      // }
      d3.select(this).select("audio").property(muteVolume, 1 - opacity);
    }

    function sequencestatechanged() {
      var sequence = d3.select(this),
          audio = sequence.select("audio");
      if (d3.event.state) {
        sequence.selectAll("video").each(function() { this.preload = "auto";});
        audio.each(function() { this.play();  });
      } else {
        d3.select("body").style("background", null);
        audio.each(function() { this.pause(); });
      }
    }

    function supportsViewportUnits() {
      var element = d3.select("body").append("div").style("width", "50vw"),
          expected = innerWidth / 2,
          actual = parseFloat(element.style("width"));
      element.remove();
      return Math.abs(expected - actual) <= 1;
    }

    });



/*********************************************************************************************
                                       slideshow
**********************************************************************************************/
if (!isMobile())
{
  defer(function() {
    var spath = path.slideshow.desktop.image;
    var tpath = path.slideshow.desktop.thumb;

    d3.selectAll(".slideshow").each(function() {
      var currentIndex = 0,
          playInterval;
      var watch = d3.behavior.watch()
          .on("statechange.first", firststatechanged)
          .on("statechange", statechanged);
      var slideshow = d3.select(this).select(".container")
          .on("mouseover", stopPlay)
          .on("mouseout", stopPlay)
          .call(watch);
      var caption = slideshow.select(".captions").selectAll(".caption")
          .datum(function() {
            return {
              image: this.getAttribute("data-image"),
              aspect_ratio_class: this.getAttribute("data-aspect")
            };
          })
          .classed("active", function(d, i) { return i === currentIndex; });
      var images = caption.data();
      var ln = images.length;
      var container = slideshow.insert("div", ".captions")
          .attr("class", "inner-container");
      var image = container.append("div")
          .attr("class", "images")
        .selectAll(".image")
          .data(images)
        .enter().append("img")
          .attr("class", function(d,i) { return "image " + d.aspect_ratio_class; })
      image.filter(function(d, i) { return i === currentIndex; })
          .classed("active", true)
          .attr("src", function(d) { return spath + d.image; })
          .each(moveToFront);
      container.append("div")
          .attr("class", "btn btn-next")
          .on("click", function() { stopPlay(); showNext(); })
         .html("<svg class='arrow' width='45' height='59' viewBox='-13 -21 45 59'><path d='M3,1.008L20.742,9.045L3,17.083L6,8.917Z'></path></svg>");
      container.append("div")
          .attr("class", "btn btn-prev")
          .on("click", function() { stopPlay(); showPrevious(); })
        .html("<svg class='arrow' width='45' height='59' viewBox='-13 -21 45 59'><path d='M18.742,0.758L1,8.795L18.742,16.833L15.742,8.667Z'></path></svg>");
      var thumb = container.insert("div", ".captions")
          .attr("class", "thumbs")
        .selectAll(".thumb")
          .data(images)
        .enter().append("img")
          .classed("thumb",true)
          .classed("active", function(d, i) { return (i === currentIndex); })
          .attr("src",function(d) { return tpath + d.image; })
          .on("click", function(d, i) { stopPlay(); show(i); });
      function firststatechanged() {
        if (d3.event.state) {
          image.attr("src", function(d, i) { return spath + d.image; });
          watch.on("statechange.first", null);
        }
      }
      function statechanged() {
        if (d3.event.state) startPlay();
        else stopPlay();
      }
      function startPlay() { if (!playInterval) playInterval = setInterval(showNext, 7000); }
      function stopPlay() { if (playInterval) playInterval = clearInterval(playInterval); }
      function show(index) {
        var oldImage = d3.select(image[0][currentIndex]),
            oldCaption = d3.select(caption[0][currentIndex]),
            oldThumb = d3.select(thumb[0][currentIndex]),
            newImage = d3.select(image[0][index]),
            newCaption = d3.select(caption[0][index]),
            newThumb = d3.select(thumb[0][index]);
        oldImage.classed("active", false);
        oldCaption.classed("active", false);
        oldThumb.classed("active", false);
        newImage
            .classed("active", true)
            .style("opacity", 0)
            .each(moveToFront);
        newCaption.classed("active", true);
        newThumb.classed("active", true);
        currentIndex = index;
        d3.timer(function() { newImage.style("opacity", null); }, 20);
      }
      function showNext() { show((currentIndex + 1) % ln); }
      function showPrevious() { show((currentIndex ? currentIndex : ln) - 1); }
    });
    function moveToFront() { this.parentNode.appendChild(this); }
  });
}
/*********************************************************************************************
                                       watcher and starter
**********************************************************************************************/
(function() {
  var watched = [];
  d3.behavior.watch = function() {
    var event = d3.dispatch("statechange", "scroll");
    function watch(selection) {
      selection.each(function(i) {
        watched.push({
          element: this,
          state: 0,
          index: i,
          event: event
        });
      });
    }
    return d3.rebind(watch, event, "on");
  };
  if (/iPhone|iPad|iPad|Android/.test(navigator.userAgent) || location.hash == "#ipad") {
    d3.select(window)
        .on("resize.watch", watch_scrolledStatic)
        .on("scroll.watch", watch_scrolled)
        .on("DOMContentLoaded.watch", watch_scrolledStatic);
  } else {
    d3.select(window)
        .on("resize.watch", watch_scrolled)
        .on("scroll.watch", watch_scrolled)
        .on("DOMContentLoaded.watch", watch_scrolled);
  }
  // d3.select(window).on("resize.reheight", reheight);
  // function reheight () {
  //   console.log('reheight')
  //   var h = (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight),
  //     w = (window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth)//,
  //     // aspect_ratio = w/h;
  //     // d3.selectAll(".re-aspect").each(function() {
  //     //   var img = d3.select(this),
  //     //     image_ratio = +img.attr("data-aspectratio"),
  //     //     ver = aspect_ratio > image_ratio;
  //     //   // img.classed("ver", ver).classed("hor", !ver);
  //     // });
  //   // d3.selectAll(".section.section-fullscreen .container > *:first-child").style("height", h + "px");

  // }
  function watch_scrolled () {
    watched.forEach(function(watch) {
      var rect = watch.element.getBoundingClientRect();
      if (rect.top + rect.height < 0 || rect.bottom - rect.height - innerHeight > 0) {
        watch_state(watch, 0);
      } else {
        var t = rect.top / (innerHeight - rect.height);
        watch_state(watch, t < 0 || t > 1 ? 1 : 2);
        watch_dispatch(watch, {type: "scroll", offset: t, rect: rect});
      }
    });
    // On scroll control fixed position of map container,
    // so on scroll if before map will change position
    // else will stay in the begining of subarticle
    d3.select(".map-container").style('height', h() + 'px')

    var wY = this.scrollY,
      eY = d3.select(".subarticle").node().offsetTop,
      eH = d3.select(".subarticle").node().offsetHeight,
      mp = d3.select(".map-container")

    mp.classed('stick-bottom stick-top fixed', false)
    if(wY > eY + eH - mp.node().getBoundingClientRect().height) {
      mp.style("top", null);
      mp.classed('stick-bottom', true)
    } else if(wY < eY) {
      mp.style("top", null);
      mp.classed('stick-top', true)
      // tp = eY - wY
    } else {
      mp.classed('fixed', true)
      tp = 0
      mp.style("top", tp + "px");
    }

  }
  function watch_scrolledStatic () {
    watched.forEach(function(watch) {
      watch_state(watch, 1);
      watch_dispatch(watch, {type: "scroll", offset: .5, rect: {top: 0}}); // XXX rect
    });
  }
  function watch_state (watch, state1) {
    var state0 = watch.state;
    if (state0 !== state1) watch_dispatch(watch, {
      type: "statechange",
      state: watch.state = state1,
      previousState: state0
    });
  }
  function watch_dispatch (watch, event) {
    var element = watch.element,
        sourceEvent = event.sourceEvent = d3.event;
    try {
      d3.event = event;
      watch.event[event.type].call(element, element.__data__, watch.index);
    } finally {
      d3.event = sourceEvent;
    }
  }
  await();
  // reheight();
})();
