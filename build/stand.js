(function (console) { "use strict";
var App = function() {
	this.document = window.document;
	this.stand = { width : 10, height : 10, holes : []};
	this.surface = new Surface(this.document.getElementById("canvas"));
	App.switchState(new state_Menu(this.surface));
};
App.switchState = function(newState) {
	if(App.currentState != null) {
		App.currentState.destroy();
		App.currentState = null;
	}
	newState.create();
	App.currentState = newState;
};
App.checkFloat = function(element,minVal) {
	if(minVal == null) minVal = 0;
	var number = parseFloat(element.value);
	if(!isFinite(number) || number < minVal) number = minVal;
	element.value = number;
	return number;
};
App.createButton = function(text,callback) {
	var button = window.document.createElement("button");
	button.innerHTML = text;
	button.onclick = callback;
	return button;
};
App.createLabel = function(text) {
	var label = window.document.createElement("label");
	label.innerHTML = text;
	return label;
};
App.createInputText = function(value) {
	var input = window.document.createElement("input");
	input.type = "text";
	input.value = value;
	return input;
};
var HxOverrides = function() { };
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
var Main = function() { };
Main.main = function() {
	new App();
};
var Surface = function(canvas) {
	this.mousePressing = false;
	this.inToPx = 10;
	this.elements = [];
	this.canvas = canvas;
	canvas.onmousedown = $bind(this,this.mousedown);
	canvas.onmouseup = $bind(this,this.mouseup);
	canvas.onmousemove = $bind(this,this.mousemove);
	canvas.onmouseleave = $bind(this,this.mouseleave);
};
Surface.prototype = {
	add: function(element) {
		console.log("Adding");
		this.elements.push(element);
		this.draw();
	}
	,remove: function(element) {
		HxOverrides.remove(this.elements,element);
		this.draw();
	}
	,removeAll: function() {
		this.elements.splice(0,this.elements.length);
		this.draw();
	}
	,draw: function() {
		console.log("Drawing surface");
		console.log(this.elements);
		var context = this.canvas.getContext("2d",null);
		this.clear(context);
		var _g = 0;
		var _g1 = this.elements;
		while(_g < _g1.length) {
			var elt = _g1[_g];
			++_g;
			elt.draw(context);
		}
	}
	,clear: function(context) {
		context.clearRect(0,0,context.canvas.width,context.canvas.height);
	}
	,getPosOnCanvas: function(clientX,clientY) {
		var rect = this.canvas.getBoundingClientRect();
		return { x : clientX - rect.left, y : clientY - rect.top};
	}
	,mousedown: function(event) {
		this.mousePressing = true;
	}
	,mouseup: function(event) {
		this.mousePressing = false;
		if(this.elementDragged != null) this.elementDragged = null;
	}
	,mousemove: function(event) {
		if(this.elementDragged == null) return;
		var pos = this.getPosOnCanvas(event.clientX,event.clientY);
		console.log(pos);
	}
	,mouseleave: function(event) {
		this.mousePressing = false;
		if(this.elementDragged != null) this.elementDragged = null;
	}
};
var element_IElement = function() { };
var element_Dogbone = function(x,y,draggable,callback,width,height,radius) {
	this.x = x;
	this.y = y;
	this.draggable = draggable;
	this.callback = callback;
	this.width = width;
	this.height = height;
	this.radius = radius;
};
element_Dogbone.__interfaces__ = [element_IElement];
element_Dogbone.prototype = {
	draw: function(context) {
		var xLeftBone = this.x + this.radius;
		var xRightBone = this.x + this.width - this.radius;
		var yTopBone = this.y;
		var yBottomBone = this.y + this.height;
		console.log("Drawing dogbone");
		context.beginPath();
		context.rect(this.x,this.y,this.width,this.height);
		context.fillStyle = "0x000000";
		context.fill();
		context.lineWidth = 1;
		context.strokeStyle = "0x000000";
		context.stroke();
		context.arc(xLeftBone,yTopBone,this.radius,Math.PI,2 * Math.PI,false);
		context.fillStyle = "0x000000";
		context.fill();
		context.stroke();
		context.arc(xLeftBone,yTopBone,this.radius,0,Math.PI,false);
		context.fillStyle = "0x000000";
		context.fill();
		context.stroke();
		context.arc(xRightBone,yTopBone,this.radius,Math.PI,2 * Math.PI,false);
		context.fillStyle = "0x000000";
		context.fill();
		context.stroke();
		context.arc(xRightBone,yTopBone,this.radius,0,Math.PI,false);
		context.fillStyle = "0x000000";
		context.fill();
		context.stroke();
	}
};
var element_Rectangle = function(x,y,draggable,callback,width,height,lineWidth,lineColor,fillColor) {
	if(lineColor == null) lineColor = 0;
	if(lineWidth == null) lineWidth = 1;
	this.x = x;
	this.y = y;
	this.draggable = draggable;
	this.callback = callback;
	this.width = width;
	this.height = height;
	this.fillColor = fillColor;
	this.lineWidth = lineWidth;
	this.lineColor = lineColor;
};
element_Rectangle.__interfaces__ = [element_IElement];
element_Rectangle.prototype = {
	draw: function(context) {
		console.log("Drawing rectangle");
		context.beginPath();
		context.rect(this.x,this.y,this.width,this.height);
		if(this.fillColor != null) {
			context.fillStyle = this.fillColor;
			context.fill();
		}
		context.lineWidth = this.lineWidth;
		context.strokeStyle = this.lineColor;
		context.stroke();
	}
};
var state_IState = function() { };
var state_Custom = function(surface,widthInInch,heightInInch) {
	if(heightInInch == null) heightInInch = 0;
	if(widthInInch == null) widthInInch = 0;
	console.log("Final custom.");
	this.container = window.document.getElementById("finalization");
	this.surface = surface;
	this.setWidth(widthInInch);
	this.setHeight(heightInInch);
};
state_Custom.__interfaces__ = [state_IState];
state_Custom.prototype = {
	create: function() {
		this.createButtons();
		var wR = this.width * this.surface.inToPx;
		var hR = this.height * this.surface.inToPx;
		this.rectangle = new element_Rectangle(5,5,false,null,wR,hR);
		this.surface.add(this.rectangle);
		var elt = new element_Dogbone(100,100,false,null,100,10,20);
		this.surface.add(elt);
	}
	,setWidth: function(widthInInch) {
		this.width = Math.max(state_Custom.MIN_WIDTH,widthInInch);
	}
	,setHeight: function(heightInInch) {
		this.height = Math.max(state_Custom.MIN_WIDTH,heightInInch);
	}
	,destroy: function() {
		this.container.innerHTML = "";
		this.surface.removeAll();
	}
	,displayMenu: function() {
		App.switchState(new state_Menu(this.surface));
	}
	,displayFinal: function() {
		App.switchState(new state_Final(this.surface,this.width,this.height));
	}
	,setSize: function() {
		this.setWidth(App.checkFloat(this.iptWidth,state_Custom.MIN_WIDTH));
		this.setHeight(App.checkFloat(this.iptHeight,state_Custom.MIN_WIDTH));
		this.rectangle.width = this.width * this.surface.inToPx;
		this.rectangle.height = this.height * this.surface.inToPx;
		this.surface.draw();
	}
	,createButtons: function() {
		this.container.appendChild(App.createButton("Menu",$bind(this,this.displayMenu)));
		this.container.appendChild(App.createButton("Next",$bind(this,this.displayFinal)));
		this.container.appendChild(App.createLabel("Width:"));
		this.iptWidth = App.createInputText(this.width);
		this.container.appendChild(this.iptWidth);
		this.container.appendChild(App.createLabel("Height:"));
		this.iptHeight = App.createInputText(this.height);
		this.container.appendChild(this.iptHeight);
		this.container.appendChild(App.createButton("Set size",$bind(this,this.setSize)));
	}
};
var state_Final = function(surface,width,height) {
	console.log("Final state.");
	this.container = window.document.getElementById("finalization");
	this.surface = surface;
};
state_Final.__interfaces__ = [state_IState];
state_Final.prototype = {
	create: function() {
		this.createButtons();
	}
	,destroy: function() {
		this.container.innerHTML = "";
		this.surface.removeAll();
	}
	,displayCustom: function() {
		App.switchState(new state_Custom(this.surface));
	}
	,displayMenu: function() {
		App.switchState(new state_Menu(this.surface));
	}
	,generateStand: function(width,height) {
	}
	,createButtons: function() {
		this.container.appendChild(App.createButton("Customize",$bind(this,this.displayCustom)));
	}
};
var state_Menu = function(surface) {
	console.log("Menu state.");
	this.container = window.document.getElementById("menu");
	this.surface = surface;
};
state_Menu.__interfaces__ = [state_IState];
state_Menu.prototype = {
	create: function() {
		this.createButtons();
	}
	,destroy: function() {
		this.container.innerHTML = "";
		this.surface.removeAll();
	}
	,displayCustom: function() {
		App.switchState(new state_Custom(this.surface));
	}
	,createButtons: function() {
		var btnCustom = window.document.createElement("button");
		btnCustom.innerHTML = "Customize";
		btnCustom.onclick = $bind(this,this.displayCustom);
		this.container.appendChild(btnCustom);
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
state_Custom.MIN_WIDTH = 3;
state_Custom.MIN_HEIGHT = 3;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
