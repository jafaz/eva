package visualizador{

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Bindable]
	public class WMSLayer{
		private var name:String;
		private var title:String;
		private var urlMetadata:String;
		private var urlLegend:String;
		private var legeng:String;
		private var	metadata:String;
		private var urlMap:String;
		private var tmpBBOX:BBOX;
		private var capaActiva:Boolean;
		private var tmp:int;
		
		private static var mensajeMetadato:String = "Cargando Metadato...";
		
		public function WMSLayer(layer:XML){
			this.tmp =0;
			if ( layer.length() > 0 && layer.child("Name").length() > 0 ){
				
				
				this.name = layer.Name;
				
				this.urlMetadata = layer.MetadataURL.OnlineResource.attributes()[1];
				//this.urlMetadata = "http://132.248.26.13";
				this.urlLegend = layer.Style.LegendURL.OnlineResource.attributes()[1];
				
				if ( layer.child("Title").length() > 0 )
					this.title = layer.Title;
				else
					this.title = layer.Name;
				
				if ( this.urlMetadata == null )
					this.metadata = "No se ha encuntrado metadato dispolible";
				else{
					this.metadata = mensajeMetadato;
				}
				if ( this.urlLegend == null )
					this.legeng = "img.png";
				
				this.seleccionada = false;
				this.urlMap = 'img.png';
			}else{
				throw new Error("Problema con el XML");
			}
		}
		
		[Bindable(event="cambiaTitulo")]
		public function get titulo():String{
			return this.title;
		}
		
		public function set titulo(title:String):void{
			dispatchEvent(new Event("cambiaTitulo"));
			this.title = title;
		}
		
		[Bindable(event="cambiaUrlSimbologia")]
		public function get urlSimbologia():String{
			return this.urlLegend;
		}
		
		public function set urlSimbologia(url:String):void{
			this.urlLegend = url;
			dispatchEvent(new Event("cambiaUrlSimbologia"));
		}
		
		[Bindable(event="cambiaUrlMapa")]
		public function get urlMapa():String{
			return this.urlMap;
		}
		
		public function set urlMapa(url:String):void{
			this.urlMap = url;
			dispatchEvent(new Event("cambiaUrlMapa"));
		}
		[Bindable (event="cambiaEstado")]
		public function get seleccionada():Boolean{
			return this.capaActiva;
		}
		
		public function set seleccionada(estado:Boolean):void{
			this.capaActiva = estado;
			dispatchEvent(new Event("cambiaEstado"));
		}
		

		
		public function selecciona(q:WMSQuery):void{
			trace("la capa esta seleccionada: "+this.seleccionada);
			if ( this.seleccionada != true )
				pintaMapa(q);
				this.seleccionada = !this.seleccionada;			
		}
		
		public function pintaMapa(q:WMSQuery):void{
			this.urlMapa = q.creaURLsTmp(this);
		}

		public function get nombre():String{
			return this.name;
		}
		
		[Bindable(event="metadato")]		
		public function get urlMetadato():String{
			return urlMetadata;
		}
		
		public function set urlMetadato(url:String):void{
			this.urlMetadata = null;
			dispatchEvent(new Event("HayMetadato"));
		}
		
		
		public function set metadato(texto:String):void{
			this.metadata = texto;
			dispatchEvent(new Event("cambiaMetadato"));
		}
		

		public function get metadato():String{
			if ( this.metadata == mensajeMetadato && this.urlMapa != null && tmp == 0){
				tmp++;
				daMetadato();
			}
			return this.metadata;
		}
		
		[Bindable(event="HayMetadato")]
		public function get hayMetadato():Boolean{
			if ( this.urlMetadata != null )
				return true;
			return false;
		}
		
		
		[Bindable(event="cambiaMetadato")]
		public function daMetadato():void{
			//trace(this.urlMetadato);
			if ( this.urlMetadata != null){
				if ( this.metadata == mensajeMetadato ){
					var loader:URLLoader = new URLLoader();
					try{
						loader.load(new URLRequest(this.urlMetadato));
					}catch (error:*){
						trace("Problemas de conexion con el servidor de Metadatos");
					}
					var capa:WMSLayer = this;
					loader.addEventListener(Event.COMPLETE,
						function(e:Event):void{
							try{
								var met:XML = XML(e.target.data);
								var metadato:String = met.idinfo.descript.abstract;
								if (metadato != ""){
									capa.metadato = metadato;
									this.metadato = met.idinfo.descript.abstract;
								}else{
									capa.urlMetadato = null;
									//trace(this.urlMetadata);
									capa.metadato = "El metadato no se encuentra disponible por el momento000";
								}
							}catch(error:Error){
								trace("error");
								capa.urlMetadato = null;
								capa.metadato = "El metadato no se encuentra disponible por el momento";
							}
						});
				}
			}
		}
		
		
		
	}
}