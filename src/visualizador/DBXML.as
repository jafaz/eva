package visualizador{
	import mx.messaging.management.Attribute;
	
	public class DBXML{
		
		private var db:XML;
		private var name:String;
		private var title:String;
		private var _capas:Array;
		private var _bbox:BBOX;
		private var projection:String;
		private var _urlServidor:String;
		private static var mapaMexico:Boolean = true;
		
		
		public function DBXML(db:XML){
			if ( db is XML ){
				this.db = db;
				_capas = xml2WMSLayers();
				_bbox = procesaBbox();
				_urlServidor = db.Service.OnlineResource.attributes()[1];	
			}else{
				throw new Error("La peticion del archivo de capas al servidor WMS no es un XML: \n"+db);
			}
			
		}
		
		private function procesaBbox():BBOX{
			if ( db.Capability.Layer.LatLonBoundingBox[0] is XML ){
				var bboxTmp:BBOX;
				if ( mapaMexico ){
					bboxTmp = new BBOX(-119,33,-86,14)
				}else{
					bboxTmp =new BBOX(
						db.Capability.Layer.LatLonBoundingBox.attribute("minx"),
						db.Capability.Layer.LatLonBoundingBox.attribute("maxy"),
						db.Capability.Layer.LatLonBoundingBox.attribute("maxx"),
						db.Capability.Layer.LatLonBoundingBox.attribute("miny"));
				}	
				return bboxTmp;
				/*return new BBOX(
					db.Capability.Layer.LatLonBoundingBox.attribute("minx"),
					db.Capability.Layer.LatLonBoundingBox.attribute("miny"),
					db.Capability.Layer.LatLonBoundingBox.attribute("maxx"),
					db.Capability.Layer.LatLonBoundingBox.attribute("maxy"));*/
			}else{
				throw new Error("La peticion del archivo de capas al servidor WMS es erronea");
			}
		}
		/*
		private function xml2WMSLayer():Array{
			var xmlLayers:XMLList = db.Capability.Layer.Layer.(@queryable == "1");
			
			
			
			
			if ( xmlLayers.length() > 0 ){			
				var capas:Array =   new Array(xmlLayers.length());
				var wmsLayer:WMSLayer;
				var i:int = 0;
				var layer:XML;
				for each ( layer in xmlLayers ){
					//if ( layer.child("SRS") == "EPSG:4326"){
					//trace( layer.child("SRS").toString());
					
					//capas.push(new WMSLayer(layer));
					capas[i] = new WMSLayer(layer);
					i++;
					//}
					
				}
				return capas;
			}else{
				throw new Error("La peticion del archivo de capas al servidor WMS es erroneaddd");
			}
		}
		*/
		
		private function xml2WMSLayers():Array{
			var xmlLayers:XMLList = db.Capability.Layer.Layer.(@queryable == "1");
			
			if ( xmlLayers.length() > 0 ){		
				
				var capasTML:Array = new Array();
					
				var capas:Array =   new Array(xmlLayers.length());
				var wmsLayer:WMSLayer;
				var i:int = 0;
				var layer:XML;
				for each ( layer in xmlLayers ){
					
					if ( layer.child("SRS") == "EPSG:4326"){
						capasTML.push(new WMSLayer(layer));
						//capasTML.push( new WMSLayer(layer) );
						trace( layer.child("SRS").toString());
					}
			
					
					
				}
				
				
				capas = new Array(capasTML.length);
				
				var capita:WMSLayer;	
					
				for each ( capita  in capasTML ){
					capas[i] = capita;
					i++;
				}
				
				return capas;
			}else{
				throw new Error("La peticion del archivo de capas al servidor WMS es erroneaddd");
			}
		}

		
		public function get capas():Array{
			return _capas;
		}
		
		public function get bbox():BBOX{
			return _bbox;
		}
			
		public function get urlservidor():String{
			return _urlServidor;
		}
		
		
	

	}
}