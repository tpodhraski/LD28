package prototype.entities.enemies
{
    import main.Main;

    import starling.display.Image;
    import starling.textures.Texture;

    public class Enemy extends Image
    {
        public static var ENEMIES:Array = [EnemyEater];

        public var health:int;
        public var damage:int;
        public var walk:int;
        public var walkRecharge:int;

        public function Enemy(texture:Texture)
        {
           super(texture);

        }

        public function changeLocation(x:int, y:int):void
        {
            this.x = x;
            this.y = y;


        }
    }
}
