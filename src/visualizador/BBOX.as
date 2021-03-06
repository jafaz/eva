package visualizador{
	
	import mx.events.IndexChangedEvent;
	
	public class BBOX{
		
		private var p1:Punto;
		private var p2:Punto;
		
		private var p1Original:Punto;
		private var p2Original:Punto;
		
		private static var limiteMINX:int = -180;
		private static var limiteMAXX:int = 180;
		private static var limiteMINY:int = -90;
		private static var limiteMAXY:int = 90;
		

		
		public function BBOX(x1:Number, y1:Number, x2:Number, y2:Number){
		/*	this.p1 = new Punto(x1,y1);
			this.p2 = new Punto(x2,y2);
			this.p1Original = new Punto(x1,y1);
			this.p2Original = new Punto(x2,y2);*/
			this.p1 = new Punto(x1,y1);
			this.p2 = new Punto(x2,y2);
			this.p1Original = new Punto(x1,y1);
			this.p2Original = new Punto(x2,y2);
		}
		
		
		public function set(p1:Punto, p2:Punto):void{
			this.p1 = p1;
			this.p2 = p2;
		}
		
		public function getA():Punto{
			return p1;
		} 
		
		public function getB():Punto{
			return p2;
		}
		
		public function restart():void{
			this.p1.cambia(this.p1Original);
			this.p2.cambia(this.p2Original);
		}
		
		public function setOriginal():void{
			this.p1Original.cambia(this.p1);
			this.p2Original.cambia(this.p2);
		}
		
		public function recalculaBBOX(w:int, h:int):void{
			var alto:Number = this.p1.distanciaY(this.p2);
			var ancho:Number = this.p1.distanciaX(this.p2);
			//var q:Number = ancho/alto;
			var p:Number = w/h;
			var puntoMedio:Punto = new Punto(this.p1.getX()+(ancho/2), this.p1.getY()+(alto/2));
			var a:Number;
			var lim:Number;	

			
			if ( p < ancho/alto ){
				ancho = p * alto;
				if ( ancho > 90 ){
					ancho = 180;
					alto = ancho / p;
				}
				if ( alto > 180 ){
					alto = 180;
					ancho = p * alto;
				}
			}else{
				alto = ancho / p;
				if ( alto > 180 ){
					alto = 180;
					ancho = p * alto;
				}
				if ( ancho > 180 ){
					ancho = 180;
					alto = ancho / p;
				}
			}
			
			var pm:Punto = this.p1.puntoMedio(this.p2);
		/*	this.p1.set( pm.getX() - ancho/2, pm.getY() - alto/2 );
			this.p2.set (pm.getX() + ancho/2, pm.getY() + alto/2);*/
			this.p1.set( pm.getX() - ancho/2,  pm.getY() + alto/2);
			this.p2.set (pm.getX() + ancho/2, pm.getY() - alto/2);
			
		}
		
		
		public function zoom(valor:int):void{
			var distancia:Punto = this.p1.distancia(this.p2);
			var constante:Number = 1.5;
						
			if ( valor > 0 ){
				distancia.setX( distancia.getX() / constante  );
				distancia.setY( distancia.getY() / constante  );
			}else{
				distancia.setX( distancia.getX() * constante   );
				distancia.setY( distancia.getY() * constante   );
			}
			
			var pm:Punto = this.p1.puntoMedio(this.p2);			
			this.p1.set( pm.getX() - distancia.getX()/2, pm.getY() - distancia.getY()/2 );
			this.p2.set( pm.getX() + distancia.getX()/2, pm.getY() + distancia.getY()/2 );
		}
		
		public function toString(separador:String):String{
			return this.p1.tostring(separador)+separador+this.p2.tostring(separador);
		}
		
		public function imprimeOrden(separador:String):String{
			return p1.getX()+separador+p2.getY()+separador+
				p2.getX()+separador+p1.getY();
		}
		
		public function traslada(a:Punto, b:Punto, w:int, h:int):void{
			trace(a.tostring(","));
			trace(b.tostring(","));
			
			var distancia:Punto = p1.distancia(p2);
			/*
			this.p1.setX( this.p1.getX() - ( a.distancia(b).getX() * (distancia.getX() / w)));
			this.p1.setY( this.p1.getY() + ( a.distancia(b).getY() * (distancia.getY() / h)));
			this.p2.setX( this.p1.getX() + distancia.getX() );			
			this.p2.setY( this.p1.getY() + distancia.getY() );
			*/
		    this.p1.setX( this.p1.getX() + ( a.distancia(b).getX() * (distancia.getX() / w)));
			this.p1.setY( this.p1.getY() + ( a.distancia(b).getY() * (distancia.getY() / h)));
			this.p2.setX( this.p1.getX() + distancia.getX() );			
			this.p2.setY( this.p1.getY() + distancia.getY() ); 
		
		}
		
		
		public function xy2longlat(a:Punto, w:int, h:int):Punto{
			var distanciaBbox:Punto = p1.distancia(p2);
			var distX:int = a.getX() * distanciaBbox.getX() / w;
			var distY:int = a.getY() * distanciaBbox.getY() / h;
			//trace( p1.tostring(",")+"    " + p2.tostring(","));
			var xx:Number = (distanciaBbox.getX()*a.getX()/w)+p1.getX();
			var yy:Number = (distanciaBbox.getY()*a.getY()/h)+p1.getY();
			return ( new Punto(xx,yy ));
		}
		
		

	}
}