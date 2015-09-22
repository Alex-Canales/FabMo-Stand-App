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
App.prototype = {
	displayUI: function(id) {
		var ids = ["menu","custom","finalization"];
		var _g = 0;
		while(_g < ids.length) {
			var i = ids[_g];
			++_g;
			this.document.getElementById(i).style.display = "none";
		}
		this.document.getElementById(id).style.display = "block";
	}
	,displayMenu: function() {
		this.displayUI("menu");
	}
	,displayCustom: function() {
		this.displayUI("custom");
	}
	,displayFinalization: function(width,height,holes) {
		this.displayUI("finalization");
		this.stand.width = width;
		this.stand.height = height;
		this.stand.holes = holes;
	}
	,setButtons: function() {
		this.document.getElementById("go-custom").onclick = $bind(this,this.displayCustom);
		this.document.getElementById("go-finalize").onclick = $bind(this,this.displayFinalization);
		this.document.getElementById("back-custom").onclick = $bind(this,this.displayCustom);
		this.document.getElementById("back-menu").onclick = $bind(this,this.displayMenu);
		this.document.getElementById("back-menu2").onclick = $bind(this,this.displayMenu);
	}
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
		this.rectangle = new element_Rectangle(5,5,false,null,this.width,this.height);
		this.surface.add(this.rectangle);
	}
	,setWidth: function(widthInInch) {
		widthInInch = Math.max(state_Custom.MIN_WIDTH,widthInInch);
		this.width = widthInInch * this.surface.inToPx;
	}
	,setHeight: function(heightInInch) {
		heightInInch = Math.max(state_Custom.MIN_WIDTH,heightInInch);
		this.height = heightInInch * this.surface.inToPx;
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
		this.rectangle.width = this.width;
		this.rectangle.height = this.height;
		this.surface.draw();
	}
	,createButtons: function() {
		var btnMenu = window.document.createElement("button");
		btnMenu.innerHTML = "Menu";
		btnMenu.onclick = $bind(this,this.displayMenu);
		this.container.appendChild(btnMenu);
		var btnFinal = window.document.createElement("button");
		btnFinal.innerHTML = "Next";
		btnFinal.onclick = $bind(this,this.displayFinal);
		this.container.appendChild(btnFinal);
		var lblWidth = window.document.createElement("label");
		lblWidth.innerHTML = "Width:";
		this.container.appendChild(lblWidth);
		this.iptWidth = window.document.createElement("input");
		this.iptWidth.type = "text";
		this.iptWidth.value = this.width / this.surface.inToPx;
		this.container.appendChild(this.iptWidth);
		var lblHeight = window.document.createElement("label");
		lblHeight.innerHTML = "Height:";
		this.container.appendChild(lblHeight);
		this.iptHeight = window.document.createElement("input");
		this.iptHeight.type = "text";
		this.iptHeight.value = this.height / this.surface.inToPx;
		this.container.appendChild(this.iptHeight);
		var btnSet = window.document.createElement("button");
		btnSet.innerHTML = "Set size";
		btnSet.onclick = $bind(this,this.setSize);
		this.container.appendChild(btnSet);
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
		var btnCustom = window.document.createElement("button");
		btnCustom.innerHTML = "Customize";
		btnCustom.onclick = $bind(this,this.displayCustom);
		this.container.appendChild(btnCustom);
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
