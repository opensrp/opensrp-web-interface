var DonutWidget = function (element, options) {
    if (element && element instanceof jQuery) {
        if ($(element).length > 1) {
            for (var i = 0; i < $(element).length; i++) {
                this.init(element[i], options);
            }
        }
        else {
            this.init(element, options);
        }
    }
};
DonutWidget.defaults = {
    max: 100
    , value: 0
    , text: ""
    , rotate: 0
    , caption: ""
    , colors: {
        primary: "#ffe600"
        , background: "#eee"
    }
    , size: "normal"
};
DonutWidget.instances = 0;
DonutWidget.prototype = {
    constructor: DonutWidget
    , init: function (element, options) {
        var self = this;
        this.options = $.extend({}, DonutWidget.defaults, options);
        this.$element = $(element);
        if (this.$element.attr("data-chart-instance")) {
            this.instanceID = this.$element.attr("data-chart-instance");
        }
        else {
            DonutWidget.instances++;
            this.instanceID = DonutWidget.instances;
        }
        this.paint();
        return this;
    }
    , paint: function () {
        var template = [
            '<div class="donut-hole"><span class="donut-filling"></div>'
            , '<div class="donut-bite" data-segment-index="0"></div>'
            , '<div class="donut-bite" data-segment-index="1"></div>'
            , '<div class="donut-caption-wrapper"><span class="donut-caption"></span></div>'
        ].join('');
        this.$element.html(template);
        if (!this.$element.hasClass("donut-widget")) {
            this.$element.addClass("donut-widget");
        }
        this.$element.addClass(this.options.size);
        this.$element.attr("data-chart-instance", this.instanceID);
        this.setSegments();
        this.setPoints();
        this.setText();
        this.setAttributes();
    }
    , setSegments: function () {
        this.segments = {
            0: ["0", this.options.value, this.options.colors.primary]
            , 1: [this.options.value, this.options.max - this.options.value, this.options.colors.background]
        };
    }
    , setPoints: function () {
        for (var i = 0; i < Object.keys(this.segments).length; i++) {
            var s = this.segments[i];
            this.points = {};
            var start = ((s[0] / this.options.max) * 360) + this.options.rotate;
            var deg = ((s[1] / this.options.max) * 360);
            if (!this.$element.find(".donut-bite.large").length) {
                if (s[1] >= (this.options.max / 2)) {
                    this.$element.find(".donut-bite[data-segment-index='0']").addClass("large");
                }
                else {
                    this.$element.find(".donut-bite[data-segment-index='1']").addClass("large");
                }
            }
            this.setStyle(start, deg, s, i);
        }
    }
    , setStyle: function (start, deg, segment, index) {
        if (!$("#dynamic").length) {
            $("<style type='text/css' id='dynamic' />").appendTo("head");
        }
        var selector = ".donut-widget[data-chart-instance='" + this.instanceID + "']";
        if (this.$element.attr("id")) {
            selector = "#" + this.$element.attr("id");
        }
        this.selector = selector;
        this.removeStyle(index);
        var style = $("#dynamic").text() + "/*Style for " + this.instanceID + "_" + index + "*/" + selector + " .donut-bite[data-segment-index=\"" + index + "\"]{-moz-transform:rotate(" + start + "deg);-ms-transform:rotate(" + start + "deg);-webkit-transform:rotate(" + start + "deg);-o-transform:rotate(" + start + "deg);transform:rotate(" + start + "deg);}" + selector + " .donut-bite[data-segment-index=\"" + index + "\"]:BEFORE{-moz-transform:rotate(" + deg + "deg);-ms-transform:rotate(" + deg + "deg);-webkit-transform:rotate(" + deg + "deg);-o-transform:rotate(" + deg + "deg);transform:rotate(" + deg + "deg); background-color: " + segment[2] + ";}" + selector + " .donut-bite[data-segment-index=\"" + index + "\"]:BEFORE{ background-color: " + segment[2] + ";}" + selector + " .donut-bite[data-segment-index=\"" + index + "\"].large:AFTER{ background-color: " + segment[2] + ";}";
        style += "/*Style End for " + this.instanceID + "_" + index + "*/";
        $("#dynamic").text(style);
    }
    , removeStyle: function (index) {
        var style = $("#dynamic").text();
        var split = style.split("/*Style for " + this.instanceID + "_" + index + "*/");
        if (split.length != 1) {
            var part1 = split[0];
            var part2 = split[1].split("/*Style End for " + this.instanceID + "_" + index + "*/")[1];
            $(dynamic).text(part1 + part2);
        }
    }
    , setText: function () {
        if (!this.options.text) {
            this.options.text = Math.round(((this.options.value / this.options.max) * 100)) + "%";
        }
        this.$element.find(".donut-filling").text(this.options.text);
        this.$element.find(".donut-caption").text(this.options.caption);
    }
    , setAttributes: function () {
        this.$element.attr("data-chart-max", this.options.max);
        this.$element.attr("data-chart-value", this.options.value);
        this.$element.attr("data-chart-text", this.options.text);
        this.$element.attr("data-chart-rotate", this.options.rotate);
        this.$element.attr("data-chart-caption", this.options.caption);
        this.$element.attr("data-chart-primary", this.options.colors.primary);
        this.$element.attr("data-chart-background", this.options.colors.background);
        this.$element.attr("data-chart-size", this.options.size);
    },
    redraw: function(options){
       return this.init(this.$element, $.extend({},this.options, options));
    }
}
DonutWidget.draw = function (element, options) {
    if (!element) {
        element = $(".donut-widget")
    }
    var results = [];
    for (var i = 0; i < element.length; i++) {
        var doptions = {};
        if ($(element[i]).data("chart-max")) {
            doptions.max = $(element[i]).data("chart-max");
        }
        if ($(element[i]).data("chart-value")) {
            doptions.value = $(element[i]).data("chart-value");
        }
        if ($(element[i]).data("chart-text")) {
            doptions.text = $(element[i]).data("chart-text");
        }
        if ($(element[i]).data("chart-rotate")) {
            doptions.rotate = $(element[i]).data("chart-rotate");
        }
        if ($(element[i]).data("chart-caption")) {
            doptions.caption = $(element[i]).data("chart-caption");
        }
        if ($(element[i]).data("chart-primary")) {
            doptions.colors = doptions.colors || {};
            doptions.colors.primary = $(element[i]).data("chart-primary");
        }
        if ($(element[i]).data("chart-background")) {
            doptions.colors = doptions.colors || {};
            doptions.colors.background = $(element[i]).data("chart-background");
        }
        if ($(element[i]).data("chart-size")) {
            doptions.size = $(element[i]).data("chart-size");
        }
        results.push(new DonutWidget($(element[i]), $.extend(doptions, options)));
    }
    if(results.length == 1){
        results = results[0];
    }
    return results;
};
DonutWidget.redraw = function (element, options) {
    return DonutWidget.draw(element, options);
};
/* 
 * jQuery plugin Implementation 
 */
$.fn.DonutWidget = function (option) {
    return this.each(function () {
        var $this = $(this);
        var data = $this.data("$donut");
        var options = null;
        if(data){
            options = $.extend({}, data.options, option);
        }
        else{
            options = typeof option === 'object' && option;
        }
        $this.donut = data;
        $this.data("$donut", (data = new DonutWidget($(this), options)));
        
    })
};
$.fn.DonutWidget.Constructor = DonutWidget;