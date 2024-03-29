(function() {
  var $, MAX_ZINDEX, util, _ref, _ref1,
    __hasProp = {}.hasOwnProperty,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Xray = {};

  if (!($ = window.jQuery)) {
    return;
  }

  MAX_ZINDEX = 2147483647;

  Xray.init = (function() {
    if (Xray.initialized) {
      return;
    }
    Xray.initialized = true;
    $(document).keydown(function(e) {
      if (e.ctrlKey && e.metaKey && e.keyCode === 88) {
        if (Xray.isShowing) {
          Xray.hide();
        } else {
          Xray.show();
        }
      }
      if (Xray.isShowing && e.keyCode === 27) {
        return Xray.hide();
      }
    });
    return $(function() {
      new Xray.Overlay;
      Xray.findTemplates();
      return typeof console !== "undefined" && console !== null ? console.log("Ready to Xray. Press cmd+ctrl+x to scan your UI.") : void 0;
    });
  })();

  Xray.specimens = function() {
    return Xray.ViewSpecimen.all.concat(Xray.TemplateSpecimen.all);
  };

  Xray.constructorInfo = function(constructor) {
    var func, info, _ref;

    if (window.XrayPaths) {
      _ref = window.XrayPaths;
      for (info in _ref) {
        if (!__hasProp.call(_ref, info)) continue;
        func = _ref[info];
        if (func === constructor) {
          return JSON.parse(info);
        }
      }
    }
    return null;
  };

  Xray.findTemplates = function() {
    return util.bm('findTemplates', function() {
      var $templateContents, comment, comments, el, id, path, _, _i, _len, _ref, _results;

      comments = $('*:not(iframe,script)').contents().filter(function() {
        return this.nodeType === 8 && this.data.slice(0, 10) === "XRAY START";
      });
      _results = [];
      for (_i = 0, _len = comments.length; _i < _len; _i++) {
        comment = comments[_i];
        _ref = comment.data.match(/^XRAY START (\d+) (.*)$/), _ = _ref[0], id = _ref[1], path = _ref[2];
        $templateContents = new jQuery;
        el = comment.nextSibling;
        while (!(!el || (el.nodeType === 8 && el.data === ("XRAY END " + id)))) {
          if (el.nodeType === 1 && el.tagName !== 'SCRIPT') {
            $templateContents.push(el);
          }
          el = el.nextSibling;
        }
        if ((el != null ? el.nodeType : void 0) === 8) {
          el.parentNode.removeChild(el);
        }
        comment.parentNode.removeChild(comment);
        _results.push(Xray.TemplateSpecimen.add($templateContents, {
          name: path.split('/').slice(-1)[0],
          path: path
        }));
      }
      return _results;
    });
  };

  Xray.open = function(path) {
    return $.ajax({
      url: "/_xray/open?path=" + path
    });
  };

  Xray.show = function(type) {
    if (type == null) {
      type = null;
    }
    return Xray.Overlay.instance().show(type);
  };

  Xray.hide = function() {
    return Xray.Overlay.instance().hide();
  };

  Xray.toggleSettings = function() {
    return Xray.Overlay.instance().settings.toggle();
  };

  Xray.Specimen = (function() {
    Specimen.add = function(el, info) {
      if (info == null) {
        info = {};
      }
      return this.all.push(new this(el, info));
    };

    Specimen.remove = function(el) {
      var _ref;

      return (_ref = this.find(el)) != null ? _ref.remove() : void 0;
    };

    Specimen.find = function(el) {
      var specimen, _i, _len, _ref;

      if (el instanceof jQuery) {
        el = el[0];
      }
      _ref = this.all;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        specimen = _ref[_i];
        if (specimen.el === el) {
          return specimen;
        }
      }
      return null;
    };

    Specimen.reset = function() {
      return this.all = [];
    };

    function Specimen(contents, info) {
      if (info == null) {
        info = {};
      }
      this.makeLabel = __bind(this.makeLabel, this);
      this.el = contents instanceof jQuery ? contents[0] : contents;
      this.$contents = $(contents);
      this.name = info.name;
      this.path = info.path;
    }

    Specimen.prototype.remove = function() {
      var idx;

      idx = this.constructor.all.indexOf(this);
      if (idx !== -1) {
        return this.constructor.all.splice(idx, 1);
      }
    };

    Specimen.prototype.isVisible = function() {
      return this.$contents.length && this.$contents.is(':visible');
    };

    Specimen.prototype.makeBox = function() {
      var _this = this;

      this.bounds = util.computeBoundingBox(this.$contents);
      this.$box = $("<div class='xray-specimen " + this.constructor.name + "'>").css(this.bounds);
      if (this.$contents.css('position') === 'fixed') {
        this.$box.css({
          position: 'fixed',
          top: this.$contents.css('top'),
          left: this.$contents.css('left')
        });
      }
      this.$box.click(function() {
        return Xray.open(_this.path);
      });
      return this.$box.append(this.makeLabel);
    };

    Specimen.prototype.makeLabel = function() {
      return $("<div class='xray-specimen-handle " + this.constructor.name + "'>").append(this.name);
    };

    return Specimen;

  })();

  Xray.ViewSpecimen = (function(_super) {
    __extends(ViewSpecimen, _super);

    function ViewSpecimen() {
      _ref = ViewSpecimen.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ViewSpecimen.all = [];

    return ViewSpecimen;

  })(Xray.Specimen);

  Xray.TemplateSpecimen = (function(_super) {
    __extends(TemplateSpecimen, _super);

    function TemplateSpecimen() {
      _ref1 = TemplateSpecimen.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    TemplateSpecimen.all = [];

    return TemplateSpecimen;

  })(Xray.Specimen);

  Xray.Overlay = (function() {
    Overlay.instance = function() {
      return this.singletonInstance || (this.singletonInstance = new this);
    };

    function Overlay() {
      var _this = this;

      Xray.Overlay.singletonInstance = this;
      this.bar = new Xray.Bar('#xray-bar');
      this.settings = new Xray.Settings('#xray-settings');
      this.shownBoxes = [];
      this.$overlay = $('<div id="xray-overlay">');
      this.$overlay.click(function() {
        return _this.hide();
      });
    }

    Overlay.prototype.show = function(type) {
      var _this = this;

      if (type == null) {
        type = null;
      }
      this.reset();
      Xray.isShowing = true;
      return util.bm('show', function() {
        var element, specimens, _i, _len, _results;

        _this.bar.$el.find('#xray-bar-togglers .xray-bar-btn').removeClass('active');
        if (!_this.$overlay.is(':visible')) {
          $('body').append(_this.$overlay);
          _this.bar.show();
        }
        switch (type) {
          case 'templates':
            Xray.findTemplates();
            specimens = Xray.TemplateSpecimen.all;
            _this.bar.$el.find('.xray-bar-templates-toggler').addClass('active');
            break;
          case 'views':
            specimens = Xray.ViewSpecimen.all;
            _this.bar.$el.find('.xray-bar-views-toggler').addClass('active');
            break;
          default:
            Xray.findTemplates();
            specimens = Xray.specimens();
            _this.bar.$el.find('.xray-bar-all-toggler').addClass('active');
        }
        _results = [];
        for (_i = 0, _len = specimens.length; _i < _len; _i++) {
          element = specimens[_i];
          if (!element.isVisible()) {
            continue;
          }
          element.makeBox();
          element.$box.css({
            zIndex: Math.ceil(MAX_ZINDEX * 0.9 + element.bounds.top + element.bounds.left)
          });
          _this.shownBoxes.push(element.$box);
          _results.push($('body').append(element.$box));
        }
        return _results;
      });
    };

    Overlay.prototype.reset = function() {
      var $box, _i, _len, _ref2;

      _ref2 = this.shownBoxes;
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        $box = _ref2[_i];
        $box.remove();
      }
      return this.shownBoxes = [];
    };

    Overlay.prototype.hide = function() {
      Xray.isShowing = false;
      this.$overlay.detach();
      this.reset();
      return this.bar.hide();
    };

    return Overlay;

  })();

  Xray.Bar = (function() {
    function Bar(el) {
      this.$el = $(el);
      this.$el.css({
        zIndex: MAX_ZINDEX
      });
      this.$el.find('#xray-bar-controller-path .xray-bar-btn').click(function() {
        return Xray.open($(this).attr('data-path'));
      });
      this.$el.find('.xray-bar-all-toggler').click(function() {
        return Xray.show();
      });
      this.$el.find('.xray-bar-templates-toggler').click(function() {
        return Xray.show('templates');
      });
      this.$el.find('.xray-bar-views-toggler').click(function() {
        return Xray.show('views');
      });
      this.$el.find('.xray-bar-settings-btn').click(function() {
        return Xray.toggleSettings();
      });
    }

    Bar.prototype.show = function() {
      this.$el.show();
      this.originalPadding = parseInt($('html').css('padding-bottom'));
      if (this.originalPadding < 40) {
        return $('html').css({
          paddingBottom: 40
        });
      }
    };

    Bar.prototype.hide = function() {
      this.$el.hide();
      return $('html').css({
        paddingBottom: this.originalPadding
      });
    };

    return Bar;

  })();

  Xray.Settings = (function() {
    function Settings(el) {
      this.displayUpdateMsg = __bind(this.displayUpdateMsg, this);
      this.save = __bind(this.save, this);
      this.toggle = __bind(this.toggle, this);      this.$el = $(el);
      this.$el.find('form').submit(this.save);
    }

    Settings.prototype.toggle = function() {
      return this.$el.toggle();
    };

    Settings.prototype.save = function(e) {
      var editor,
        _this = this;

      e.preventDefault();
      editor = this.$el.find('#xray-editor-input').val();
      return $.ajax({
        url: '/_xray/config',
        type: 'POST',
        data: {
          editor: editor
        },
        success: function() {
          return _this.displayUpdateMsg(true);
        },
        error: function() {
          return _this.displayUpdateMsg(false);
        }
      });
    };

    Settings.prototype.displayUpdateMsg = function(success) {
      var $msg,
        _this = this;

      if (success) {
        $msg = $("<span class='xray-settings-success xray-settings-update-msg'>Success!</span>");
      } else {
        $msg = $("<span class='xray-settings-error xray-settings-update-msg'>Uh oh, something went wrong!</span>");
      }
      this.$el.append($msg);
      return $msg.delay(2000).fadeOut(500, function() {
        $msg.remove();
        return _this.toggle();
      });
    };

    return Settings;

  })();

  util = {
    bm: function(name, fn) {
      var result, time;

      time = new Date;
      result = fn();
      return result;
    },
    computeBoundingBox: function($contents) {
      var $el, boxFrame, el, frame, _i, _len;

      if ($contents.length === 1 && $contents.height() <= 0) {
        return util.computeBoundingBox($contents.children());
      }
      boxFrame = {
        top: Number.POSITIVE_INFINITY,
        left: Number.POSITIVE_INFINITY,
        right: Number.NEGATIVE_INFINITY,
        bottom: Number.NEGATIVE_INFINITY
      };
      for (_i = 0, _len = $contents.length; _i < _len; _i++) {
        el = $contents[_i];
        $el = $(el);
        if (!$el.is(':visible')) {
          continue;
        }
        frame = $el.offset();
        frame.right = frame.left + $el.outerWidth();
        frame.bottom = frame.top + $el.outerHeight();
        if (frame.top < boxFrame.top) {
          boxFrame.top = frame.top;
        }
        if (frame.left < boxFrame.left) {
          boxFrame.left = frame.left;
        }
        if (frame.right > boxFrame.right) {
          boxFrame.right = frame.right;
        }
        if (frame.bottom > boxFrame.bottom) {
          boxFrame.bottom = frame.bottom;
        }
      }
      return {
        left: boxFrame.left,
        top: boxFrame.top,
        width: boxFrame.right - boxFrame.left,
        height: boxFrame.bottom - boxFrame.top
      };
    }
  };

}).call(this);
