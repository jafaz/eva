package visualizador{
	public class Punto{

		private var x:Number;
		private var y:Number;
		
		public function Punto(x:Number, y:Number){
			this.x = x;
			this.y = y;
		}
		
		public function set(x:Number, y:Number):void{
			this.x = x;
			this.y = y;
		}
		public function getX():Number{
			return this.x;
		}
		
		public function getY():Number{
			return this.y;
		}
		
				
		public function setX(n:Number):Number{
			this.x = n;
			return this.x;
		}
		
		public function setY(n:Number):Number{
			this.y = n;
			return this.y;
		}
			
		public function puntoMedio(p:Punto):Punto{
			return new Punto( this.x + distanciaX(p)/2, this.y + distanciaY(p)/2 );
		}
		
		public function cambia(p:Punto):void{
			this.x = p.getX();
			this.y = p.getY();
		}

		public function distancia(p:Punto):Punto{
			return new Punto( p.getX() - this.x, p.getY() - this.y );
		}
		public function distanciaX(p:Punto):Number{
			return p.getX() - this.x;
		}
		
		public function distanciaY(p:Punto):Number{
			return p.getY() - this.y;
		}
		
		public function tostring(separador:String):String{
			return this.x+separador+this.y;
		}
		
		public function igual(p:Punto):Boolean{
			return this.x == p.getX() && this.y == p.getY();
		}
		
	}
}