package visualizador{
	
	import visualizador.BBOX;
	
	public class WMSQuery{
		
		private var server:String;
		private var urls:Array;
		private var width:int;
		private var height:int;
		private var modulo:int;
		private var bbox:Array;
		private var bbox1:BBOX;

		
		public function WMSQuery(server:String, width:int, height:int, modulo:int,
			 newBbox:BBOX, zomm:int){
				this.server = server;
				this.width = width;
				this.height = height;
				this.modulo = modulo;
				this.bbox1 = newBbox;
		}
		


		
		public function creaURLsTmp(layer:WMSLayer):String{		
			var url:String = "";			
			url = this.server + "?"+
				formatea("LAYERS",layer.nombre)+
				formatea("STYLES","" )+
				formatea("HEIGHT", this.height.toString() )+
				formatea("WIDTH", this.width.toString() )+
				formatea("SRS","EPSG%3A4326")+
				formatea("FORMAT","image%2Fpng")+
				formatea("SERVICE","WMS")+
				formatea("VERSION","1.1.1")+
				formatea("REQUEST","GetMap")+
				formatea("EXCEPTIONS","application%2Fvnd.ogc.se_inimage" )+
				formatea("BBOX",this.bbox1.imprimeOrden(","))+//this.bbox1.toString(","))+
				formatea("TRANSPARENT","TRUE");
			return url;		
		}
		

		
		
		public function creaURLInfoCapas(x:int, y:int, listaCapas:Array):String{
			var url:String = "";
			var capas:String ="";
			var i:int;
			for (i = 0; i < listaCapas.length; i++ ){
				if ( capas == ""){
					capas = listaCapas[i].nombre;
				}else{
					capas = capas+","+listaCapas[i].nombre;
				}
			}
			
			url = this.server + "?"+
				formatea("REQUEST","GetFeatureInfo")+
				formatea("format", "jpeg")+
				formatea("info_format", "text/plain")+
				formatea("styles","" )+
				formatea("VERSION","1.1.1" )+
				formatea("SRS","EPSG:4326")+
				formatea("query_layers", capas)+
				formatea("layers",capas)+
				formatea("BBOX",this.bbox1.imprimeOrden(","))+
				formatea("WIDTH", this.width.toString() )+
				formatea("HEIGHT", this.height.toString() )+
				formatea("x",x.toString())+
				formatea("y",y.toString())+
				formatea("FEATURE_COUNT",listaCapas.length.toString());
			return url;	
		}
		
	
		public function formatea(variable:String, valor:String):String{
			return variable+"="+valor+"&";
		}

	}
}