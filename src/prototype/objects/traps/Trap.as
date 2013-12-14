package prototype.objects.traps
{
    import main.Main;

    import prototype.Xorshift;

    import prototype.entities.Player;

    import starling.display.Image;
    import starling.textures.Texture;

    public class Trap extends Image
    {
        public var chance:Number = 0.5; // 0-1
        public var damage:int = 1;

        public var title:String;
        public var description:String;

        public function Trap(texture:Texture)
        {
            super(texture);
        }

        public function apply(player:Player, random:Xorshift):Boolean
        {
            if (random.randomPercent() < chance) return true;

            return false;

        }
    }
}
