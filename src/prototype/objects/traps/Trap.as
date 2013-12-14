package prototype.objects.traps
{
    import main.Main;

    import prototype.entities.Player;

    import starling.display.Image;
    import starling.textures.Texture;

    public class Trap extends Image
    {
        public var chance:Number; // 0-1
        public var damage:int;

        public var title:String;
        public var description:String;

        public function Trap(texture:Texture)
        {
            super(texture);




        }

        public function apply(player:Player):void
        {

        }
    }
}
