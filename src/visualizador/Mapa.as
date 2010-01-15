package visualizador{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.TextArea;
	import mx.core.Container;
	import mx.managers.PopUpManager;
	
	public class Mapa{
		private var db:DBXML;
		private var layers:Array;
		private var generaURLWMS:WMSQuery;
		private var w:int = 500;
		private var h:int = 350;
		private var bbox:BBOX;
		//private var _capaBase:WMSLayer;
		
		public function Mapa(db:DBXML, w:int, h:int){
			this.db = db;
			this.w = w;
			this.h = h;
			this.layers = db.capas;
			this.bbox = db.bbox;
			//this.bbox = new BBOX(-119,14, -86, 33);
			//trace(this.bbox.toString(","));
			this.bbox.recalculaBBOX(w,h);
			this.bbox.setOriginal();
			//trace(this.bbox.toString(","));
			this.generaURLWMS = new WMSQuery(db.urlservidor,this.w,this.h,4,this.bbox,10);
			//setCapaBase();
		
			var aa:int = -118.24 / 5;
			//trace(this.bbox.getA().getX()+" - "+this.bbox.getB().getX());
			//trace(this.bbox.getA().getY()+" - "+this.bbox.getB().getY());
		}
		
		
		/*
		public function setCapaBase():void{
			var capa:WMSLayer;
			var hayCapaBase:Boolean = false;
			for each ( capa in this.layers ){
					//trace(capa.nombre);
					if ( capa.nombre == 'unigeo:estados' ){
					 	hayCapaBase = true;
					 	capa.titulo = 'CapaBase';
					 	capa.metadato = "";
					 	capa.urlSimbologia = "visualizador/img.png"
					 	this._capaBase = capa;
					}
				}
			if ( !hayCapaBase )
				this._capaBase = null;
		}
		*/
		
		/*
		public function get capaBase():WMSLayer{
			return this._capaBase;
		}
		*/
		public function anchoBBox():Number{
			return Math.abs( this.bbox.getA().getX() - this.bbox.getB().getX() );
		}
		
		
		
		public function calculaReticula():Array{
			var tmp:Array = new Array();
			var minX:int = this.bbox.getB().getX() / 5;
			minX = minX * 5;
			if ( minX <= this.bbox.getB().getX())
				minX = minX + 5;
			
			var minY:int = this.bbox.getB().getY() /5;
			minY = minY * 5;
			
			if ( minY <= this.bbox.getB().getY() )
				minY = minX + 5;
			
			var distanciaBBoxX:Number = Math.abs( this.bbox.getA().getX() - this.bbox.getB().getX() );
			var distanciaBBoxY:Number = Math.abs( this.bbox.getA().getY() - this.bbox.getB().getY() );
			
			var cincogradosPixelX:Number = 5 * this.w / distanciaBBoxX;
			var cincogradosPixelY:Number = 5 * this.h / distanciaBBoxY;
			
			var porcentajeMinX:Number = Math.abs(this.bbox.getA().getX() - minX) * 100 / distanciaBBoxX;
			var porcentajeMinY:Number = Math.abs(this.bbox.getA().getY() - minY) * 100 / distanciaBBoxY;
			
			tmp.push(cincogradosPixelX);
			tmp.push(cincogradosPixelY);
			tmp.push(porcentajeMinX);
			tmp.push(porcentajeMinY);
			
			return tmp;
		}
		
		public function daCapasWMS():Array{
			return this.layers;
		}
		
		public function daQUERY():WMSQuery{
			return this.generaURLWMS;
		}
		
		public function daUrlDD(tipo:String):String{	
			var tmp:String = "";
			var hayCapas:Boolean = false;
				for each ( capa in this.layers ){
					var capa:WMSLayer = capa;
					if ( capa.seleccionada ){
						//if ( this._capaBase == null || capa.nombre != this._capaBase.nombre ){
							hayCapas = true;
							tmp = tmp + capa.nombre + ",";
						//}
					}
				}
			tmp = tmp.substr(0,tmp.length-1);
				//trace(tmp);
				
			/*tmp = "http://132.248.26.13:8080/geos/wfs?request=GetFeature&version=1.1.0&typeName="+tmp+"&BBOX="+
				this.bbox.imprimeOrden(",")+"&outputFormat=SHAPE-ZIP";*/
				
			tmp = "http://132.248.26.13:8080/drilldown/service?bbox=" +this.bbox.imprimeOrden(",") +"&" + 
					"outputFormat="+tipo+"&"+ 
					"layers="+tmp+"&" + 
					"width="+this.w+"&"+
					"height="+this.h+"&"+
					"includeMetadata=false";//true";	
				//trace(tmp);
			if (!hayCapas)
				tmp = "";
			return tmp;	
		}
		
		public function pan(p1:Punto, p2:Punto):void{
			this.bbox.traslada(p1, p2, this.w, this.h);
			actualizaCapas();
			//trace(this.bbox.toString(','));
		}
		
		public function daPunto(a:Punto):Punto{
			return this.bbox.xy2longlat(a, w, h);
		}
		
		public function actualizaCapas():void{
			var capa:WMSLayer;
			for (var i:int; i < this.layers.length; i++){
				capa = this.layers[i];
				if (capa.seleccionada){
					//trace(capa.title);
					capa.pintaMapa(this.generaURLWMS);
				}
			}
		}
		
		
		public function zoom(tipo:int):void{
			this.bbox.zoom(tipo);
			actualizaCapas();
			//trace(this.bbox.toString(','));
		}
		
		public function reiniciaMapa():void{
			this.bbox.restart();
			actualizaCapas();
		}
		
		public function regresaInfo(x:int, y:int, cont:Container):void{
			var capa:WMSLayer;
			var capas:Array = new Array();
			for( var i:int; i < this.layers.length; i++){
				capa = this.layers[i];
				if ( capa.seleccionada ){
					capas.push(this.layers[i]);
				}
			}
			var loader:URLLoader = new URLLoader();
			var url:String = this.generaURLWMS.creaURLInfoCapas(x,y,capas);
			try{
				loader.load(new URLRequest(url));
			}catch (error:*){
					trace("error");
			}
			loader.addEventListener(Event.COMPLETE, 
					function(e:Event):void{
						var inf:String = e.target.data;						
						var win:infoMapa = PopUpManager.createPopUp(cont, infoMapa, true) as infoMapa;
						var areaTexto:TextArea = win.getChildByName('txt') as TextArea;
						areaTexto.text = inf;
                		PopUpManager.centerPopUp(win);
					} );
		}
	}
}